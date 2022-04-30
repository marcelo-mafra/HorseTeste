unit client.dao.http.connection.regions;

interface

uses
  System.Classes, System.JSON,
  client.dao.http.connection,
  client.dao.http.connection.regions.interfaces, REST.Types, System.SysUtils;

type
  THttpConnectRegions = class(THttpConnect, IHttpConnectRegions)
    private
      const
        BaseUrl = 'http://localhost:8002/';
        ConnectTimeout = 9000;
        ReadTimeout = 5000;

    protected
      constructor Create;
      function GetRegions: string;
      function ListParentRegions(const OwnerId: integer): TJsonArray;
      function Connect: IHttpConnectRegions;

    public
      destructor Destroy; override;
      class function New: IHttpConnectRegions;

      property Request;
      property Response;
  end;

implementation

{ THttpConnectRegions }

constructor THttpConnectRegions.Create;
begin
 inherited;
end;

destructor THttpConnectRegions.Destroy;
begin

  inherited;
end;

class function THttpConnectRegions.New: IHttpConnectRegions;
begin
 Result := self.Create;
end;

function THttpConnectRegions.Connect: IHttpConnectRegions;
begin
 Result := self;
 self.ConnectServer(BaseUrl, ConnectTimeout, ReadTimeout);
end;

function THttpConnectRegions.GetRegions: string;
begin
 Request.Resource := 'regions';
 Request.Execute;
 Result := Request.Response.JSONText;
end;

function THttpConnectRegions.ListParentRegions(
  const OwnerId: integer): TJsonArray;
begin
//http://localhost:8002/regions/members/4
 Request.Resource := 'regions/members/{parentId}';
 Request.AddParameter('parentId', IntToStr(OwnerId), pkURLSEGMENT);
 Request.Execute;
 Result := TJSONObject.ParseJSONValue(Request.Response.JSONText, true) as TJSONArray;
end;

end.
