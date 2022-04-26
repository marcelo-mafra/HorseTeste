unit horse.service.params.types;

interface

uses
 System.Classes;

type
  TBackendParams = record
    Host: string;
    Porta: integer;
    ConnectionStr: string;
  end;

  TParamsUtils = record helper for TBackendParams
    function isValidConnectionStr: boolean;
    function isValidServerInfo: boolean;
  end;

implementation

{ TParamsUtils }

function TParamsUtils.isValidConnectionStr: boolean;
begin
 Result := self.ConnectionStr <> '';
end;

function TParamsUtils.isValidServerInfo: boolean;
begin
 Result := self.Host <> '';
end;

end.
