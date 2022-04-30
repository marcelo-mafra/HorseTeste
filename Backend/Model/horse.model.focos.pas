unit horse.model.focos;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON,
  horse.service.params.types,
  horse.model.focos.interfaces, horse.dao.focos.datasets,
  horse.model.customobj ;

type
  TModelFocos = class(TModelCustomObject, IModelFocos)
    private

    protected
      constructor Create(const Params: TBackendParams); overload;
      constructor Create(const Params: TBackendParams; obj: TJsonObject); overload;
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
      class function New(const Params: TBackendParams; obj: TJsonObject): IModelFocos; overload;
      procedure ToObject(obj: TJsonObject); override;
  end;

implementation

{ TModelFocos }

constructor TModelFocos.Create(const Params: TBackendParams);
begin
 inherited Create(Params);
end;

constructor TModelFocos.Create(const Params: TBackendParams; obj: TJsonObject);
begin
 self.Create(Params);
 self.ToObject(obj);
end;

destructor TModelFocos.Destroy;
begin

  inherited;
end;

class function TModelFocos.New(const Params: TBackendParams): IModelFocos;
begin
 result := self.Create(Params);
end;

class function TModelFocos.New(const Params: TBackendParams;
  obj: TJsonObject): IModelFocos;
begin
 Result := self.Create(Params, obj);
end;

function TModelFocos.ListAll: TJsonArray;
begin
 Result := TDAOFocos.New(Params).ListAll;
end;

function TModelFocos.ListFocosParent(const id: integer): TJsonArray;
begin
 Result := TDAOFocos.New(Params).ListFocosParent(id);
end;

function TModelFocos.ListFocosRegion(const id: integer): TJsonArray;
begin
 Result := TDAOFocos.New(Params).ListFocosRegion(id);
end;

function TModelFocos.ListFocosStatus(const status: boolean): TJsonArray;
begin
 Result := TDAOFocos.New(Params).ListFocosStatus(status);
end;

function TModelFocos.ListFocosTipo(const id: integer;
  const tipo: string): TJsonArray;
begin
 Result := TDAOFocos.New(Params).ListFocosTipo(id, tipo);
end;

function TModelFocos.ListMember(const id: integer): TJsonObject;
begin
 Result := TDAOFocos.New(Params).ListMember(id);
end;

function TModelFocos.DesativarFoco(const id: integer): TJsonObject;
begin
 Result := TDAOFocos.New(Params).DesativarFoco(id);
end;

function TModelFocos.ReativarFoco(const id: integer): TJsonObject;
begin
 Result := TDAOFocos.New(Params).ReativarFoco(id);
end;

procedure TModelFocos.ToObject(obj: TJsonObject);
begin
  inherited;

end;

end.
