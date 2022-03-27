unit nfe.localservice.dao.formatters.datetime;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils,
 nfe.localservice.dao.formatters.interfaces,
 nfe.localservice.dao.sqlconsts,
 nfe.localservice.dao.formatters.customobj;

type
  (*Classe utilitária para formatar tipos TDateTime. Em protótipo ainda e pode
  ser estendida no futuro.  *)
  TDateTimeFormatter = class(TCustomFormatter, IDateTimeFormatter)
   protected
    function SQLValue(const value: TDateTime; DateFormat: TDateFormats = dtDateTime): string;
    constructor Create;

   public
    class function New: IDateTimeFormatter;
    destructor Destroy; override;

  end;

implementation

{ TDateTimeFormatter }

constructor TDateTimeFormatter.Create;
begin
 inherited Create;
end;

destructor TDateTimeFormatter.Destroy;
begin
  inherited Destroy;
end;

class function TDateTimeFormatter.New: IDateTimeFormatter;
begin
 Result := self.Create;
end;

function TDateTimeFormatter.SQLValue(const value: TDateTime; DateFormat: TDateFormats): string;
begin
 case DateFormat of
   dtDate:     Result := FormatDateTime(TSQLChars.DateFmt, value, FormatSqlVar).QuotedString;
   dtDateTime: Result := FormatDateTime(TSQLChars.DateTimeFmt, value, FormatSqlVar).QuotedString;
 end;

end;

end.
