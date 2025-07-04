unit FrmPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Buttons, System.UITypes,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Datasnap.DBClient, System.Classes, System.Generics.Collections,
  FrmConsultaClientes, FrmConsultaProdutos, model.TPedidoProdutos, ClienteController, ClienteRepository, PedidoController,
  ProdutoController, ProdutoRepository, model.TPedidoCompleto, Vcl.DBCtrls,
  Data.Bind.Components, Data.Bind.DBScope, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.NumberBox;

type
  TPedidos = class(TForm)
    pnCabecalho: TPanel;
    pnRodape: TPanel;
    pnGrid: TPanel;
    DBGrid1: TDBGrid;
    btPesquisaCliente: TSpeedButton;
    lbNomeCliente: TLabel;
    pnProdutos: TPanel;
    gbProdutos: TGroupBox;
    edtCodigoProduto: TEdit;
    edtDescProduto: TEdit;
    edtQuantidade: TEdit;
    lbCodigoProduto: TLabel;
    lbCodigoCliente: TLabel;
    btPesquisaProduto: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnConfirma: TButton;
    cdsItensPedido: TClientDataSet;
    dsItensPedido: TDataSource;
    cdsItensPedidoCodigoProduto: TIntegerField;
    cdsItensPedidoDescricaoProduto: TStringField;
    cdsItensPedidoQuantidade: TCurrencyField;
    cdsItensPedidoValorUnitario: TCurrencyField;
    cdsItensPedidoValorTotal: TCurrencyField;
    pnTotal: TPanel;
    pnControlePedidos: TPanel;
    gbPedidos: TGroupBox;
    Label4: TLabel;
    edtNrPedido: TEdit;
    gbCliente: TGroupBox;
    edtCodCliente: TEdit;
    bdkCliente: TDBLookupComboBox;
    dsCliente: TDataSource;
    qryClientes: TFDQuery;
    qryClientescodigo: TFDAutoIncField;
    qryClientesnome: TWideStringField;
    btnConsultarPedido: TButton;
    edtPrecoVenda: TNumberBox;
    pnlBtn: TPanel;
    btnGravarPedido: TButton;
    btnExcluiPedido: TButton;

    procedure btPesquisaClienteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure btPesquisaProdutoClick(Sender: TObject);
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure btnConfirmaClick(Sender: TObject);
    procedure cdsItensPedidoCalcFields(DataSet: TDataSet);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure btnExcluiPedidoClick(Sender: TObject);
    procedure edtNrPedidoEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bdkClienteExit(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnConsultarPedidoClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FCliPreenchido: Boolean;
    FPedidoController: TPedidoController;
    FConsultaCliente: Boolean;
    procedure PesquisarCliente;
    procedure PesquisarProduto;
    procedure ConfirmarProdutos;
    procedure LimparCamposItens;
    procedure CalcularTotal;
    procedure GravarPedido;
    procedure CarregarPedido;
    procedure CancelarPedido;
    procedure CarregarProdutosNaGrid(PedidoProdutos: TObjectList<TPedidoProdutos>);
  public
  end;

var
  Pedidos: TPedidos;

implementation

{$R *.dfm}

uses DMConnection, model.TCliente, model.TProduto, model.TPedidoDadosGerais,
  PedidoRepository;
//Utils,FrmConsultaPedidos,

procedure TPedidos.btnGravarPedidoClick(Sender: TObject);
begin
  GravarPedido;
end;

procedure TPedidos.bdkClienteExit(Sender: TObject);
begin
  if bdkCliente.KeyValue <> null then
  begin
    edtCodCliente.Text := bdkCliente.KeyValue;
    FCliPreenchido := true;
  end;
end;

procedure TPedidos.btnConsultarPedidoClick(Sender: TObject);
begin
  if trim(edtNrPedido.text) <> '' then
    CarregarPedido;
end;

procedure TPedidos.btnExcluiPedidoClick(Sender: TObject);
begin
  CancelarPedido;
end;

procedure TPedidos.btPesquisaClienteClick(Sender: TObject);
begin
  PesquisarCliente;
end;

procedure TPedidos.btPesquisaProdutoClick(Sender: TObject);
begin
  PesquisarProduto;
end;

procedure TPedidos.btnConfirmaClick(Sender: TObject);
begin
  ConfirmarProdutos;
end;

procedure TPedidos.CalcularTotal;
var
  Total: Currency;
begin
  Total := 0;

  cdsItensPedido.DisableControls;
  try
    cdsItensPedido.First;
    while not cdsItensPedido.Eof do
    begin
      Total := Total + cdsItensPedido.FieldByName('ValorTotal').AsCurrency;
      cdsItensPedido.Next;
    end;
  finally
    btnGravarPedido.Enabled := (Total > 0) and (not FConsultaCliente);
    cdsItensPedido.EnableControls;
  end;

  pnTotal.Caption := 'Valor Total --> '+ FormatFloat('R$ ###,##0.00', Total);
end;

procedure TPedidos.CancelarPedido;
var
  NumeroPedido: Integer;
  PedidoController: TPedidoController;
begin
  NumeroPedido := StrToIntDef(edtNrPedido.Text, 0);
  if NumeroPedido = 0 then
  begin
    ShowMessage('Informe um n�mero de pedido v�lido.');
    edtNrPedido.SetFocus;
    Exit;
  end;
  if MessageDlg('Deseja realmente excluir o pedido?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    PedidoController := TPedidoController.Create(TPedidoRepository.Create());
    try
      if PedidoController.CancelaPedido(NumeroPedido) then
      begin
        ShowMessage('Pedido excluido com sucesso!');
        cdsItensPedido.EmptyDataSet;
        FCliPreenchido := false;
        edtNrPedido.Clear;
        gbCliente.Enabled := true;
        edtCodCliente.Clear;
        bdkCliente.KeyValue := null;
      end
      else
        ShowMessage('Falha ao excluir o pedido.');
    finally
      PedidoController.Free;
    end;
  end;
end;

procedure TPedidos.CarregarPedido;
var
  PedidoCompleto: TPedidoCompleto;
  PedidoController: TPedidoController;
begin
  if edtNrPedido.Text = EmptyStr then
  begin
    ShowMessage('Informe o numero do pedido!');
    edtNrPedido.SetFocus;
    exit;
  end;
  PedidoController := TPedidoController.Create(TPedidoRepository.Create());
  try
    PedidoCompleto := PedidoController.BuscarPedidoCompleto(StrToIntDef(edtNrPedido.Text, 0));
    if Assigned(PedidoCompleto) then
    begin
      FConsultaCliente  := True;
      edtCodCliente.Text := InttoStr(PedidoCompleto.Cliente.Codigo);
      bdkCliente.KeyValue := PedidoCompleto.Cliente.Codigo;
      CarregarProdutosNaGrid(PedidoCompleto.PedidoProdutos);
    end
    else
    begin
      edtNrPedido.Text := EmptyStr;
      ShowMessage('Pedido n�o encontrado!');
    end;
  finally
    PedidoController.Free;
  end;
end;

procedure TPedidos.CarregarProdutosNaGrid(PedidoProdutos: TObjectList<TPedidoProdutos>);
var
  ItemPed: TPedidoProdutos;
  ProdutoRepo: TProdutoRepository;
  Produto: TProduto;
begin
  if not cdsItensPedido.Active then
    cdsItensPedido.Open;

  cdsItensPedido.EmptyDataSet;

  ProdutoRepo := TProdutoRepository.Create;

  for ItemPed in PedidoProdutos do
  begin
    Produto := ProdutoRepo.BuscarPorCodigo(IntToStr(ItemPed.CodProduto));
    try
      cdsItensPedido.Append;
      cdsItensPedido.FieldByName('CodigoProduto').AsInteger := ItemPed.CodProduto;
      cdsItensPedido.FieldByName('Quantidade').AsCurrency := ItemPed.Quantidade;
      cdsItensPedido.FieldByName('ValorUnitario').AsCurrency := ItemPed.ValorUnitario;

      if Assigned(Produto) then
        cdsItensPedido.FieldByName('DescricaoProduto').AsString := Produto.descricao
      else
        cdsItensPedido.FieldByName('DescricaoProduto').AsString := '';
      cdsItensPedido.Post;
    finally
      Produto.Free;
    end;
  end;

  cdsItensPedido.First;
  CalcularTotal;
end;

procedure TPedidos.cdsItensPedidoCalcFields(DataSet: TDataSet);
var
  Quantidade, ValorUnitario: Currency;
begin
  Quantidade := DataSet.FieldByName('Quantidade').AsCurrency;
  ValorUnitario := DataSet.FieldByName('ValorUnitario').AsCurrency;
  DataSet.FieldByName('ValorTotal').AsCurrency := Quantidade * ValorUnitario;
end;

procedure TPedidos.ConfirmarProdutos;
var
  CodigoProduto: Integer;
  Quantidade,
  PrecoVenda: Currency;
begin
  if not TryStrToInt(edtCodigoProduto.Text, CodigoProduto) then
  begin
    ShowMessage('C�digo do produto inv�lido!');
    edtCodigoProduto.SetFocus;
    exit;
  end;

  if not TryStrToCurr(edtQuantidade.Text, Quantidade) then
  begin
    ShowMessage('Quantidade do produto inv�lido!');
    edtQuantidade.SetFocus;
    exit;
  end;

  if not TryStrToCurr(edtPrecoVenda.Text, PrecoVenda) then
  begin
    ShowMessage('Pre�o de venda do produto inv�lido!');
    edtPrecoVenda.SetFocus;
    exit;
  end;
  gbCliente.Enabled := false;

  if (not cdsItensPedido.Active)  then
    cdsItensPedido.Open;

  if not (cdsItensPedido.State in [dsEdit]) then
    cdsItensPedido.Append;

  cdsItensPedido.FieldByName('CodigoProduto').AsInteger   := CodigoProduto;
  cdsItensPedido.FieldByName('Quantidade').AsCurrency     := Quantidade;
  cdsItensPedido.FieldByName('ValorUnitario').AsCurrency  := PrecoVenda;
  cdsItensPedido.FieldByName('DescricaoProduto').AsString := edtDescProduto.Text;

  if cdsItensPedido.Active then
  begin
    if cdsItensPedido.State in [dsEdit, dsInsert] then
    begin
      cdsItensPedido.Post;
      edtCodigoProduto.Enabled := true;
      FConsultaCliente := false;
      edtCodigoProduto.SetFocus;
      CalcularTotal;
      LimparCamposItens;
    end;
  end;

end;

procedure TPedidos.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Soma: Double;
begin
  // Desenha as c�lulas normalmente
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  // Se for a coluna de valor e a �ltima linha (rodap�)
  if (Column.FieldName = 'ValorTotal') and (gdFixed in State) then
  begin
    Soma := 0;
    DBGrid1.DataSource.DataSet.DisableControls;
    try
      DBGrid1.DataSource.DataSet.First;
      while not DBGrid1.DataSource.DataSet.Eof do
      begin
        Soma := Soma + DBGrid1.DataSource.DataSet.FieldByName('ValorTotal').AsFloat;
        DBGrid1.DataSource.DataSet.Next;
      end;
    finally
      DBGrid1.DataSource.DataSet.EnableControls;
    end;

    // Desenha o total no rodap�
    DBGrid1.Canvas.FillRect(Rect);
    DBGrid1.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, 'Valor Total --> ' + FormatFloat('R$ #,##0.00', Soma));
  end;

end;

procedure TPedidos.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;

    if not cdsItensPedido.IsEmpty then
    begin
      edtCodigoProduto.Text := cdsItensPedido.FieldByName('CodigoProduto').AsString;
      edtDescProduto.Text := cdsItensPedido.FieldByName('DescricaoProduto').AsString;
      edtQuantidade.Text := cdsItensPedido.FieldByName('Quantidade').AsString;
      edtPrecoVenda.Text := cdsItensPedido.FieldByName('ValorUnitario').AsString;
      cdsItensPedido.Edit;
      gbProdutos.Enabled  := True;
      edtCodigoProduto.Enabled := false;
      edtQuantidade.SetFocus;
    end;
  end;

  if (Key = VK_DELETE) and (not cdsItensPedido.IsEmpty) then
  begin
    if MessageDlg('Deseja realmente excluir o produto '+cdsItensPedidoDescricaoProduto.AsString+' ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      cdsItensPedido.Delete;
      FConsultaCliente := false;
      CalcularTotal;
    end;
    Key := 0;
  end;
end;

procedure TPedidos.edtCodClienteExit(Sender: TObject);
var
  FrmConsultaCliente: TConsultaClientes;
  ClienteLocaliza: Boolean;
  Repo: TClienteRepository;
  Cliente: TCliente;
  ClienteController: TClienteController;
begin
  ClienteController := TClienteController.Create;
  ClienteLocaliza := False;
  if Trim(edtCodCliente.Text) = '' then
  begin
    bdkCliente.KeyValue := null;
    btnExcluiPedido.Enabled   := true;
    Exit;
  end;

  Repo := TClienteRepository.Create;
  Cliente := Repo.BuscarPorCodigo(edtCodCliente.Text);
  try
    if Assigned(Cliente) then
    begin
      FCliPreenchido := true;
      bdkCliente.KeyValue := Cliente.Codigo;
      ClienteLocaliza := True;
      FConsultaCliente  := false;
      cdsItensPedido.EmptyDataSet;
      edtNrPedido.Clear;
    end;
  finally
    Cliente.Free;
  end;

  if not ClienteLocaliza then
  begin
    FrmConsultaCliente := TConsultaClientes.Create(Self, ClienteController);
    try
      if FrmConsultaCliente.ShowModal = mrOk then
      begin
        edtCodCliente.Text := FrmConsultaCliente.cdsClientes.FieldByName('codigo').AsString;
        bdkCliente.KeyValue := FrmConsultaCliente.cdsClientes.FieldByName('codigo').AsInteger;
        FConsultaCliente    := false;
        cdsItensPedido.EmptyDataSet;
        edtNrPedido.Clear;
      end;
    finally
      FrmConsultaCliente.Free;
    end;
  end;
  edtNrPedido.SetFocus;
  btnExcluiPedido.Enabled   := true;
  if bdkCliente.Text <> EmptyStr then
  begin
    btnExcluiPedido.Enabled   := false;
    gbProdutos.Enabled          := true;
    edtCodigoProduto.SetFocus;
  end;

end;

procedure TPedidos.edtCodigoProdutoExit(Sender: TObject);
var
  FrmConsultaProduto: TConsultaProdutos;
  ProdutoLocalizado: Boolean;
  Repo: TProdutoRepository;
  Produto: TProduto;
  ProdutoController: TProdutoController;
begin
  ProdutoController := TProdutoController.Create;
  ProdutoLocalizado := False;
  if Trim(edtCodigoProduto.Text) = '' then
    Exit;

  Repo := TProdutoRepository.Create;
  Produto := Repo.BuscarPorCodigo(edtCodigoProduto.Text);
  try
    if Assigned(Produto) then
    begin
      edtDescProduto.Text := Produto.descricao;
      edtPrecoVenda.Text := FormatFloat('0.00', Produto.PrecoVenda);
      ProdutoLocalizado := True;
      end;
  finally
    Produto.Free;
  end;

  if not ProdutoLocalizado then
  begin
    FrmConsultaProduto := TConsultaProdutos.Create(Self, ProdutoController);
    try
      if FrmConsultaProduto.ShowModal = mrOk then
      begin
        edtCodigoProduto.Text := FrmConsultaProduto.cdsProdutos.FieldByName('codigo').AsString;
        edtDescProduto.Text   := FrmConsultaProduto.cdsProdutos.FieldByName('descricao').AsString;
      end;
    finally
      FrmConsultaProduto.Free;
    end;
  end;
end;

procedure TPedidos.edtNrPedidoEnter(Sender: TObject);
begin
  if not FCliPreenchido then
  begin
    if bdkCliente.KeyValue = null then
    begin
      btnExcluiPedido.Enabled := true;
      btnConsultarPedido.Enabled := true;
    end;
  end;
  FCliPreenchido := False;
end;

procedure TPedidos.FormCreate(Sender: TObject);
begin
  if not cdsItensPedido.Active then
     cdsItensPedido.CreateDataSet;
  FCliPreenchido  := false;
  FConsultaCliente := false;
  FPedidoController := TPedidoController.Create(TPedidoRepository.Create());


//  // Associa ao bot�o
//  btPesquisaCliente.Images := VirtualImageList1;
//  btPesquisaCliente.ImageIndex := 0;

  edtPrecoVenda.Mode := nbmCurrency;
  edtPrecoVenda.CurrencyString := 'R$ ';
  edtPrecoVenda.Decimal := 4;
end;

procedure TPedidos.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TPedidos.FormShow(Sender: TObject);
begin
  qryClientes.Open();
end;

procedure TPedidos.GravarPedido;
var
  PedidoController: TPedidoController;
  Pedido: TPedidoDadosGerais;
  Produtos: TList<TPedidoProdutos>;
  Produto: TPedidoProdutos;
  nrpedido: integer;
begin
  if cdsItensPedido.RecordCount = 0 then
  begin
    ShowMessage('N�o h� dados para gravar o pedido.');
    btnGravarPedido.Enabled := false;
    edtCodCliente.SetFocus;
    Exit;
  end;

  try
    Pedido := TPedidoDadosGerais.Create;
    Pedido.DataEmissao := Now;
    Pedido.ClienteCodigo := StrToInt(edtCodCliente.Text);
    nrpedido := 0;

    Produtos := TList<TPedidoProdutos>.Create;
    try
      cdsItensPedido.First;
      while not cdsItensPedido.Eof do
      begin
        Produto := TPedidoProdutos.Create;
        Produto.CodProduto := cdsItensPedido.FieldByName('CodigoProduto').AsInteger;
        Produto.Quantidade := cdsItensPedido.FieldByName('Quantidade').AsInteger;
        Produto.ValorUnitario := cdsItensPedido.FieldByName('ValorUnitario').AsCurrency;
        Produto.ValorTotal := cdsItensPedido.FieldByName('ValorTotal').AsCurrency;
        Produtos.Add(Produto);
        Pedido.ValorTotal := Pedido.ValorTotal + cdsItensPedido.FieldByName('ValorTotal').AsCurrency;
        cdsItensPedido.Next;
      end;

      PedidoController := TPedidoController.Create(TPedidoRepository.Create());
      try
        if PedidoController.GravaPedido(Pedido, Produtos, nrpedido) then
        begin
          ShowMessage('Pedido N� '+inttostr(nrpedido)+' gravado com sucesso!');
          cdsItensPedido.EmptyDataSet;
          CalcularTotal;
          LimparCamposItens;
          gbCliente.Enabled := true;
          edtCodCliente.Clear;
          bdkCliente.KeyValue := null;
        end
        else
          ShowMessage('Erro ao gravar pedido.');
      finally
        PedidoController.Free;
      end;
    finally
      if Assigned(Produto) then
         Produto.Free;
      Produtos.Free;
    end;
  finally
    Pedido.Free;
  end;
end;

procedure TPedidos.LimparCamposItens;
begin
  edtCodigoProduto.Clear;
  edtQuantidade.Clear;
  edtPrecoVenda.Clear;
  edtDescProduto.Text := EmptyStr;
end;

procedure TPedidos.PesquisarCliente;
var
  FrmConsulta: TConsultaClientes;
  ClienteController: TClienteController;
begin
  ClienteController := TClienteController.Create;
  FrmConsulta := TConsultaClientes.Create(Self, ClienteController);
  try
    if FrmConsulta.ShowModal = mrOk then
    begin
      edtCodCliente.Text := FrmConsulta.cdsClientes.FieldByName('Codigo').AsString;
      bdkCliente.KeyValue := FrmConsulta.cdsClientes.FieldByName('Codigo').AsInteger;
      gbProdutos.Enabled    := True;
      edtCodigoProduto.SetFocus;
    end;
  finally
    FrmConsulta.Free;
  end;
end;

procedure TPedidos.PesquisarProduto;
var
  FrmConsultaProduto: TConsultaProdutos;
  ProdutoController: TProdutoController;
begin
  ProdutoController := TProdutoController.Create();
  FrmConsultaProduto := TConsultaProdutos.Create(Self, ProdutoController);
  try
    if FrmConsultaProduto.ShowModal = mrOk then
    begin
      edtCodigoProduto.Text := FrmConsultaProduto.cdsProdutos.FieldByName('Codigo').AsString;
      edtDescProduto.Text := FrmConsultaProduto.cdsProdutos.FieldByName('Descricao').AsString;
      edtPrecoVenda.Text := FormatFloat('0.00', FrmConsultaProduto.cdsProdutos.FieldByName('PrecoVenda').AsCurrency);
      edtQuantidade.SetFocus;
    end;
  finally
    FrmConsultaProduto.Free;
  end;
end;

end.
