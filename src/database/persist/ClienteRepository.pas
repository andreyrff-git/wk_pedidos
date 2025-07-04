unit ClienteRepository;

interface

uses
  System.Generics.Collections, model.TCliente, FireDAC.Comp.Client, Data.DB, DMConnection;

type
  TClienteRepository = class
  public
    function CarregaTodos: TObjectList<TCliente>;
    function BuscarPorNome(const Nome: string): TObjectList<TCliente>;
    function BuscarPorCodigo(const Codigo: string): TCliente;
  end;

implementation

{ TClienteRepository }

function TClienteRepository.CarregaTodos: TObjectList<TCliente>;
var
  Query: TFDQuery;
  Cliente: TCliente;
begin
  Result := TObjectList<TCliente>.Create;
  Query := DM.CriaQuery;
  try
    Query.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes';
    Query.Open;

    while not Query.Eof do
    begin
      Cliente := TCliente.Create;
      Cliente.Codigo := Query.FieldByName('codigo').AsInteger;
      Cliente.Nome := Query.FieldByName('nome').AsString;
      Cliente.Cidade := Query.FieldByName('cidade').AsString;
      Cliente.UF := Query.FieldByName('uf').AsString;

      Result.Add(Cliente);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TClienteRepository.BuscarPorCodigo(const Codigo: string): TCliente;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := DM.CriaQuery;
  try
    Query.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes WHERE codigo = :Codigo';
    Query.ParamByName('Codigo').AsString := Codigo;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result := TCliente.Create;
      Result.Codigo := Query.FieldByName('codigo').AsInteger;
      Result.Nome := Query.FieldByName('nome').AsString;
      Result.Cidade := Query.FieldByName('cidade').AsString;
      Result.UF := Query.FieldByName('uf').AsString;
    end;
  finally
    Query.Free;
  end;
end;

function TClienteRepository.BuscarPorNome(const Nome: string): TObjectList<TCliente>;
var
  Query: TFDQuery;
  Cliente: TCliente;
begin
  Result := TObjectList<TCliente>.Create;
  Query := DM.CriaQuery;
  try
    Query.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes WHERE nome LIKE :Nome';
    Query.ParamByName('Nome').AsString := '%' + Nome + '%';
    Query.Open;

    while not Query.Eof do
    begin
      Cliente := TCliente.Create;
      Cliente.Codigo := Query.FieldByName('codigo').AsInteger;
      Cliente.Nome := Query.FieldByName('nome').AsString;
      Cliente.Cidade := Query.FieldByName('cidade').AsString;
      Cliente.UF := Query.FieldByName('uf').AsString;

      Result.Add(Cliente);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

end.
