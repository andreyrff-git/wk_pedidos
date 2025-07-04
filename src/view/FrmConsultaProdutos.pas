unit FrmConsultaProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, model.TProduto,
  System.Generics.Collections, ProdutoController;

type
  TConsultaProdutos = class(TForm)
    pnTop: TPanel;
    Panel2: TPanel;
    edtCodigoProduto: TEdit;
    btnSelecionar: TButton;
    dbgProdutos: TDBGrid;
    cdsProdutos: TClientDataSet;
    dsProdutos: TDataSource;
    Label1: TLabel;
    rgConsulta: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure dbgProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FController: TProdutoController;
    procedure ConfigurarProdutoDataSet;
    procedure CarregarProdutos(Lista: TObjectList<TProduto>);
    procedure BuscarProdutos;
  public
    constructor Create(AOwner: TComponent; AController: TProdutoController); reintroduce;
  end;

var
  ConsultaProdutos: TConsultaProdutos;

implementation

{$R *.dfm}

{ TConsultaProdutos }

procedure TConsultaProdutos.CarregarProdutos(Lista: TObjectList<TProduto>);
var
  Produto: TProduto;
begin
  cdsProdutos.DisableControls;
  try
    cdsProdutos.EmptyDataSet;

    for Produto in Lista do
    begin
      cdsProdutos.Append;
      cdsProdutos.FieldByName('Codigo').AsInteger := Produto.Codigo;
      cdsProdutos.FieldByName('Descricao').AsString := Produto.Descricao;
      cdsProdutos.FieldByName('PrecoVenda').AsCurrency := Produto.PrecoVenda;
      cdsProdutos.Post;
    end;
  finally
    cdsProdutos.EnableControls;
    cdsProdutos.First;
  end;
end;

procedure TConsultaProdutos.btnSelecionarClick(Sender: TObject);
begin
  if not cdsProdutos.IsEmpty then
    ModalResult := mrOk;
end;

procedure TConsultaProdutos.BuscarProdutos;
var
  Produtos: TObjectList<TProduto>;
  Produto: TProduto;
begin
  Produtos := TObjectList<TProduto>.Create;

  try
    if Trim(edtCodigoProduto.Text) = '' then
      Produtos := FController.BuscarPorDescricao('%')
    else
    begin
      case rgConsulta.ItemIndex of
        0: begin
             Produto := FController.BuscarPorCodigo(edtCodigoProduto.Text);
             if Assigned(Produto) then
               Produtos.Add(Produto);
           end;
        1: Produtos := FController.BuscarPorDescricao('%' + Trim(edtCodigoProduto.Text) + '%');
      end;
    end;

    if Assigned(Produtos) then
      CarregarProdutos(Produtos);

  finally
    Produtos.Free;
  end;
end;

procedure TConsultaProdutos.ConfigurarProdutoDataSet;
begin
  cdsProdutos.Close;
  cdsProdutos.FieldDefs.Clear;
  cdsProdutos.IndexFieldNames := 'Codigo';
  cdsProdutos.FieldDefs.Add('Codigo', ftInteger);
  cdsProdutos.FieldDefs.Add('Descricao', ftString, 220);
  cdsProdutos.FieldDefs.Add('PrecoVenda', ftCurrency);
  cdsProdutos.CreateDataSet;

  dsProdutos.DataSet := cdsProdutos;
  dbgProdutos.DataSource := dsProdutos;

  dbgProdutos.Columns[0].Width := 80;
  dbgProdutos.Columns[1].Width := 300;
  dbgProdutos.Columns[2].Width := 100;
end;

constructor TConsultaProdutos.Create(AOwner: TComponent; AController: TProdutoController);
begin
  inherited Create(AOwner);
  FController := AController;

end;

procedure TConsultaProdutos.dbgProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;

    if not cdsProdutos.IsEmpty then
    begin
      ModalResult := mrOk;
    end;
  end;

end;

procedure TConsultaProdutos.edtCodigoProdutoExit(Sender: TObject);
begin
  BuscarProdutos;
end;

procedure TConsultaProdutos.FormCreate(Sender: TObject);
begin
  ConfigurarProdutoDataSet;
  BuscarProdutos;
end;

procedure TConsultaProdutos.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

end.
