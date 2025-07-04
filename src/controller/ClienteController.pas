unit ClienteController;

interface

uses
  System.Generics.Collections, model.TCliente, FireDAC.Comp.Client, ClienteRepository;

type
  TClienteController = class
  private
    FCliente: TClienteRepository;
  public
    constructor Create;
    destructor Destroy; override;
    property Cliente: TClienteRepository read FCliente write FCliente;

    function BuscarTodos(): TObjectList<TCliente>;
    function BuscarPorCodigo(const Codigo: string): TCliente;
    function BuscarPorNome(const Nome: string): TObjectList<TCliente>;
  end;

implementation

{ TClienteController }

constructor TClienteController.Create;
begin
  FCliente := TClienteRepository.Create;
end;

destructor TClienteController.Destroy;
begin
  FCliente.Free;
  inherited;
end;

function TClienteController.BuscarTodos(): TObjectList<TCliente>;
begin
  Result := FCliente.CarregaTodos;
end;

function TClienteController.BuscarPorCodigo(const Codigo: string): TCliente;
begin
  Result := FCliente.BuscarPorCodigo(Codigo);
end;

function TClienteController.BuscarPorNome(const Nome: string): TObjectList<TCliente>;
begin
  Result := FCliente.BuscarPorNome(Nome);
end;

end.
