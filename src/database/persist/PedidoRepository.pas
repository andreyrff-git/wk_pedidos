unit PedidoRepository;

interface

uses
  System.Generics.Collections, FireDAC.Comp.Client, Data.DB, System.SysUtils, DMConnection,
  FireDAC.Stan.Param, model.TPedidoDadosGerais, model.TPedidoProdutos, model.TPedidoCompleto;

type
  TPedidoRepository = class
  private
    FConnection: TFDConnection;
    FTransaction: TFDTransaction;
    function BuscarItensDoPedido(NumeroPedido: Integer): TObjectList<TPedidoProdutos>;
  public
    constructor Create();
    destructor Destroy; override;

    function GravaPedido(Pedido: TPedidoDadosGerais): Integer;
    function GravaItemPedido(Item: TPedidoProdutos): Boolean;
    function UltimoCodigoPedido: Integer;
    function BuscarPedidoCompletoPorNumero(NrPedido: Integer): TPedidoCompleto;
    function CancelarPedido(nrpedido: Integer): Boolean;
    procedure Commit;
    procedure Rollback;
    procedure StartTransaction;
  end;

implementation

{ TPedidoRepository }

constructor TPedidoRepository.Create();
begin
  inherited Create;
  FConnection := DM.FDConnection;
  FTransaction := TFDTransaction.Create(nil);
  FTransaction.Connection := FConnection;
  FConnection.Transaction := FTransaction;
end;

destructor TPedidoRepository.Destroy;
begin
  FTransaction.Free;
  inherited;
end;

function TPedidoRepository.BuscarItensDoPedido(NumeroPedido: Integer): TObjectList<TPedidoProdutos>;
var
  Query: TFDQuery;
  ListaItens: TObjectList<TPedidoProdutos>;
  ItensPed: TPedidoProdutos;
begin
  ListaItens := TObjectList<TPedidoProdutos>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text :=
      'SELECT nrpedido, codproduto, quantidade, valor_unitario, valor_total ' +
      'FROM pedidos_produtos WHERE nrpedido = :numero_pedido';
    Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    Query.Open;
    while not Query.Eof do
    begin
      ItensPed := TPedidoProdutos.Create;
      ItensPed.NumeroPedido := NumeroPedido;
      ItensPed.CodProduto := Query.FieldByName('produto_codigo').AsInteger;
      ItensPed.Quantidade := Query.FieldByName('quantidade').AsInteger;
      ItensPed.ValorUnitario := Query.FieldByName('valor_unitario').AsCurrency;
      ItensPed.ValorTotal := Query.FieldByName('valor_total').AsCurrency;
      ListaItens.Add(ItensPed);
      Query.Next;
    end;
    Result := ListaItens;
  finally
    Query.Free;
  end;
end;

function TPedidoRepository.BuscarPedidoCompletoPorNumero(NrPedido: Integer): TPedidoCompleto;
var
  Query: TFDQuery;
  Item: TPedidoProdutos;
begin
  Query := DM.CriaQuery;
  try
    try
      Query.Connection := FConnection;
      Query.SQL.Text :=
        'SELECT ' +
        '  pg.nrpedido, ' +
        '  pg.codcliente, ' +
        '  pg.data_emissao,  ' +
        '  pg.vrtotal AS valor_total_pedido, ' +
        '  c.nome AS cliente_nome ' +
        'FROM pedido_geral pg  ' +
        'INNER JOIN clientes c ON pg.codcliente = c.codigo ' +
        'WHERE pg.nrpedido = :nrpedido';
      Query.ParamByName('nrpedido').AsInteger := NrPedido;
      Query.Open;

      if not Query.IsEmpty then
      begin
        Result := TPedidoCompleto.Create;
        Result.Pedido.NumeroPedido := Query.FieldByName('nrpedido').AsInteger;
        Result.Pedido.DataEmissao := Query.FieldByName('data_emissao').AsDateTime;
        Result.Pedido.ClienteCodigo := Query.FieldByName('codcliente').AsInteger;
        Result.Cliente.Codigo := Query.FieldByName('codcliente').AsInteger;
        Result.Cliente.Nome := Query.FieldByName('cliente_nome').AsString;

        Query.Close;
        Query.SQL.Text :=
          'SELECT i.nrpedido, i.codproduto, i.quantidade, i.vrunitario, i.vrtotal, p.descricao AS descricao_produto ' +
          'FROM pedidos_produtos i '+
          'INNER JOIN produtos p ON i.codproduto = p.codigo  ' +
          'WHERE i.nrpedido = :nrpedido';
        Query.ParamByName('nrpedido').AsInteger := NrPedido;
        Query.Open;

        while not Query.Eof do
        begin
          Item := TPedidoProdutos.Create;
          Item.NumeroPedido  := Query.FieldByName('nrpedido').AsInteger;
          Item.CodProduto := Query.FieldByName('codproduto').AsInteger;
          Item.Quantidade    := Query.FieldByName('quantidade').AsInteger;
          Item.ValorUnitario := Query.FieldByName('vrunitario').AsCurrency;
          Item.ValorTotal    := Query.FieldByName('vrtotal').AsCurrency;
          //Descri��o do produto vai no obj TProduto do TPedidoCompleto
          Result.Produto.Descricao := Query.FieldByName('descricao_produto').AsString;
          Result.PedidoProdutos.Add(Item);
          Query.Next;
        end;
      end
      else
      begin
        result := nil;
      end;

    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao buscar o pedido.'+#13+Format('Erro [%s]: %s', [E.ClassName, E.Message]));
      end;
    end;

  finally
    Query.Free;
  end;
