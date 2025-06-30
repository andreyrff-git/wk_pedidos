unit FrmConsultaClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Datasnap.DBClient, System.Generics.Collections,
  model.TCliente, ClienteController;

type
  TConsultaClientes = class(TForm)
    pnTop: TPanel;
    pnAll: TPanel;
    dbgClientes: TDBGrid;
    edtBusca: TEdit;
    btnSelecionar: TButton;
    cdsClientes: TClientDataSet;
    dsClientes: TDataSource;
    Label1: TLabel;
    rgConsulta: TRadioGroup;

    procedure FormCreate(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure BuscarClientes;
    procedure edtBuscaExit(Sender: TObject);
    procedure dbgClientesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FController: TClienteController;
    procedure ConfigurarClientDataSet;
    procedure CarregarClientes(Lista: TObjectList<TCliente>);
  public
    constructor Create(AOwner: TComponent; AController: TClienteController); reintroduce;
  end;

implementation

{$R *.dfm}

constructor TConsultaClientes.Create(AOwner: TComponent; AController: TClienteController);
begin
  inherited Create(AOwner);
  FController := AController;
end;

procedure TConsultaClientes.dbgClientesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;

    if not cdsClientes.IsEmpty then
    begin
      ModalResult := mrOk;
    end;
  end;

end;

procedure TConsultaClientes.edtBuscaExit(Sender: TObject);
begin
  BuscarClientes;
end;

procedure TConsultaClientes.ConfigurarClientDataSet;
begin
  cdsClientes.Close;
  cdsClientes.FieldDefs.Clear;
  cdsClientes.FieldDefs.Add('Codigo', ftInteger);
  cdsClientes.FieldDefs.Add('Nome', ftString, 220);
  cdsClientes.FieldDefs.Add('Cidade', ftString, 100);
  cdsClientes.FieldDefs.Add('UF', ftString, 2);
  cdsClientes.CreateDataSet;

  dsClientes.DataSet := cdsClientes;
  dbgClientes.DataSource := dsClientes;

  dbgClientes.Columns[0].Width := 80;
  dbgClientes.Columns[1].Width := 300;
  dbgClientes.Columns[2].Width := 100;
  dbgClientes.Columns[3].Width := 40;

end;

procedure TConsultaClientes.FormCreate(Sender: TObject);
begin
  ConfigurarClientDataSet;
  BuscarClientes;
end;

procedure TConsultaClientes.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TConsultaClientes.BuscarClientes;
var
  Clientes: TObjectList<TCliente>;
  Cliente: TCliente;
begin
  Clientes := TObjectList<TCliente>.Create;

  try
    if Trim(edtBusca.Text) = '' then
      Clientes := FController.BuscarTodos
    else
    begin
      case rgConsulta.ItemIndex of
        0: begin
             Cliente := FController.BuscarPorCodigo(edtBusca.Text);
             if Assigned(Cliente) then
               Clientes.Add(Cliente);
           end;
        1: Clientes := FController.BuscarPorNome('%' + Trim(edtBusca.Text) + '%');
      end;
    end;

    if Assigned(Clientes) then
      CarregarClientes(Clientes);

  finally
    Clientes.Free;
  end;
end;

procedure TConsultaClientes.CarregarClientes(Lista: TObjectList<TCliente>);
var
  Cliente: TCliente;
begin
  cdsClientes.DisableControls;
  try
    cdsClientes.EmptyDataSet;

    for Cliente in Lista do
    begin
      cdsClientes.Append;
      cdsClientes.FieldByName('Codigo').AsInteger := Cliente.Codigo;
      cdsClientes.FieldByName('Nome').AsString := Cliente.Nome;
      cdsClientes.FieldByName('Cidade').AsString := Cliente.Cidade;
      cdsClientes.FieldByName('UF').AsString := Cliente.UF;
      cdsClientes.Post;
    end;
  finally
    cdsClientes.EnableControls;
    cdsClientes.First;
  end;
end;

procedure TConsultaClientes.btnSelecionarClick(Sender: TObject);
begin
  if not cdsClientes.IsEmpty then
    ModalResult := mrOk;
end;

end.

