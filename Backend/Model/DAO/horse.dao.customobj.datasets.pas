unit horse.dao.customobj.datasets;

interface

uses
 System.Classes, System.JSON, Data.DB, System.SysUtils,
 horse.service.params.types;

type
  TDAOCustomObj = class(TInterfacedObject)
    private
      FParams: TBackendParams;
      function GetConnectionStr: string; inline;
    public
      destructor Destroy; override;
      constructor Create(const Params: TBackendParams);

      property ConnectionStr: string read GetConnectionStr;
      property Params: TBackendParams read FParams;
  end;

 TDAOCustomObjHelper = class helper for TDAOCustomObj

   function GetJsonValue(Field: TField): TJSONValue;
 end;

implementation

{ TDAOCustomObj }

constructor TDAOCustomObj.Create(const Params: TBackendParams);
begin
 inherited Create;
 FParams := Params;
end;

destructor TDAOCustomObj.Destroy;
begin
  inherited Destroy;
end;

function TDAOCustomObj.GetConnectionStr: string;
begin
 Result := Params.ConnectionStr;
end;

{ TDAOCustomObjHelper }

function TDAOCustomObjHelper.GetJsonValue(Field: TField): TJSONValue;
begin
 Result := nil;
 if Field.IsNull then Result := TJSONNull.Create
 else
  begin
   case Field.DataType of
     ftString, ftFixedChar, ftWideString, ftGuid, ftFixedWideChar:
        Result := TJSONString.Create(Field.AsString);
     ftSmallint, ftShortint, ftInteger, ftWord, ftAutoInc, ftLongWord:
        Result := TJSONNumber.Create(Field.AsInteger);
     ftLargeint: Result := TJSONNumber.Create(Field.AsLargeInt);
     ftExtended: Result := TJSONNumber.Create(Field.AsExtended);
     ftBoolean:  Result := TJSONBool.Create(Field.AsBoolean);
     ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftSingle:
        Result := TJSONNumber.Create(Field.AsFloat);
     ftDate: ;
     ftTime: ;
     ftDateTime, ftTimeStamp, ftOraTimeStamp: ;
     ftByte, ftBytes, ftVarBytes: ;
     ftBlob, ftGraphic, ftStream: ;
     ftMemo, ftWideMemo: TJSONString.Create(Field.AsString);
   end;
  end;
end;

end.
