unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, uPedidos;

type
  TfPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    PedidosdeVendas1: TMenuItem;
    NovoPedido1: TMenuItem;
    Sair1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure NovoPedido1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;
  fPedidos: TfPedidos;

implementation

uses
  DBConnection;

{$R *.dfm}

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  try
    DM.ConectarBanco;
  except
    on E: Exception do
      ShowMessage('Erro ao conectar: ' + E.Message);
  end;
end;

procedure TfPrincipal.NovoPedido1Click(Sender: TObject);
begin
  if not Assigned(fPedidos) then
      fPedidos := TfPedidos.Create(Self);
    fPedidos.Show;
end;

procedure TfPrincipal.Sair1Click(Sender: TObject);
begin
  close;
end;

end.
