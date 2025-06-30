unit ProdutoController;

interface

uses
  System.Generics.Collections, model.TProduto, FireDAC.Comp.Client, ProdutoRepository;

type
  TProdutoController = class
  private
    FProduto: TProdutoRepository;
  public
    constructor Create;
    destructor Destroy; override;
    property Produto: TProdutoRepository read FProduto write FProduto;

    function BuscarTodos(): TObjectList<TProduto>;
    function BuscarPorCodigo(const Codigo: string): TProduto;
    function BuscarPorDescricao(const Nome: string): TObjectList<TProduto>;
  end;

implementation

{ TProdutoController }

constructor TProdutoController.Create;
begin
  FProduto := TProdutoRepository.Create;
end;

destructor TProdutoController.Destroy;
begin
  FProduto.Free;
  inherited;
end;

function TProdutoController.BuscarTodos(): TObjectList<TProduto>;
begin
  Result := FProduto.CarregaTodos;
end;

function TProdutoController.BuscarPorCodigo(const Codigo: string): TProduto;
begin
  Result := FProduto.BuscarPorCodigo(Codigo);
end;

function TProdutoController.BuscarPorDescricao(const Nome: string): TObjectList<TProduto>;
begin
  Result := FProduto.BuscarPorDescricao(Nome);
end;


end.
