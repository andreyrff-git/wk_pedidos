unit ConfigReader;

interface

uses
  System.SysUtils, System.IniFiles;

type
  TConfigReader = class
  private
    FIni: TIniFile;
  public
    constructor Create;
    destructor Destroy; override;
    function GetDatabaseConfig(const Key: string): string;
  end;

implementation

const
  CONFIG_FILE = 'infrastructure\Config\config.ini'; // Caminho do arquivo INI

constructor TConfigReader.Create;
begin
  FIni := TIniFile.Create(CONFIG_FILE);
end;

destructor TConfigReader.Destroy;
begin
  FIni.Free;
  inherited;
end;

function TConfigReader.GetDatabaseConfig(const Key: string): string;
begin
  Result := FIni.ReadString('Database', Key, '');
end;

end.

