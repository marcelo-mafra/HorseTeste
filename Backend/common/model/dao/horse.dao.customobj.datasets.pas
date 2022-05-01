unit horse.dao.customobj.datasets;

interface

uses
 System.Classes, System.SysUtils,
 horse.service.params.types, DataSet.Serialize;

type
  TDAOCustomObj = class(TInterfacedObject)
    private
      FParams: TBackendParams;
      function GetConnectionStr: string; inline;

    public
      destructor Destroy; override;
      constructor Create(const Params: TBackendParams);
      procedure  ExecuteFormatter; inline;

      property ConnectionStr: string read GetConnectionStr;
      property Params: TBackendParams read FParams;
  end;

implementation

{ TDAOCustomObj }

constructor TDAOCustomObj.Create(const Params: TBackendParams);
begin
 inherited Create;
 FParams := Params;
end;

destructor TDAOCustomObj.Destroy;
begin
  inherited Destroy;
end;

procedure TDAOCustomObj.ExecuteFormatter;
begin
 TDataSetSerializeConfig.GetInstance.Export.FormatDate := 'dd/mm/yyyy';
 TDataSetSerializeConfig.GetInstance.Export.FormatDateTime := 'dd/mm/yyyy hh:mm:ss';
 TDataSetSerializeConfig.GetInstance.Export.FormatTime := 'hh:mm:ss';
 TDataSetSerializeConfig.GetInstance.Export.ExportNullAsEmptyString := False;
 TDataSetSerializeConfig.GetInstance.Export.ExportNullValues := True;
end;

function TDAOCustomObj.GetConnectionStr: string;
begin
 Result := Params.ConnectionStr;
end;

end.
