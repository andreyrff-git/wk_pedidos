unit model.TPedidoDadosGerais;

interface

uses
  System.SysUtils;

type
  TPedidoDadosGerais = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDate;
    FClienteCodigo: Integer;
    FValorTotal: Currency;
  public
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property ClienteCodigo: Integer read FClienteCodigo write FClienteCodigo;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
  end;

implementation

end.
