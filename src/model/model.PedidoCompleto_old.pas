unit model.PedidoCompleto;

interface

uses
  System.Generics.Collections, model.TPedidoProdutos,
  model.TProduto, model.TPedidoDadosGerais, model.TCliente;

type
  TPedidoCompleto = class
  public
    Pedido: TPedidoDadosGerais;
    Cliente: TCliente;
    Produto: TProduto;
    PedidoProdutos: TObjectList<TPedidoProdutos>;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TPedidoCompleto.Create;
begin
  Pedido := TPedidoDadosGerais.Create;
  Cliente := TCliente.Create;
  Produto := TProduto.Create;
  PedidoProdutos := TObjectList<TPedidoProdutos>.Create;
end;

destructor TPedidoCompleto.Destroy;
begin
  Pedido.Free;
  Cliente.Free;
  Produto.Free;
  PedidoProdutos.Free;
  inherited;
end;

end.

