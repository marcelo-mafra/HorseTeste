unit nfe.localservice.dao.formatters.numbers;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils, System.Variants,
 nfe.localservice.dao.formatters.types,
 nfe.localservice.dao.formatters.interfaces,
 nfe.localservice.dao.sqlconsts,
 nfe.localservice.dao.formatters.customobj,
  nfe.localservice.dao.formatters.events;

type
  //Classe utilitária para formatar tipos double
  TNumberFormatter = class(TCustomFormatter, INumberFormatter)
   private
    FOnAfterNumberFormat: TOnAfterNumberFormat;
    FOnNumberFormatError: TOnNumberFormatError;

   protected
    //INumberFormatter
    function AsDouble(var value: double; const NumFormat: TNumberFormats): INumberFormatter;

    function AsBC(const value: variant): double;
    function AsIcms(const value: double): double;
    function AsIcmsAliq(const value: double): double;
    function AsPeso(const value: variant): double;
    function AsValorTotal(const value: double): double;
    function AsValorUnit(const value: double): double;
    constructor Create; overload;
    constructor Create(OnFormatError: TOnNumberFormatError;
          OnAfterFormat: TOnAfterNumberFormat); overload;

   public
    class function New: INumberFormatter; overload;
    class function New(OnFormatError: TOnNumberFormatError;
          OnAfterFormat: TOnAfterNumberFormat): INumberFormatter; overload;
    destructor Destroy; override;

    property OnAfterNumberFormat: TOnAfterNumberFormat read FOnAfterNumberFormat
          write FOnAfterNumberFormat;
    property OnNumberFormatError: TOnNumberFormatError read FOnNumberFormatError
          write FOnNumberFormatError;

  end;

implementation

{ TNumberFormatter }

constructor TNumberFormatter.Create;
begin
 inherited Create;
end;

constructor TNumberFormatter.Create(OnFormatError: TOnNumberFormatError;
  OnAfterFormat: TOnAfterNumberFormat);
begin
 inherited Create;
 FOnNumberFormatError := OnFormatError;
 FOnAfterNumberFormat := OnAfterFormat;
end;

destructor TNumberFormatter.Destroy;
begin
  FOnNumberFormatError := nil;
  FOnAfterNumberFormat := nil;
  inherited Destroy;
end;

class function TNumberFormatter.New: INumberFormatter;
begin
 Result := self.Create;
end;

class function TNumberFormatter.New(OnFormatError: TOnNumberFormatError;
  OnAfterFormat: TOnAfterNumberFormat): INumberFormatter;
begin
 Result := self.Create(OnFormatError, OnAfterFormat);
end;

function TNumberFormatter.AsBC(const value: variant): double;
const
 DefValue = 0;
begin
 try
   if (Value = unassigned) or (value = null) then Result := DefValue else Result := value;
   self.AsDouble(Result, nf10_2);
   if Assigned(FOnAfterNumberFormat) then OnAfterNumberFormat(self, fiBC, value, Result);
 except
   on E: Exception do
   begin
    if Assigned(FOnNumberFormatError) then OnNumberFormatError(self, fiBC, value, E);
   end;
 end;
end;

function TNumberFormatter.AsDouble(var value: double;
  const NumFormat: TNumberFormats): INumberFormatter;
begin
 {Formata um double "value" para um padrão "precision:scale" definido em
 "NumFormat". A function retorna a interface implementada por TNumberFormatter}
 Result := self;
 case NumFormat of
  nf16_6: value := FloatToStrF(value, ffFixed, TNumber16.Precision, TNumber16.Scale, FormatSqlVar).ToDouble;
  nf10_2: value := FloatToStrF(value, ffFixed, TNumber10.Precision, TNumber10.Scale, FormatSqlVar).ToDouble;
  nf10_3: value := FloatToStrF(value, ffFixed, TNumber10_3.Precision, TNumber10_3.Scale, FormatSqlVar).ToDouble;
  nf14_3: value := FloatToStrF(value, ffFixed, TNumber14.Precision, TNumber14.Scale, FormatSqlVar).ToDouble;
 end;
end;

function TNumberFormatter.AsIcms(const value: double): double;
begin
 try
   Result := value;
   self.AsDouble(Result, nf10_2);
   if Assigned(FOnAfterNumberFormat) then OnAfterNumberFormat(self, fiIcms, value, Result);
 except
  on E: Exception do
   begin
    if Assigned(FOnNumberFormatError) then OnNumberFormatError(self, fiIcms,
      value, E);
   end;
 end;
end;

function TNumberFormatter.AsIcmsAliq(const value: double): double;
begin
 try
   Result := value;
   self.AsDouble(Result, nf10_2);
   if Assigned(FOnAfterNumberFormat) then OnAfterNumberFormat(self, fiIcmsAliq, value, Result);
 except
  on E: Exception do
   begin
    if Assigned(FOnNumberFormatError) then OnNumberFormatError(self, fiIcmsAliq,
      value, E);
   end;
 end;
end;

function TNumberFormatter.AsPeso(const value: variant): double;
const
 DefValue = 0;
begin
 //Formata os pesos líquido e bruto do veículo
 try
   if (Value = unassigned) or (value = null) then Result := DefValue else Result := value;
   self.AsDouble(Result, nf14_3);
   if Assigned(FOnAfterNumberFormat) then OnAfterNumberFormat(self, fiPesos, value, Result);
 except
  on E: Exception do
   begin
    if Assigned(FOnNumberFormatError) then OnNumberFormatError(self, fiPesos,
      value, E);
   end;
 end;
end;

function TNumberFormatter.AsValorTotal(const value: double): double;
begin
 //Formata o valor total da NFe
 try
   Result := value;
   self.AsDouble(Result, nf10_2);
   if Assigned(FOnAfterNumberFormat) then OnAfterNumberFormat(self, fiValorTotal, value, Result);
 except
  on E: Exception do
   begin
    if Assigned(FOnNumberFormatError) then OnNumberFormatError(self, fiValorTotal,
      value, E);
   end;
 end;
end;

function TNumberFormatter.AsValorUnit(const value: double): double;
begin
 //Formata o valor unitário de um produto
 try
   Result := value;
   self.AsDouble(Result, nf16_6);
   if Assigned(FOnAfterNumberFormat) then OnAfterNumberFormat(self, fiValorUnitario, value, Result);
 except
  on E: Exception do
   begin
    if Assigned(FOnNumberFormatError) then OnNumberFormatError(self, fiValorUnitario,
      value, E);
   end;
 end;
end;

end.
