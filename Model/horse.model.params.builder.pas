unit horse.model.params.builder;

interface

uses
 System.Classes, Data.DB,
 horse.model.params.exceptions;

type
  IModelParamsBuilder = interface
    ['{A05E6EDB-0539-4A74-9EC4-75C26F47DB56}']
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
    function ParamsObj: TParams;
  end;

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

end.
