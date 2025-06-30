unit model.TPedidoProdutos;

interface

type
  TPedidoProdutos = class
  private
    FID: Integer;
    FNumeroPedido: integer;
    FCodProduto: Integer;
    FQuantidade: Integer;
    FValorUnitario: Currency;
    FValorTotal: Currency;
  public
    property ID: Integer read FID write FID;
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property CodProduto: Integer read FCodProduto write FCodProduto;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property ValorUnitario: Currency read FValorUnitario write FValorUnitario;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
  end;

implementation

end.
