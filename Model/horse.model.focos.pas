unit horse.model.focos;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON,
  horse.service.params.types,
  horse.model.focos.interfaces, horse.dao.focos.datasets ;

type
  TModelFocos = class(TInterfacedObject, IModelFocos)
    private
      FParams: TBackendParams;
    protected
      constructor Create(const Params: TBackendParams);
      function ListAll: TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function ListFocosParent(const id: integer): TJsonArray;
      function ListFocosRegion(const id: integer): TJsonArray;

    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IModelFocos;
  end;

implementation

{ TModelFocos }

constructor TModelFocos.Create(const Params: TBackendParams);
begin
 inherited Create;
 self.FParams := Params;
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
 Result := TDAOFocos.New(FParams).ListAll;
end;

function TModelFocos.ListFocosParent(const id: integer): TJsonArray;
begin
 Result := TDAOFocos.New(FParams).ListFocosParent(id);
end;

function TModelFocos.ListFocosRegion(const id: integer): TJsonArray;
begin
 Result := TDAOFocos.New(FParams).ListFocosRegion(id);
end;

function TModelFocos.ListMember(const id: integer): TJsonObject;
begin
 Result := TDAOFocos.New(FParams).ListMember(id);
end;

end.
