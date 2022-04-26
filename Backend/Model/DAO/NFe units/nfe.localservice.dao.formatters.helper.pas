unit nfe.localservice.dao.formatters.helper;

interface

uses
 System.Classes,
 nfe.localservice.dao.formatters.interfaces,
 nfe.localservice.dao.formatters.numbers,
 nfe.localservice.dao.formatters.strings,
 nfe.localservice.dao.formatters.datetime,
 nfe.localservice.dao.formatters.customobj;

type
  //Classe para facilitar o acesso às demais classes formatadoras
  TFormatterHelper = class(TInterfacedObject, IFormatterHelper)
  protected
   constructor Create;
   function Settings: IFormatter;
   function DateTime: IDateTimeFormatter;
   function Numbers: INumberFormatter;
   function Strings: IStringFormatter;

  public
   destructor Destroy; override;
   class function New: IFormatterHelper;

  end;

implementation

{ TFormatterHelper }

constructor TFormatterHelper.Create;
begin
 inherited Create;
end;

destructor TFormatterHelper.Destroy;
begin

  inherited Destroy;
end;

class function TFormatterHelper.New: IFormatterHelper;
begin
  Result := self.Create;
end;

function TFormatterHelper.DateTime: IDateTimeFormatter;
begin
 Result := TDateTimeFormatter.New;
end;

function TFormatterHelper.Numbers: INumberFormatter;
begin
 Result := TNumberFormatter.New;
end;

function TFormatterHelper.Settings: IFormatter;
begin
 Result := TCustomFormatter.New;
end;

function TFormatterHelper.Strings: IStringFormatter;
begin
 Result := TStringFormatter.New;
end;

end.
