unit horse.dao.helpers.json;

interface

uses
 System.Classes, System.JSON, Data.DB, System.SysUtils, System.DateUtils,
 horse.service.params.types, horse.dao.customobj.datasets,
 System.JSON.Writers;

type
 TDAOCustomObjHelper = class helper for TDAOCustomObj
  public
   function ToJsonValue(Field: TField): TJSONValue;
   function ToJsonBoolean(const value: string): TJSONBool; inline;
   function ToString(value: boolean): string; inline;
   function ToBoolean(value: string): boolean; inline;

 end;

implementation

{ TDAOCustomObjHelper }

function TDAOCustomObjHelper.ToBoolean(value: string): boolean;
begin
 Result := value.Trim.UpperCase(value) = 'S';
end;

function TDAOCustomObjHelper.ToJsonBoolean(const value: string): TJSONBool;
begin
 Result := TJSONBool.Create(self.ToBoolean(value));
end;

function TDAOCustomObjHelper.ToJsonValue(Field: TField): TJSONValue;
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
     ftLargeint:
        Result := TJSONNumber.Create(Field.AsLargeInt);
     ftExtended:
        Result := TJSONNumber.Create(Field.AsExtended);
     ftBoolean:
        Result := TJSONBool.Create(Field.AsBoolean);
     ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftSingle:
        Result := TJSONNumber.Create(Field.AsFloat);
     ftTimeStamp, ftOraTimeStamp, ftDate, ftDateTime:
        Result := TJSONString.Create(DateToISO8601(Field.AsDateTime, False));
     ftTime:
        Result := TJSONString.Create(Field.AsString);
     ftByte, ftBytes, ftVarBytes: ;
     ftBlob, ftGraphic, ftStream: ;
     ftMemo, ftWideMemo:
        Result := TJSONString.Create(Field.AsString);
   end;
  end;
end;

function TDAOCustomObjHelper.ToString(value: boolean): string;
begin
 case value of
  True:  Result := 'S';
  False: Result := 'N';
 end;
end;

end.
