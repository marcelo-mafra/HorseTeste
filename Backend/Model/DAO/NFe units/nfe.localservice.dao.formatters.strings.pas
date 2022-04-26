unit nfe.localservice.dao.formatters.strings;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils,
 nfe.localservice.dao.formatters.interfaces,
  nfe.localservice.dao.formatters.customobj;

type
  (*Classe utilitária para formatar tipos string. Em protótipo ainda e pode
  ser estendida no futuro. *)
  TStringFormatter = class(TCustomFormatter, IStringFormatter)
   protected
    function SQLValue(const value: string): string;
    constructor Create;

   public
    class function New: IStringFormatter;
    destructor Destroy; override;

  end;

implementation

{ TStringFormatter }

constructor TStringFormatter.Create;
begin
 inherited Create;
end;

destructor TStringFormatter.Destroy;
begin
  inherited Destroy;
end;

class function TStringFormatter.New: IStringFormatter;
begin
 Result := self.Create;
end;

function TStringFormatter.SQLValue(const value: string): string;
begin
 Result := value.QuotedString;
end;

end.
