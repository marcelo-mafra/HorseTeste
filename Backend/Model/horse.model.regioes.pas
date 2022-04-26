unit horse.model.regioes;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON,
  horse.service.params.types, horse.model.customobj,
  horse.model.regioes.interfaces, horse.dao.regioes.datasets;

type
  TModelRegioes = class(TModelCustomObject, IModelRegioes)
    private
      FParams: TBackendParams;
    protected
      constructor Create(const Params: TBackendParams);
      //regiões administrativas
      function ListRegions: TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function ListRegionsParent(const id: integer): TJsonArray;
      procedure NewRegion(obj: TJsonObject);
      function UpdateRegion(obj: TJsonObject): TJsonObject;
      function DeleteRegion(const id: integer): boolean;

    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IModelRegioes;
      function AsJson(const Data: string): TJsonObject; override;
  end;

implementation

{ TModelRegioes }

constructor TModelRegioes.Create(const Params: TBackendParams);
begin
 inherited Create;
 self.FParams := Params;
end;

destructor TModelRegioes.Destroy;
begin

  inherited;
end;

class function TModelRegioes.New(const Params: TBackendParams): IModelRegioes;
begin
 result := self.Create(Params);
end;

procedure TModelRegioes.NewRegion(obj: TJsonObject);
begin
 try
  TDAORegioes.New(FParams).NewRegion(obj);
 except
  raise;
 end;
end;

function TModelRegioes.UpdateRegion(obj: TJsonObject): TJsonObject;
begin
 try
  Result := TDAORegioes.New(FParams).UpdateRegion(obj);
 except
  raise;
 end;
end;

function TModelRegioes.DeleteRegion(const id: integer): boolean;
begin
 try
  Result := TDAORegioes.New(FParams).DeleteRegion(id);
 except
  raise;
 end;
end;

function TModelRegioes.ListMember(const id: integer): TJsonObject;
begin
 try
  Result := TDAORegioes.New(FParams).ListMember(id);
 except
  raise;
 end;
end;

function TModelRegioes.ListRegions: TJsonArray;
begin
 Result := TDAORegioes.New(FParams).ListRegions;
end;

function TModelRegioes.ListRegionsParent(const id: integer): TJsonArray;
begin
 Result := TDAORegioes.New(FParams).ListRegionsParent(id);
end;

function TModelRegioes.AsJson(const Data: string): TJsonObject;
begin
 Result := TJsonObject.ParseJSONValue(data, true, false) as TJsonObject;
end;


end.
