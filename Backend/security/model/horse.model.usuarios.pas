unit horse.model.usuarios;

interface

uses
  System.Classes, System.SysUtils,
  horse.model.customobj, horse.model.usuarios.interfaces,
  horse.service.params.types, System.JSON, horse.dao.usuarios,
  horse.model.exceptions;

type
  TModelUsuarios = class(TModelCustomObject, IModelUsuarios)
    protected
      constructor Create(const Params: TBackendParams);
      function ListMembers: TJsonArray;
      function ListMember(const id: integer): TJsonObject;

    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IModelUsuarios;

  end;

implementation

{ TModelUsuarios }

constructor TModelUsuarios.Create(const Params: TBackendParams);
begin
 inherited Create(Params);
end;

destructor TModelUsuarios.Destroy;
begin

  inherited Destroy;
end;

class function TModelUsuarios.New(const Params: TBackendParams): IModelUsuarios;
begin
 result := self.Create(Params);
end;

function TModelUsuarios.ListMembers: TJsonArray;
begin
 try
  Result := TDAOUsuarios.New(Params).ListAll;
 except
 on E: ECosmosError do
     raise;
 on E: Exception do
     E.RaiseOuterException(ECosmosInternalError.Create);
 end;
end;

function TModelUsuarios.ListMember(const id: integer): TJsonObject;
begin
 try
  Result := TDAOUsuarios.New(Params).ListMember(id);
 except
 on E: ECosmosError do
     raise;
 on E: Exception do
     E.RaiseOuterException(ECosmosInternalError.Create);
 end;
end;

end.