end;

function TPedidoRepository.CancelarPedido(nrPedido: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    Query.SQL.Text := 'DELETE FROM pedidos_produtos WHERE nrpedido = :numero_pedido';
    Query.ParamByName('numero_pedido').AsInteger := nrPedido;
    Query.ExecSQL;

    Query.SQL.Text := 'DELETE FROM pedido_geral WHERE nrpedido = :numero_pedido';
    Query.ParamByName('numero_pedido').AsInteger := nrPedido;
    Query.ExecSQL;

    Result := True;
  finally
    Query.Free;
  end;
end;

procedure TPedidoRepository.Commit;
begin
  if FConnection.InTransaction then
    FConnection.Commit;
end;

procedure TPedidoRepository.Rollback;
begin
  if FConnection.InTransaction then
    FConnection.Rollback;
end;

procedure TPedidoRepository.StartTransaction;
begin
  if not FConnection.InTransaction then
      FConnection.StartTransaction;
end;

function TPedidoRepository.UltimoCodigoPedido: Integer;
var
  Query: TFDQuery;
begin
  Result := -1;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS NewNrPedido';
    Query.Open;
    if not Query.IsEmpty then
      Result := Query.FieldByName('NewNrPedido').AsInteger;
  finally
    Query.Free;
  end;
end;

function TPedidoRepository.GravaPedido(Pedido: TPedidoDadosGerais): Integer;
var
  Query: TFDQuery;
begin
  Result := -1;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text :=
      'INSERT INTO pedido_geral (codcliente, vrtotal, data_emissao) ' +
      'VALUES (:codcliente, :vrtotal, :data_emissao) '+
      'ON DUPLICATE KEY UPDATE '+
        'vrtotal = VALUES(vrtotal), '+
        'codcliente = VALUES(codcliente) ';
    Query.ParamByName('codcliente').AsInteger := Pedido.ClienteCodigo;
    Query.ParamByName('vrtotal').AsCurrency := Pedido.ValorTotal;
    Query.ParamByName('data_emissao').AsDateTime := Pedido.DataEmissao;
    Query.ExecSQL;

    // Captura o ID do pedido rec�m-inserido
    Result := UltimoCodigoPedido;
  finally
    Query.Free;
  end;
end;

function TPedidoRepository.GravaItemPedido(Item: TPedidoProdutos): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text :=
      'INSERT INTO pedidos_produtos (nrpedido, codproduto, quantidade, vrunitario, vrtotal) ' +
      'VALUES (:nrpedido, :codproduto, :quantidade, :vrunitario, :vrtotal) '+
      'ON DUPLICATE KEY UPDATE '+
        'quantidade = VALUES(quantidade), '+
        'vrunitario = VALUES(vrunitario), '+
        'vrtotal = VALUES(quantidade) * VALUES(vrunitario)';

    Query.ParamByName('nrpedido').AsInteger := Item.NumeroPedido;
    Query.ParamByName('codproduto').AsInteger := Item.CodProduto;
    Query.ParamByName('quantidade').AsInteger := Item.Quantidade;
    Query.ParamByName('vrunitario').AsCurrency := Item.ValorUnitario;
    Query.ParamByName('vrtotal').AsCurrency := Item.ValorTotal;

    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

end.

