unit horse.dao.alunos.datasets;

interface

uses
 System.Classes, System.JSON, Data.DB, System.SysUtils,
  horse.dao.alunos.sqlconsts, horse.service.params.types,
  horse.dao.alunos.interfaces, horse.dao.connection.factory,
  horse.dao.customobj.datasets, horse.dao.customobj.datasets.helpers,
  horse.model.params.builder, horse.model.exceptions;

type
  TDAOAlunos = class(TDAOCustomObj, IDAOAlunos)
    protected
      constructor Create(const Params: TBackendParams);
      function ListAll: TJsonArray;
      function ListByFoco(const id: integer): TJsonArray;
      function ListByGroup(const focoid: integer; const sigdis: string): TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function ListMemberMatricula(const matricula: string): TJsonObject;

    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IDAOAlunos;
  end;

implementation

{ TDAOAlunos }

constructor TDAOAlunos.Create(const Params: TBackendParams);
begin
 inherited Create(Params);
end;

destructor TDAOAlunos.Destroy;
begin
 inherited Destroy;
end;

class function TDAOAlunos.New(const Params: TBackendParams): IDAOAlunos;
begin
 Result := self.Create(Params);
end;

function TDAOAlunos.ListAll: TJsonArray;
var
 Ds: TDataset;
 JsonObj: TJSonObject;
begin
 Result := TJsonArray.Create;
 try
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TAlunosCommands.ListAll);
   while not Ds.Eof do
    begin
     JsonObj := TJSonObject.Create;
     JsonObj.AddPair('codigo', self.ToJsonValue(Ds.Fields.FieldByName('codcad')));
     JsonObj.AddPair('nome', self.ToJsonValue(Ds.Fields.FieldByName('nomcad')));
     JsonObj.AddPair('matricula', self.ToJsonValue(Ds.Fields.FieldByName('matcad')));
     JsonObj.AddPair('discipulado', self.ToJsonValue(Ds.Fields.FieldByName('sigdis')));
     Result.AddElement(JsonObj);
     Ds.Next;
    end;
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

function TDAOAlunos.ListByFoco(const id: integer): TJsonArray;
var
 Ds: TDataset;
 JsonObj: TJSonObject;
 ParamsObj: TParams;
begin
 Result := TJsonArray.Create;
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject.Add('codfoc', id).ParamsObj;
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TAlunosCommands.ListByFoco, ParamsObj);

   while not Ds.Eof do
    begin
     JsonObj := TJSonObject.Create;
     JsonObj.AddPair('codigo', self.ToJsonValue(Ds.Fields.FieldByName('codcad')));
     JsonObj.AddPair('nome', self.ToJsonValue(Ds.Fields.FieldByName('nomcad')));
     JsonObj.AddPair('matricula', self.ToJsonValue(Ds.Fields.FieldByName('matcad')));
     JsonObj.AddPair('discipulado', self.ToJsonValue(Ds.Fields.FieldByName('sigdis')));
     Result.AddElement(JsonObj);
     Ds.Next;
    end;
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

function TDAOAlunos.ListByGroup(const focoid: integer; const sigdis: string): TJsonArray;
var
 Ds: TDataset;
 JsonObj: TJSonObject;
 ParamsObj: TParams;
begin
 Result := TJsonArray.Create;
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject
                  .Add('codfoc', focoid)
                  .Add('sigdis', sigdis)
                  .ParamsObj;
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TAlunosCommands.ListByGroup, ParamsObj);
   while not Ds.Eof do
    begin
     JsonObj := TJSonObject.Create;
     JsonObj.AddPair('codigo', self.ToJsonValue(Ds.Fields.FieldByName('codcad')));
     JsonObj.AddPair('nome', self.ToJsonValue(Ds.Fields.FieldByName('nomcad')));
     JsonObj.AddPair('matricula', self.ToJsonValue(Ds.Fields.FieldByName('matcad')));
     JsonObj.AddPair('discipulado', self.ToJsonValue(Ds.Fields.FieldByName('sigdis')));
     Result.AddElement(JsonObj);
     Ds.Next;
    end;
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

function TDAOAlunos.ListMember(const id: integer): TJsonObject;
var
 Ds: TDataset;
 ParamsObj: TParams;
begin
 Result := TJSonObject.Create;
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject.Add('codcad', id).ParamsObj;
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TAlunosCommands.ListMember, ParamsObj);
   Result.AddPair('codigo', self.ToJsonValue(Ds.Fields.FieldByName('codcad')));
   Result.AddPair('nome', self.ToJsonValue(Ds.Fields.FieldByName('nomcad')));
   Result.AddPair('matricula', self.ToJsonValue(Ds.Fields.FieldByName('matcad')));
   Result.AddPair('discipulado', self.ToJsonValue(Ds.Fields.FieldByName('sigdis')));
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

function TDAOAlunos.ListMemberMatricula(const matricula: string): TJsonObject;
var
 Ds: TDataset;
 ParamsObj: TParams;
begin
 Result := TJsonObject.Create;
 try
   ParamsObj := TModelParamsBuilder.New.BeginObject.Add('matcad', matricula).ParamsObj;
   Ds := TConnectionFactory.New(ConnectionStr).CreateDataset(TAlunosCommands.ListMemberMatricula, ParamsObj);
   Result.AddPair('codigo', self.ToJsonValue(Ds.Fields.FieldByName('codcad')));
   Result.AddPair('nome', self.ToJsonValue(Ds.Fields.FieldByName('nomcad')));
   Result.AddPair('matricula', self.ToJsonValue(Ds.Fields.FieldByName('matcad')));
   Result.AddPair('discipulado', self.ToJsonValue(Ds.Fields.FieldByName('sigdis')));
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
