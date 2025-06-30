unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, FireDAC.DApt.Intf, FireDAC.DApt;

type
  TPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Vendas1: TMenuItem;
    ManutPedido1: TMenuItem;
    Sair1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ManutPedido1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Principal: TPrincipal;

implementation

uses
  DMConnection, FrmConsultaClientes, ClienteController, FrmPedidos;

{$R *.dfm}

procedure TPrincipal.FormCreate(Sender: TObject);
begin
  try
    DM.ConectaDB;
  except
    on E: Exception do
      ShowMessage('Erro ao conectar: ' + E.Message);
  end;
end;

procedure TPrincipal.ManutPedido1Click(Sender: TObject);
begin
  if not Assigned(Pedidos) then
      Pedidos := TPedidos.Create(Self);
    Pedidos.ShowModal;
  FreeAndNil(Pedidos);
end;

procedure TPrincipal.Sair1Click(Sender: TObject);
begin
  close;
end;

end.
