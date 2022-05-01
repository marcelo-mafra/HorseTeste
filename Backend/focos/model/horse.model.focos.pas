unit horse.model.focos;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON,
  horse.service.params.types,
  horse.model.focos.interfaces, horse.dao.focos.datasets,
  horse.model.customobj, System.SysUtils, horse.model.exceptions ;

type
  TModelFocos = class(TModelCustomObject, IModelFocos)
    protected
      constructor Create(const Params: TBackendParams);
      function ListAll: TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function ListFocosParent(const id: integer): TJsonArray;
      function ListFocosRegion(const id: integer): TJsonArray;
      function ListFocosStatus(const status: boolean): TJsonArray;
      function ListFocosTipo(const id: integer; const tipo: string): TJsonArray;
      function DesativarFoco(const id: integer): TJsonObject;
      function ReativarFoco(const id: integer): TJsonObject;

    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IModelFocos; overload;

  end;

implementation

{ TModelFocos }

constructor TModelFocos.Create(const Params: TBackendParams);
begin
 inherited Create(Params);
end;

destructor TModelFocos.Destroy;
begin

  inherited;
end;

class function TModelFocos.New(const Params: TBackendParams): IModelFocos;
begin
 result := self.Create(Params);
end;

function TModelFocos.ListAll: TJsonArray;
begin
 try
  Result := TDAOFocos.New(Params).ListAll;
 except
 on E: Exception do
  begin
   E.RaiseOuterException(ECosmosInternalError.Create);
  end;
 end;
end;

function TModelFocos.ListFocosParent(const id: integer): TJsonArray;
begin
 try
  Result := TDAOFocos.New(Params).ListFocosParent(id);
 except
 on E: Exception do
  begin
   E.RaiseOuterException(ECosmosInternalError.Create);
  end;
 end;
end;

function TModelFocos.ListFocosRegion(const id: integer): TJsonArray;
begin
 try
  Result := TDAOFocos.New(Params).ListFocosRegion(id);
 except
 on E: Exception do
  begin
   E.RaiseOuterException(ECosmosInternalError.Create);
  end;
 end;
end;

function TModelFocos.ListFocosStatus(const status: boolean): TJsonArray;
begin
 try
  Result := TDAOFocos.New(Params).ListFocosStatus(status);
 except
 on E: Exception do
  begin
   E.RaiseOuterException(ECosmosInternalError.Create);
  end;
 end;
end;

function TModelFocos.ListFocosTipo(const id: integer;
  const tipo: string): TJsonArray;
begin
 try
  Result := TDAOFocos.New(Params).ListFocosTipo(id, tipo);
 except
 on E: Exception do
  begin
   E.RaiseOuterException(ECosmosInternalError.Create);
  end;
 end;
end;

function TModelFocos.ListMember(const id: integer): TJsonObject;
begin
 try
  Result := TDAOFocos.New(Params).ListMember(id);
 except
 on E: Exception do
  begin
   E.RaiseOuterException(ECosmosInternalError.Create);
  end;
 end;
end;

function TModelFocos.DesativarFoco(const id: integer): TJsonObject;
begin
 try
  Result := TDAOFocos.New(Params).DesativarFoco(id);
 except
 on E: Exception do
  begin
   E.RaiseOuterException(ECosmosInternalError.Create);
  end;
 end;
end;

function TModelFocos.ReativarFoco(const id: integer): TJsonObject;
begin
 try
  Result := TDAOFocos.New(Params).ReativarFoco(id);
 except
 on E: Exception do
  begin
   E.RaiseOuterException(ECosmosInternalError.Create);
  end;
 end;
end;

end.
