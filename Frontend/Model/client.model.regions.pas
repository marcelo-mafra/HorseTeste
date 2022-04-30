unit client.model.regions;

interface

uses
  System.Classes,
  client.model.regions.interfaces, client.model.customobj, System.JSON,
  client.dao.http.connection.interfaces, client.dao.http.connection.regions,
  client.dao.http.connection.regions.interfaces;

type
  TModelRegions = class(TModelCustomObject, IModelRegions)
    private

    protected
     constructor Create;
     function GetRegions: string;
     function ListParentRegions(const OwnerId: integer): TJSONArray;

    public
     destructor Destroy; override;
     class function New: IModelRegions;

     function HttpServer: IHttpConnectRegions; reintroduce;
  end;

implementation

{ TModelRegions }

constructor TModelRegions.Create;
begin
 inherited;
end;

destructor TModelRegions.Destroy;
begin

  inherited;
end;

class function TModelRegions.New: IModelRegions;
begin
 Result := self.Create;
end;

function TModelRegions.GetRegions: string;
begin
 Result := self.HttpServer.Connect.GetRegions;
end;

function TModelRegions.HttpServer: IHttpConnectRegions;
begin
 Result := THttpConnectRegions.New as IHttpConnectRegions;
end;

function TModelRegions.ListParentRegions(const OwnerId: integer): TJSONArray;
begin
 Result := self.HttpServer.Connect.ListParentRegions(OwnerId);
end;

end.
