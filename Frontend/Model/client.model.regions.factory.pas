unit client.model.regions.factory;

interface

uses
  System.Classes, System.JSON, System.Generics.Collections,
  client.model.regions.regionobj, Winapi.Windows;

type
  TRegionsFactory = class

  public
    class function CreateObject(obj: TJsonObject): TRegion;
    class function CreateObjectList(obj: TJsonArray): TObjectList<TRegion>;
  end;

implementation

{ TRegionsFactory }

class function TRegionsFactory.CreateObject(obj: TJsonObject): TRegion;
begin
 Result := TRegion.Create;
 Result.Codigo := Obj.GetValue<integer>('codigo');
 Result.Regiao := obj.GetValue<string>('regiao');
 if obj.GetValue('parent') is TJSONNumber then
   Result.Parent := obj.GetValue<integer>('parent');

end;

class function TRegionsFactory.CreateObjectList(obj: TJsonArray): TObjectList<TRegion>;
var
 I: integer;
begin
  Result := TObjectList<TRegion>.Create;
  Result.OwnsObjects := True;
  try
    for I := 0 to Pred(obj.Count) do
     begin
       Result.Add(self.CreateObject(obj.Get(I) as TJsonObject));
     end;
  finally
    //ObjEnum.DisposeOf;
  end;
end;

end.
