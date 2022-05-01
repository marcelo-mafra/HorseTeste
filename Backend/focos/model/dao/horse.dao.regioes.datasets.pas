unit horse.dao.regioes.datasets;

interface

uses
 System.Classes, System.JSON, Data.DB, System.SysUtils,
 horse.dao.regioes.sqlconsts, horse.service.params.types,
 horse.dao.regioes.interfaces, horse.dao.connection.factory,
 horse.model.regioes.exceptions, horse.model.exceptions,
 horse.model.params.builder, horse.dao.customobj.datasets,
 horse.dao.helpers.json;

type
  TDAORegioes = class(TDAOCustomObj, IDAORegioes)
    protected
      constructor Create(const Params: TBackendParams);
      //IDAORegioes
      function ListRegions: TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function ListRegionsParent(const id: integer): TJsonArray;
      function NewRegion(obj: TJsonObject): IDAORegioes;
      function UpdateRegion(obj: TJsonObject): TJsonObject;
      function DeleteRegion(const id: integer): boolean;

    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IDAORegioes;
  end;

implementation

{ TDAORegioes }

constructor TDAORegioes.Create(const Params: TBackendParams);
begin
 inherited create(Params);
end;

destructor TDAORegioes.Destroy;
begin
  inherited Destroy;
end;

class function TDAORegioes.New(const Params: TBackendParams): IDAORegioes;
begin
 Result := self.Create(Params);
end;

function TDAORegioes.NewRegion(obj: TJsonObject): IDAORegioes;
var
 ParamsObj: TParams;
begin
 Result := self;
 if Result <> nil then
  begin
    try
     ParamsObj := TModelParamsBuilder.New.BeginObject.Add(Obj).ParamsObj;
     if (not Assigned(ParamsObj)) or (ParamsObj.Count = 0) then
      raise EInvalidParams.Create;

     if string.IsNullOrEmpty(ParamsObj.FindParam('nomreg').AsString) then
      raise EInvalidRegionName.Create;

     TConnectionFactory.New(ConnectionStr)
                       .ExecuteCommand(TRegioesCommands.NewSubregion, ParamsObj);

    except
     on E: EJSONException do
      begin
       E.RaiseOuterException(EInvalidRequestData.Create);
      end
     else
       raise;
    end;
  end;
end;

function TDAORegioes.UpdateRegion(obj: TJsonObject): TJsonObject;
var
 ParamsObj: TParams;
begin
 Result := obj;
 if Result <> nil then
  begin
   try
     ParamsObj := TModelParamsBuilder.New.BeginObject.Add(Obj).ParamsObj;
     if (not Assigned(ParamsObj)) or (ParamsObj.Count = 0) then
      raise EInvalidParams.Create;

     if string.IsNullOrEmpty(ParamsObj.FindParam('nomreg').AsString.Trim) then
      raise EInvalidRegionName.Create;

     TConnectionFactory.New(ConnectionStr)
                       .ExecuteCommand(TRegioesCommands.AlterSubregion, ParamsObj);

   except
     on E: EConvertError do
      begin
       E.RaiseOuterException(EInvalidRequestData.Create);
      end;
     on E: EJSONException do
      begin
       E.RaiseOuterException(EInvalidRequestData.Create);
      end
     else
       raise;
   end;
  end;
end;

function TDAORegioes.DeleteRegion(const id: integer): boolean;
var
 Command: string;
 Ds: TDataset;
begin
 Result := False;
 Command := string.Format(TRegioesCommands.RegiaoEmUso, [id, id, id]);
 try
  Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(Command);
  if not Ds.Fields.Fields[0].IsNull then
    raise EDeleteRegion.Create;

  Command := string.Format(TRegioesCommands.DeleteRegion, [id]);
  TConnectionFactory.New(ConnectionStr).ExecuteCommand(Command, Result);
 except
  raise;
 end;
end;

function TDAORegioes.ListMember(const id: integer): TJsonObject;
var
 Ds: TDataset;
 ParamsObj: TParams;
begin
  Result := TJSonObject.Create;
  try
   ParamsObj := TModelParamsBuilder.New.BeginObject.Add('codreg', id).ParamsObj;
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TRegioesCommands.ListMember, ParamsObj);
   Result.AddPair('codigo', TJSONNumber(Ds.Fields.FieldByName('codreg').AsInteger));
   Result.AddPair('regiao', Ds.Fields.FieldByName('nomreg').AsString);
   Result.AddPair('parent', self.ToJsonValue(Ds.Fields.FieldByName('codpai')));
  except
   raise;
  end;
end;

function TDAORegioes.ListRegions: TJsonArray;
var
 Ds: TDataset;
 JsonObj: TJSonObject;
begin
 Result := TJsonArray.Create;
 try
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TRegioesCommands.ListRegions);
   while not Ds.Eof do
    begin
     JsonObj := TJSonObject.Create;
     JsonObj.AddPair('codigo', TJSONNumber.Create(Ds.Fields.FieldByName('codreg').AsInteger));
     JsonObj.AddPair('regiao', Ds.Fields.FieldByName('nomreg').AsString);
     JsonObj.AddPair('parent', self.ToJsonValue(Ds.Fields.FieldByName('codpai')));
     Result.AddElement(JsonObj);
     Ds.Next;
    end;
 except
  raise;
 end;
end;

function TDAORegioes.ListRegionsParent(const id: integer): TJsonArray;
var
 Ds: TDataset;
 JsonObj: TJSonObject;
 ParamsObj: TParams;
begin
 Result := TJsonArray.Create;
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject.Add('codpai', id).ParamsObj;
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TRegioesCommands.ListRegionsParent, ParamsObj);
   while not Ds.Eof do
    begin
     JsonObj := TJSonObject.Create;
     JsonObj.AddPair('codigo', TJSONNumber.Create(Ds.Fields.FieldByName('codreg').AsInteger));
     JsonObj.AddPair('regiao', Ds.Fields.FieldByName('nomreg').AsString);
     JsonObj.AddPair('parent', self.ToJsonValue(Ds.Fields.FieldByName('codpai')));
     Result.AddElement(JsonObj);
     Ds.Next;
    end;
 except
  raise;
 end;
end;

end.
