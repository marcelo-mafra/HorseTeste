unit horse.service.params;

interface

uses
  System.Classes, System.IniFiles,
  horse.service.params.consts, horse.service.params.types;

type
  IHorseParams = interface
    ['{6BEAF1C0-7B3D-41E9-A3A2-87A824BEB707}']
    procedure ReadParams(var Params: TBackendParams);
  end;

  THorseParams = class(TInterfacedObject, IHorseParams)
    private
      FReader: TMemIniFile;

    protected
      constructor Create(const ParamsFile: string);
      procedure ReadParams(var Params: TBackendParams);

    public
      destructor Destroy; override;
      class function New(const ParamsFile: string): IHorseParams;
      property Reader: TMemIniFile read FReader;
  end;

implementation

{ THorseParams }

constructor THorseParams.Create(const ParamsFile: string);
begin
  FReader := TMemIniFile.Create(ParamsFile);
  inherited Create;
end;

destructor THorseParams.Destroy;
begin
  FReader.Free;
  inherited;
end;

class function THorseParams.New(const ParamsFile: string): IHorseParams;
begin
 Result := self.Create(ParamsFile);
end;

procedure THorseParams.ReadParams(var Params: TBackendParams);
begin
 Params.ServiceName := Reader.ReadString(TServiceInfo.Service, TServiceInfo.Module, '');
 Params.ParamsFile := Reader.ReadString(TServiceInfo.Service, TServiceInfo.ParamsFile, '');
 Params.Host  := Reader.ReadString(TServiceInfo.Host, TServiceInfo.URL, '');
 Params.Porta := Reader.ReadInteger(TServiceInfo.Host, TServiceInfo.Porta, 0);
 Params.ConnectionStr := Reader.ReadString(TServiceInfo.Host, TServiceInfo.Data, '')
end;

end.
