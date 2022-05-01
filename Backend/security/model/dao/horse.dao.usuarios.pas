unit horse.dao.usuarios;

interface

uses
  System.Classes,  System.SysUtils, System.JSON, Data.DB, Dataset.Serialize,
  horse.dao.usuarios.interfaces,
  horse.dao.customobj.datasets, horse.service.params.types,
  horse.model.exceptions, horse.dao.connection.factory,
  horse.dao.usuarios.sqlconsts, horse.model.params.builder;

type
  TDAOUsuarios = class(TDAOCustomObj, IDAOUsuarios)
    protected
      constructor Create(const Params: TBackendParams);
      //IDAOUsuarios
      function ListAll: TJsonArray;
      function ListMember(const id: integer): TJsonObject;

    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IDAOUsuarios;
  end;

implementation

{ TDAOUsuarios }

constructor TDAOUsuarios.Create(const Params: TBackendParams);
begin
 inherited Create(Params);
end;

destructor TDAOUsuarios.Destroy;
begin

  inherited;
end;

class function TDAOUsuarios.New(const Params: TBackendParams): IDAOUsuarios;
begin
 Result := self.Create(Params);
end;

function TDAOUsuarios.ListAll: TJsonArray;
begin
 try
  self.ExecuteFormatter;
  Result := TConnectionFactory.New(ConnectionStr)
                .CreateDataset(TUsuariosCommands.ListAll)
                .ToJSONArray();
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

function TDAOUsuarios.ListMember(const id: integer): TJsonObject;
var
 ParamsObj: TParams;
begin
 ParamsObj := TModelParamsBuilder.New.BeginObject.Add('codusu', id).ParamsObj;
 try
   self.ExecuteFormatter;
   Result := TConnectionFactory.New(ConnectionStr)
      .CreateDataset(TUsuariosCommands.ListUser, ParamsObj)
      .ToJSONObject();
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
