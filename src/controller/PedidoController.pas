unit PedidoController;

interface

uses
   System.Generics.Collections, Data.DB, System.SysUtils,
   PedidoRepository, model.TPedidoDadosGerais, model.TPedidoProdutos,
   model.TPedidoCompleto;

type
  TPedidoController = class
  private
    FRepository: TPedidoRepository;
  public
    constructor Create(ARepository: TPedidoRepository);
    function GravaPedido(Pedido: TPedidoDadosGerais; Itens: TList<TPedidoProdutos>; var num_pedido: Integer): Boolean;
    function BuscarPedidoCompleto(NrPedido: Integer): TPedidoCompleto;
    function CancelaPedido(nrPedido: Integer): Boolean;
  end;

implementation

{ TPedidoController }

function TPedidoController.BuscarPedidoCompleto(NrPedido: Integer): TPedidoCompleto;
begin
  Result := FRepository.BuscarPedidoCompletoPorNumero(NrPedido);
end;

function TPedidoController.CancelaPedido(nrPedido: Integer): Boolean;
begin
  Result := False;
  try
    if FRepository.CancelarPedido(nrPedido) then
    begin
      FRepository.Commit;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      FRepository.Rollback;
      raise Exception.Create('Erro ao excluir o pedido.'+#13+Format('Erro [%s]: %s', [E.ClassName, E.Message]));
    end;
  end;
end;

constructor TPedidoController.Create(ARepository: TPedidoRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TPedidoController.GravaPedido(Pedido: TPedidoDadosGerais; Itens: TList<TPedidoProdutos>; var num_pedido: Integer): Boolean;
begin
  Result := False;
  FRepository.StartTransaction;
  try
    num_pedido := FRepository.GravaPedido(Pedido);

    for var Item in Itens do
    begin
      Item.NumeroPedido := num_pedido;
      FRepository.GravaItemPedido(Item);
    end;

    FRepository.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      FRepository.Rollback;
      raise Exception.Create('Erro ao gravar o pedido.'+#13+Format('Erro [%s]: %s', [E.ClassName, E.Message]));
    end;
  end;
end;

end.

