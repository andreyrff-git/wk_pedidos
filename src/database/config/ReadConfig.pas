unit ReadConfig;

interface

uses
  System.SysUtils, System.IniFiles;

type
  TReadConfig = class
  private
    FIni: TIniFile;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConfig(const Key: string): string;
  end;

implementation

const
  CONFIG_FILE = 'D:\Projetos\Summit\PROJETO_WK\src\database\config\config.ini'; // path do arquivo INI

constructor TReadConfig.Create;
begin
  FIni := TIniFile.Create(CONFIG_FILE);
end;

destructor TReadConfig.Destroy;
begin
  FIni.Free;
  inherited;
end;

function TReadConfig.GetConfig(const Key: string): string;
begin
  Result := FIni.ReadString('Database', Key, '');
end;

end.

