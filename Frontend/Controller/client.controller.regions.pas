unit client.controller.regions;

interface

uses
  System.Classes, client.controller.regions.interfaces,
  client.dao.http.connection, client.model.regions,
  client.model.regions.regionobj, client.model.regions.factory,
  System.JSON, Client.controller.regions.types;

type


  TControllerRegions = class(TInterfacedObject, IControllerRegions)
    private

    protected
      constructor Create;
      function ListRegions: TRegionsList;
      function ListParentRegions(const OwnerId: integer): TRegionsList;

    public
      destructor Destroy; override;
      class function New: IControllerRegions;
  end;

implementation

{ TControllerRegions }

constructor TControllerRegions.Create;
begin
 inherited;
end;

destructor TControllerRegions.Destroy;
begin

  inherited;
end;

class function TControllerRegions.New: IControllerRegions;
begin
 Result := self.Create;
end;

function TControllerRegions.ListParentRegions(
  const OwnerId: integer): TRegionsList;
var
 Arrayobj: TJSONArray;
begin
 Arrayobj := TModelRegions.New.ListParentRegions(OwnerId);
 try
   Result := TRegionsFactory.CreateObjectList(Arrayobj)
 finally
  Arrayobj.DisposeOf;
 end;
end;

function TControllerRegions.ListRegions: TRegionsList;
var
 Arrayobj: TJSONArray;
begin
 Arrayobj := TJSONObject.ParseJSONValue(TModelRegions.New.GetRegions, true) as TJSONArray;
 try
   Result := TRegionsFactory.CreateObjectList(Arrayobj)
 finally
  Arrayobj.DisposeOf;
 end;
end;

end.
