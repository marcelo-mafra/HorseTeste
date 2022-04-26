unit horse.model.params.builder;

interface

uses
 System.Classes, System.SysUtils, System.JSON, System.JSON.Types, System.Variants,
 Data.DB, System.Generics.Collections,
 horse.model.params.exceptions, horse.model.params.builder.interfaces;

type
  TModelParamsBuilder = class(TInterfacedObject, IModelParamsBuilder)
   private
    FParams: TParams;

   protected
    constructor Create;
    function BeginObject: IModelParamsBuilder;
    function Add(const ParamName: string; ParamValue: string): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: integer): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: int64): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: Byte): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: Word): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: ShortInt): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: double): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: TDateTime): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: TDate): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: Boolean): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: variant): IModelParamsBuilder; overload;
    function Add(Obj: TJSONObject): IModelParamsBuilder; overload;
    function ParamsObj: TParams;

   public
    destructor Destroy; override;
    class function New: IModelParamsBuilder;
  end;

implementation

{ TModelParamsBuilder }

constructor TModelParamsBuilder.Create;
begin
 inherited;
end;

destructor TModelParamsBuilder.Destroy;
begin

  inherited;
end;

class function TModelParamsBuilder.New: IModelParamsBuilder;
begin
 Result := self.Create;
end;

function TModelParamsBuilder.ParamsObj: TParams;
begin
 Result := self.FParams;
end;

function TModelParamsBuilder.BeginObject: IModelParamsBuilder;
begin
 Result := self;
 FParams := TParams.Create;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: int64): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftLargeint;
     Name := ParamName;
     AsLargeInt := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: double): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftFloat;
     Name := ParamName;
     AsFloat := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: string): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftString;
     Name := ParamName;
     AsString := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: integer): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftInteger;
     Name := ParamName;
     AsInteger := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: variant): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftVariant;
     Name := ParamName;
     Value := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: ShortInt): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftShortint;
     Name := ParamName;
     AsShortInt := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: Byte): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftByte;
     Name := ParamName;
     AsByte := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: Word): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftWord;
     Name := ParamName;
     AsWord := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: TDate): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftDate;
     Name := ParamName;
     AsDate := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: TDateTime): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftDateTime;
     Name := ParamName;
     AsDateTime := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(const ParamName: string;
  ParamValue: Boolean): IModelParamsBuilder;
begin
 Result := self;
 try
   with FParams.AddParameter do
    begin
     ParamType := ptInput;
     DataType := ftBoolean;
     Name := ParamName;
     AsBoolean := ParamValue;
    end;
 except
  raise EParamBuilder.Create(ParamName);
 end;
end;

function TModelParamsBuilder.Add(Obj: TJSONObject): IModelParamsBuilder;
var
 I: integer;
 key: string;
 aDouble: double;
 aInteger: integer;
 aInteger64: int64;
 aNumber: Extended;
begin
 Result := self;

 for I := 0 to Pred(Obj.Count) do
  begin
    key := Obj.Pairs[I].JsonString.Value;

    if Obj.Pairs[I].JsonValue is TJSONNull then
     begin
      self.Add(Key, Null);
      Continue;
     end;
    if Obj.Pairs[I].JsonValue is TJSONString then
     begin
      if TryStrToInt(Obj.Pairs[I].JsonValue.Value, aInteger) then
       begin
        self.Add(key, aInteger);
        Continue;
       end;

      if TryStrToInt64(Obj.Pairs[I].JsonValue.Value, aInteger64) then
       begin
        self.Add(key, aInteger64);
        Continue;
       end;

      if TryStrToFloat(Obj.Pairs[I].JsonValue.Value, aNumber) then
       begin
        self.Add(key, aNumber);
        Continue;
       end;

      self.Add(key, Obj.Pairs[I].JsonValue.Value);
      Continue;
     end;
    if Obj.Pairs[I].JsonValue is TJSONNumber then
     begin
      if Obj.Pairs[I].JsonValue.TryGetValue<double>(aDouble) then
        self.Add(key, TJSONNumber(Obj.Pairs[I].JsonValue).AsDouble);
      if Obj.Pairs[I].JsonValue.TryGetValue<integer>(aInteger) then
        self.Add(key, TJSONNumber(Obj.Pairs[I].JsonValue).AsInt);
      Continue;
     end;
    if Obj.Pairs[I].JsonValue is TJSONBool then
      self.Add(key, TJSONBool(Obj.Pairs[I].JsonValue).AsBoolean);
  end;
end;

end.
