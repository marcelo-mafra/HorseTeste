unit nfe.localservice.dao.formatters.interfaces;

interface

uses
 System.Classes, System.SysUtils,
 nfe.localservice.dao.formatters.types;

type
  //tipos de formatos de data e hora suportados
  TDateFormats = (dtDate, dtDateTime);

  //interface ancestral de todas as interfaces relacionadas a formatação de dados
  IFormatter = interface
    ['{78F26F18-A5AB-4204-A5E3-024800F015F2}']
    function GetFormatSqlVar: TFormatSettings;
    function GetFormatXmlVar: TFormatSettings;
    property FormatSqlVar: TFormatSettings read GetFormatSqlVar;
    property FormatXmlVar: TFormatSettings read GetFormatXmlVar;
  end;

  //Formatação de dados para TDateTime
  IDateTimeFormatter = interface(IFormatter)
    ['{456C89BE-64D6-4A2C-9D07-7377753CE549}']
    function SQLValue(const value: TDateTime; DateFormat: TDateFormats = dtDateTime): string;
  end;

  //Formatação de dados para double
  INumberFormatter = interface(IFormatter)
   ['{28B315DE-6B3B-4EBC-A0AB-175671D7D18E}']
   function AsDouble(var value: double; const NumFormat: TNumberFormats): INumberFormatter;
   function AsBC(const value: variant): double;
   function AsIcms(const value: double): double;
   function AsIcmsAliq(const value: double): double;
   function AsPeso(const value: variant): double;
   function AsValorTotal(const value: double): double;
   function AsValorUnit(const value: double): double;

  end;

  //Formatação de dados para strings
  IStringFormatter = interface(IFormatter)
    ['{4CBC2924-06A8-49BD-BDA2-04C3E7EC4350}']
    function SQLValue(const value: string): string;
  end;

  //interface "helper" para centralizar tarefas de formatação de dados.
  IFormatterHelper = interface
    ['{13997F2E-0264-4E92-954D-BCC70D10632B}']
    function Settings: IFormatter;
    function DateTime: IDateTimeFormatter;
    function Numbers: INumberFormatter;
    function Strings: IStringFormatter;

  end;

implementation

end.
