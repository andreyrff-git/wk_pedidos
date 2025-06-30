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

constructor TReadConfig.Create;
var config_file : string;
begin
  config_file := '..\..\src\database\config\config.ini'; // caminho do arquivo INI;
  FIni := TIniFile.Create(config_file);
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

