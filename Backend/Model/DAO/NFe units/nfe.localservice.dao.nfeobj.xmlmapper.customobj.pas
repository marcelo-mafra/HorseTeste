unit nfe.localservice.dao.nfeobj.xmlmapper.customobj;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, System.Variants,
  //nfe units
  nfe.localservice.dao.nfeobj.interfaces,
  nfe.localservice.model.nfeobj.types,
  nfe.localservice.dao.nfeobj.xmlmapper.consts,
  nfe.localservice.dao.formatters.interfaces,
  nfe.localservice.dao.formatters.helper;

type
  TConvertType = (ctDate, ctTime);

  //Delimitadores para conversão de tipos TDate e TTime
  TDelimitators = class
    const
     DateIni = 1;
     DateFim = 10;
     TimeIni = 1;
     TimeFim = 8;
  end;

  //Classe-base de todas que fazem mapeamento O.R. a partir de fontes xml
  TDAOCustomXmlMapper = class(TInterfacedObject)
    private
     FFormatSqlVar, FFormatXmlVar: TFormatSettings;
     function GetFormatter: IFormatterHelper;

    protected
     constructor Create;

    public
     class function New: TDAOCustomXmlMapper;
     destructor Destroy; override;
     function ConvertDateTime(const Value: olevariant;
          ConvType: TConvertType = ctDate): Olevariant; inline;
     procedure FormatVariables; inline;

     property Formatter: IFormatterHelper read GetFormatter;
     property FormatSqlVar: TFormatSettings read FFormatSqlVar;
     property FormatXmlVar: TFormatSettings read FFormatXmlVar;
  end;

implementation

{ TDAOCustomXmlMapper }

constructor TDAOCustomXmlMapper.Create;
begin
 inherited Create;
 FormatVariables;
end;

destructor TDAOCustomXmlMapper.Destroy;
begin
  inherited Destroy;
end;

procedure TDAOCustomXmlMapper.FormatVariables;
begin
 FFormatSqlVar := self.Formatter.Settings.FormatSqlVar;
 FFormatXmlVar := self.Formatter.Settings.FormatXmlVar;
end;

class function TDAOCustomXmlMapper.New: TDAOCustomXmlMapper;
begin
 Result := self.Create;
end;

function TDAOCustomXmlMapper.ConvertDateTime(const Value: olevariant;
  ConvType: TConvertType): Olevariant;
begin
 case ConvType of
   ctDate: Result := StrToDate(Copy(value, TDelimitators.DateIni, TDelimitators.DateFim), FFormatXmlVar);
   ctTime: Result := StrToTime(Copy(value, TDelimitators.TimeIni, TDelimitators.TimeFim),  FFormatXmlVar);
 end;
end;

function TDAOCustomXmlMapper.GetFormatter: IFormatterHelper;
begin
 Result := TFormatterHelper.New;
end;


end.
