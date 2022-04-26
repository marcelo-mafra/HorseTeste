unit horse.dao.focos.datasets;

interface

uses
 System.Classes, System.JSON, Data.DB, System.SysUtils,
 horse.dao.focos.sqlconsts, horse.service.params.types,
 horse.dao.focos.interfaces, horse.dao.connection.factory,
 horse.dao.regioes.interfaces, horse.dao.customobj.datasets,
 horse.model.params.builder, horse.model.exceptions,
 horse.dao.regioes.sqlconsts;

type
  TDAOFocos = class(TDAOCustomObj, IDAOFocos)
    private

    protected
      constructor Create(const Params: TBackendParams);
      //IDAOFocos
      function ListAll: TJsonArray;
      function ListFocosParent(const id: integer): TJsonArray;
      function ListFocosRegion(const id: integer): TJsonArray;
      function ListMember(const id: integer): TJsonObject;
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
 JsonObj: TJSonObject;
begin
 Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TFocosCommands.ListAll);
 Result := TJsonArray.Create;
 while not Ds.Eof do
  begin
   JsonObj := TJSonObject.Create;
   JsonObj.AddPair('codigo', self.GetJsonValue(Ds.Fields.FieldByName('codfoc')));
   JsonObj.AddPair('nome', self.GetJsonValue(Ds.Fields.FieldByName('nomfoc')));
   JsonObj.AddPair('sigla', self.GetJsonValue(Ds.Fields.FieldByName('sigfoc')));
   JsonObj.AddPair('tipo', self.GetJsonValue(Ds.Fields.FieldByName('tipfoc')));
   JsonObj.AddPair('ativo', self.GetJsonValue(Ds.Fields.FieldByName('indati')));
   Result.AddElement(JsonObj);
   Ds.Next;
  end;
end;

function TDAOFocos.ListFocosParent(const id: integer): TJsonArray;
var
 Command: string;
 Ds: TDataset;
 JsonObj: TJSonObject;
begin
 Command := string.Format(TFocosCommands.ListFocosParent, [id]);
 Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(Command);
 Result := TJsonArray.Create;
 while not Ds.Eof do
  begin
   JsonObj := TJSonObject.Create;
   JsonObj.AddPair('codigo', self.GetJsonValue(Ds.Fields.FieldByName('codfoc')));
   JsonObj.AddPair('nome', self.GetJsonValue(Ds.Fields.FieldByName('nomfoc')));
   JsonObj.AddPair('sigla', self.GetJsonValue(Ds.Fields.FieldByName('sigfoc')));
   JsonObj.AddPair('tipo', self.GetJsonValue(Ds.Fields.FieldByName('tipfoc')));
   JsonObj.AddPair('regiao', self.GetJsonValue(Ds.Fields.FieldByName('nomreg')));
   JsonObj.AddPair('codParent', self.GetJsonValue(Ds.Fields.FieldByName('codpai')));
   JsonObj.AddPair('parent', self.GetJsonValue(Ds.Fields.FieldByName('nompai')));
   JsonObj.AddPair('ativo', self.GetJsonValue(Ds.Fields.FieldByName('indati')));
   Result.AddElement(JsonObj);
   Ds.Next;
  end;
end;

function TDAOFocos.ListFocosRegion(const id: integer): TJsonArray;
var
 Command: string;
 Ds: TDataset;
 JsonObj: TJSonObject;
begin
 Command := string.Format(TFocosCommands.ListFocosRegion, [id]);
 Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(Command);
 Result := TJsonArray.Create;
 while not Ds.Eof do
  begin
   JsonObj := TJSonObject.Create;
   JsonObj.AddPair('codigo', self.GetJsonValue(Ds.Fields.FieldByName('codfoc')));
   JsonObj.AddPair('nome', self.GetJsonValue(Ds.Fields.FieldByName('nomfoc')));
   JsonObj.AddPair('sigla', self.GetJsonValue(Ds.Fields.FieldByName('sigfoc')));
   JsonObj.AddPair('tipo', self.GetJsonValue(Ds.Fields.FieldByName('tipfoc')));
   JsonObj.AddPair('regiao', self.GetJsonValue(Ds.Fields.FieldByName('nomreg')));
   JsonObj.AddPair('parent', self.GetJsonValue(Ds.Fields.FieldByName('nompai')));
   JsonObj.AddPair('ativo', self.GetJsonValue(Ds.Fields.FieldByName('indati')));
   Result.AddElement(JsonObj);
   Ds.Next;
  end;
end;

function TDAOFocos.ListMember(const id: integer): TJsonObject;
var
 sCommand: string;
 Ds: TDataset;
begin
 sCommand := string.Format(TFocosCommands.ListMember, [id]);
 Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(sCommand);
 Result := TJSonObject.Create;
 Result.AddPair('codigo', self.GetJsonValue(Ds.Fields.FieldByName('codfoc')));
 Result.AddPair('nome', self.GetJsonValue(Ds.Fields.FieldByName('nomfoc')));
 Result.AddPair('matricula', self.GetJsonValue(Ds.Fields.FieldByName('sigfoc')));
 Result.AddPair('tipo', self.GetJsonValue(Ds.Fields.FieldByName('tipfoc')));
 Result.AddPair('ativo', self.GetJsonValue(Ds.Fields.FieldByName('indati')));
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
