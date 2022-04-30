unit client.dao.http.connection;

interface

uses

System.Classes, REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
client.dao.http.connection.interfaces, client.dao.http.connection.consts;

type
  THttpConnect = class(TInterfacedObject, IHttpConnect)
    private
      FBaseurl: string;
      FConnectTimeout, FReadTimeout: integer;
      FRestClient: TRESTClient;
      FRequestObj: TRESTRequest;
      FResponseObj: TRESTResponse;
      procedure CreateRestObjects;

    protected
      constructor Create;
      procedure ConnectServer(const BaseUrl: string; const ConnectTimeout,
            ReadTimeout: integer);

    public
      destructor Destroy; override;
      class function New: IHttpConnect;

      property Request: TRESTRequest read FRequestObj;
      property Response: TRESTResponse read FResponseObj;
  end;

implementation

{ THttpConnect }

constructor THttpConnect.Create;
begin
 inherited Create;
end;

destructor THttpConnect.Destroy;
begin
  FResponseObj.DisposeOf;
  FRequestObj.DisposeOf;
  FRestClient.DisposeOf;
  inherited Destroy;
end;

class function THttpConnect.New: IHttpConnect;
begin
 Result := self.Create;
end;

procedure THttpConnect.ConnectServer(const BaseUrl: string; const ConnectTimeout,
      ReadTimeout: integer);
begin
 FBaseUrl := BaseUrl;
 FConnectTimeout := ConnectTimeout;
 FReadTimeout := ReadTimeout;
 CreateRestObjects;
end;

procedure THttpConnect.CreateRestObjects;
begin
 FRestClient := TRestClient.Create(FBaseUrl);
 FRestClient.ConnectTimeout := FConnectTimeout;
 FRestClient.ReadTimeout    := FReadTimeout;
 FRestClient.FallbackCharsetEncoding  := TRequestConst.UTF8Encoding;
 FRestClient.HandleRedirects := True;
 FRequestObj := TRESTRequest.Create(nil);
 Request.Client := FRestClient;
 Request.Accept := TRequestConst.Accept;
 Request.AcceptCharset := TRequestConst.AcceptCharset;
 Request.Method := rmGET; //default
 Request.Resource := ''; //default
 FResponseObj := TRESTResponse.Create(nil);
 Response.ContentType := TRequestConst.JsonContent;
 Request.Response := Response;
end;

end.
