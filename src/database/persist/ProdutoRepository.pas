unit ProdutoRepository;

interface

uses
  System.Generics.Collections, model.TProduto, FireDAC.Comp.Client, Data.DB, DMConnection;

type
  TProdutoRepository = class
  public
    function CarregaTodos: TObjectList<TProduto>;
    function BuscarPorCodigo(const Codigo: string): TProduto;
    function BuscarPorDescricao(const Descricao: string): TObjectList<TProduto>;
  end;

implementation

{ TProdutoRepository }

function TProdutoRepository.CarregaTodos: TObjectList<TProduto>;
var
  Query: TFDQuery;
  Produto: TProduto;
begin
  Result := TObjectList<TProduto>.Create;
  Query := DM.CriaQuery;
  try
    Query.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos';
    Query.Open;

    while not Query.Eof do
    begin
      Produto := TProduto.Create;
      Produto.Codigo := Query.FieldByName('codigo').AsInteger;
      Produto.Descricao := Query.FieldByName('descricao').AsString;
      Produto.PrecoVenda := Query.FieldByName('preco_venda').AsCurrency;

      Result.Add(Produto);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TProdutoRepository.BuscarPorCodigo(const Codigo: string): TProduto;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := DM.CriaQuery;
  try
    Query.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE codigo = :Codigo';
    Query.ParamByName('Codigo').AsString := Codigo;
    Query.Open;
    if not Query.IsEmpty then
    begin
      Result := TProduto.Create;
      Result.Codigo := Query.FieldByName('codigo').AsInteger;
      Result.Descricao := Query.FieldByName('descricao').AsString;
      Result.PrecoVenda := Query.FieldByName('preco_venda').AsCurrency;
    end;
  finally
    Query.Free;
  end;
end;

function TProdutoRepository.BuscarPorDescricao(const Descricao: string): TObjectList<TProduto>;
var
  Query: TFDQuery;
  Produto: TProduto;
begin
  Result := TObjectList<TProduto>.Create;
  Query := DM.CriaQuery;
  try
    Query.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE descricao LIKE :Descricao';
    Query.ParamByName('descricao').AsString := '%' + Descricao + '%';
    Query.Open;

    while not Query.Eof do
    begin
      Produto := TProduto.Create;
      Produto.Codigo := Query.FieldByName('codigo').AsInteger;
      Produto.Descricao := Query.FieldByName('descricao').AsString;
      Produto.PrecoVenda := Query.FieldByName('preco_venda').AsCurrency;

      Result.Add(Produto);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

end.
