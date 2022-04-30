unit horse.dao.customobj.datasets.helpers;

interface

uses
 System.Classes, System.JSON, Data.DB, System.SysUtils, System.DateUtils,
 horse.service.params.types, horse.dao.customobj.datasets,
 System.JSON.Writers;

type
 TDAOCustomObjHelper = class helper for TDAOCustomObj

   function GetJsonValue(Field: TField): TJSONValue;
   function ToString(value: boolean): string; inline;

 end;

implementation

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
