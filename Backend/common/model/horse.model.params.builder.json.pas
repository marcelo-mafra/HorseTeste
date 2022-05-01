unit horse.model.params.builder.json;

interface

uses
 System.Classes, System.SysUtils, System.Json, Data.DB;

type
 TParamsHelper = class helper for TParams
   function ToJsonString: string;
   function ToJson: TJsonObject;
 end;

implementation

{ TParamsHelper }

function TParamsHelper.ToJson: TJsonObject;
var
 I: integer;
begin
 Result := TJsonObject.Create;
 for I := 0 to Pred(self.Count) do
  begin
   if self.Items[I].Name.Trim.IsEmpty then Continue;

   //O TParam.Value = null. Neste caso, não importa o DataType do TParam.
   if self.Items[I].IsNull then
    begin
     Result.AddPair(self.Items[I].Name, TJSONNull.Create.Value);
     Continue;
    end;
   //Converte para JSON o TParam conforme o seu DataType
   case self.Items[I].DataType of
    ftInteger, ftSmallint,
    ftAutoInc:
        Result.AddPair(self.Items[I].Name, TJSONNumber.Create(self.Items[I].AsInteger));
    ftShortint:
        Result.AddPair(self.Items[I].Name, TJSONNumber.Create(self.Items[I].AsShortInt));
    ftByte:
        Result.AddPair(self.Items[I].Name, TJSONNumber.Create(self.Items[I].AsByte));
    ftWord:
        Result.AddPair(self.Items[I].Name, TJSONNumber.Create(self.Items[I].AsWord));
    ftLargeint:
        Result.AddPair(self.Items[I].Name, TJSONNumber.Create(self.Items[I].AsLargeInt));
    ftFloat, ftFMTBcd, ftExtended:
        Result.AddPair(self.Items[I].Name, TJSONNumber.Create(self.Items[I].AsFloat));
    ftString, ftWideString:
        Result.AddPair(self.Items[I].Name, TJSONString.Create(self.Items[I].AsString));
    ftBoolean:
        Result.AddPair(self.Items[I].Name, TJSONBool.Create(self.Items[I].AsBoolean));
    ftDate, ftTime:
        Result.AddPair(self.Items[I].Name, TJSONString.Create(self.Items[I].AsString));
    ftDateTime:
        Result.AddPair(self.Items[I].Name, TJSONString.Create(self.Items[I].AsString));
    ftVariant:
        Result.AddPair(self.Items[I].Name, TJSONString.Create(self.Items[I].AsString));
    else
        Result.AddPair(self.Items[I].Name, TJSONString.Create(self.Items[I].AsString));
   end;
  end;
end;

function TParamsHelper.ToJsonString: string;
begin
 Result := self.ToJson.ToString;
end;

end.
