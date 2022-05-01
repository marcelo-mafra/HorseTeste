unit horse.dao.focos.datasets;

interface

uses
 System.Classes, System.JSON, Data.DB, System.SysUtils,
 Dataset.Serialize,
 horse.dao.focos.sqlconsts, horse.service.params.types,
 horse.dao.focos.interfaces, horse.dao.connection.factory,
 horse.dao.regioes.interfaces, horse.dao.customobj.datasets,
 horse.dao.helpers.json, horse.model.params.builder,
 horse.model.exceptions, horse.dao.regioes.sqlconsts;

type
  TDAOFocos = class(TDAOCustomObj, IDAOFocos)
    protected
      constructor Create(const Params: TBackendParams);
      //IDAOFocos
      function ListAll: TJsonArray;
      function ListFocosParent(const id: integer): TJsonArray;
      function ListFocosRegion(const id: integer): TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function ListFocosStatus(const status: boolean): TJsonArray;
      function ListFocosTipo(const id: integer; const tipo: string): TJsonArray;
      function DesativarFoco(const id: integer): TJsonObject;
      function ReativarFoco(const id: integer): TJsonObject;
      function IRegioes: IDAORegioes;

    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IDAOFocos;
  end;

implementation

{ TDAOFocos }

constructor TDAOFocos.Create(const Params: TBackendParams);
begin
 inherited Create(Params);
end;

destructor TDAOFocos.Destroy;
begin
 inherited Destroy;
end;

function TDAOFocos.IRegioes: IDAORegioes;
begin
 Result := self as IDAORegioes;
end;

class function TDAOFocos.New(const Params: TBackendParams): IDAOFocos;
begin
 Result := self.Create(Params);
end;

function TDAOFocos.ListAll: TJsonArray;
var
 Ds: TDataset;
begin
 try
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TFocosCommands.ListAll);
   Result := Ds.ToJSONArray();
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

function TDAOFocos.ListFocosParent(const id: integer): TJsonArray;
var
 Ds: TDataset;
 ParamsObj: TParams;
begin
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject.Add('codpai', id).ParamsObj;
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TFocosCommands.ListFocosParent, ParamsObj);
   Result := Ds.ToJSONArray();
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

function TDAOFocos.ListFocosRegion(const id: integer): TJsonArray;
var
 Ds: TDataset;
 ParamsObj: TParams;
begin
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject.Add('codreg', id).ParamsObj;
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TFocosCommands.ListFocosRegion, ParamsObj);
   Result := Ds.ToJSONArray();
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

function TDAOFocos.ListFocosStatus(const status: boolean): TJsonArray;
var
 Ds: TDataset;
 ParamsObj: TParams;
begin
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject.Add('indati', self.ToString(status)).ParamsObj;
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TFocosCommands.ListFocosStatus, ParamsObj);
   Result := Ds.ToJSONArray();
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

function TDAOFocos.ListFocosTipo(const id: integer;
  const tipo: string): TJsonArray;
var
 Ds: TDataset;
 ParamsObj: TParams;
begin
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject
                .Add('codreg', id)
                .Add('tipfoc', tipo)
                .ParamsObj;

   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TFocosCommands.ListFocosTipo, ParamsObj);
   Result := Ds.ToJSONArray();
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

function TDAOFocos.ListMember(const id: integer): TJsonObject;
var
 Ds: TDataset;
 ParamsObj: TParams;
begin
 try
    ParamsObj := TModelParamsBuilder.New.BeginObject.Add('codfoc', id).ParamsObj;
    Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TFocosCommands.ListMember, ParamsObj);
    Result := Ds.ToJSONObject();
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

function TDAOFocos.DesativarFoco(const id: integer): TJsonObject;
var
 ParamsObj: TParams;
begin
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject
                  .Add('indati', 'N')
                  .Add('codfoc', id)
                  .ParamsObj;

   if (not Assigned(ParamsObj)) or (ParamsObj.Count = 0) then
    raise EInvalidParams.Create;

   TConnectionFactory.New(ConnectionStr)
                     .ExecuteCommand(TFocosCommands.DesativarFoco, ParamsObj);
   Result := self.ListMember(id);

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

function TDAOFocos.ReativarFoco(const id: integer): TJsonObject;
var
 ParamsObj: TParams;
begin
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject
                  .Add('indati', 'S')
                  .Add('codfoc', id)
                  .ParamsObj;

   if (not Assigned(ParamsObj)) or (ParamsObj.Count = 0) then
    raise EInvalidParams.Create;

   TConnectionFactory.New(ConnectionStr)
                     .ExecuteCommand(TFocosCommands.DesativarFoco, ParamsObj);
   Result := self.ListMember(id);

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

end.
