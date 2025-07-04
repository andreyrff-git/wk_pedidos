unit DMConnection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, Data.DB,
  ReadConfig, System.ImageList, Vcl.ImgList, Vcl.Controls;

type
  TDM = class(TDataModule)
    FDConnection: TFDConnection;
    FDTransaction: TFDTransaction;
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    ImageList1: TImageList;
  private
    { Private declarations }
    FConfig: TReadConfig;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ConectaDB;
    function CriaQuery: TFDQuery;
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

procedure TDM.ConectaDB;
begin
  FDConnection.Close;
  FDConnection.Params.Clear;
  FDConnection.Params.Add('DriverID=MySQL');
  FDConnection.Params.Add('Server=' + FConfig.GetConfig('Host'));
  FDConnection.Params.Add('Database=' + FConfig.GetConfig('Database'));
  FDConnection.Params.Add('Port=' + FConfig.GetConfig('Port'));
  FDConnection.Params.Add('User_Name=' + FConfig.GetConfig('User'));
  FDConnection.Params.Add('Password=' + FConfig.GetConfig('Password'));
  FDConnection.Params.Add('CharacterSet=' + FConfig.GetConfig('Charset'));

  try
    FDConnection.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar no banco de dados: ' + E.Message);
  end;
end;

constructor TDM.Create(AOwner: TComponent);
begin
  inherited
  Create(AOwner);
  FConfig := TReadConfig.Create;
  FDPhysMySQLDriverLink.VendorLib := ExtractFilePath(ParamStr(0)) + 'libmysql.dll';
end;

function TDM.CriaQuery: TFDQuery;
begin
  result := TFDQuery.Create(nil);
  result.Connection := FDConnection;
end;

destructor TDM.Destroy;
begin
  FConfig.Free;
  inherited;
end;

end.
