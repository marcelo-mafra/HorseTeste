unit horse.model.regioes;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON,
  horse.service.params.types, horse.model.customobj,
  horse.model.regioes.interfaces, horse.dao.regioes.datasets,
  horse.model.exceptions, System.SysUtils;

type
  TModelRegioes = class(TModelCustomObject, IModelRegioes)
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
      class function New(const Params: TBackendParams): IModelRegioes; overload;
  end;

implementation

{ TModelRegioes }

constructor TModelRegioes.Create(const Params: TBackendParams);
begin
 inherited Create(Params);
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
   TDAORegioes.New(Params).NewRegion(obj);
 except
   on E: ECosmosError do
       raise;
   on E: Exception do
       E.RaiseOuterException(ECosmosInternalError.Create);
 end;
end;

function TModelRegioes.UpdateRegion(obj: TJsonObject): TJsonObject;
begin
 try
  Result := TDAORegioes.New(Params).UpdateRegion(obj);
 except
   on E: ECosmosError do
       raise;
   on E: Exception do
       E.RaiseOuterException(ECosmosInternalError.Create);
 end;
end;

function TModelRegioes.DeleteRegion(const id: integer): boolean;
begin
 try
  Result := TDAORegioes.New(Params).DeleteRegion(id);
 except
   on E: ECosmosError do
       raise;
   on E: Exception do
       E.RaiseOuterException(ECosmosInternalError.Create);
 end;
end;

function TModelRegioes.ListMember(const id: integer): TJsonObject;
begin
 try
  Result := TDAORegioes.New(Params).ListMember(id);
 except
   on E: ECosmosError do
       raise;
   on E: Exception do
       E.RaiseOuterException(ECosmosInternalError.Create);
 end;
end;

function TModelRegioes.ListRegions: TJsonArray;
begin
 try
  Result := TDAORegioes.New(Params).ListRegions;
 except
   on E: ECosmosError do
       raise;
   on E: Exception do
       E.RaiseOuterException(ECosmosInternalError.Create);
 end;
end;

function TModelRegioes.ListRegionsParent(const id: integer): TJsonArray;
begin
 try
  Result := TDAORegioes.New(Params).ListRegionsParent(id);
 except
   on E: ECosmosError do
       raise;
   on E: Exception do
       E.RaiseOuterException(ECosmosInternalError.Create);
 end;
end;

end.
