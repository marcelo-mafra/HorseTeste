unit nfe.localservice.dao.formatters.customobj;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils,
 nfe.localservice.dao.formatters.types,
 nfe.localservice.dao.formatters.interfaces,
 nfe.localservice.dao.sqlconsts,
 nfe.localservice.dao.nfeobj.xmlmapper.consts;

type
  //Classe da qual todas as classes "formatadoras" de dados devem herdar
  TCustomFormatter = class(TInterfacedObject, IFormatter)
  private
    FFormatSqlVar, FFormatXmlVar: TFormatSettings;
    procedure FormatVariables; inline;

   protected
    constructor Create;
    function GetFormatSqlVar: TFormatSettings;
    function GetFormatXmlVar: TFormatSettings;

   public
    class function New: IFormatter;
    destructor Destroy; override;

    property FormatSqlVar: TFormatSettings read GetFormatSqlVar;
    property FormatXmlVar: TFormatSettings read GetFormatXmlVar;

  end;

implementation

{ TCustomFormatter }

constructor TCustomFormatter.Create;
begin
 inherited Create;
 self.FormatVariables;
end;

destructor TCustomFormatter.Destroy;
begin

 inherited Destroy;
end;

class function TCustomFormatter.New: IFormatter;
begin
 Result := self.Create;
end;

procedure TCustomFormatter.FormatVariables;
begin
 //Formatação de marcadores sql-like conforme localização definida no Windows
 FFormatSqlVar := TFormatSettings.Create(LOCALE_USER_DEFAULT);
 FFormatSqlVar.DateSeparator     := TSQLChars.DateSep;
 FFormatSqlVar.ShortDateFormat   := TSQLChars.DateFmt;
 FFormatSqlVar.DecimalSeparator  := TSQLChars.DecSep;
 FFormatSqlVar.ThousandSeparator := TSQLChars.ThousandSep;

 //Formatação de marcadores xml-like conforme localização definida no Windows
 FFormatXmlVar := TFormatSettings.Create(LOCALE_USER_DEFAULT);
 FFormatXmlVar.DateSeparator     := TXmlFormatChars.DateSep;
 FFormatXmlVar.ShortDateFormat   := TXmlFormatChars.DateFmt;
 FFormatXmlVar.DecimalSeparator  := TXmlFormatChars.DecSep;
 FFormatXmlVar.ThousandSeparator := TXmlFormatChars.ThouSep;
end;

function TCustomFormatter.GetFormatSqlVar: TFormatSettings;
begin
 Result := self.FFormatSqlVar;
end;

function TCustomFormatter.GetFormatXmlVar: TFormatSettings;
begin
 Result := self.FFormatXmlVar;
end;

end.
