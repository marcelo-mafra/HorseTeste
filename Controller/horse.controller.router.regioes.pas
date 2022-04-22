unit horse.controller.router.regioes;

interface

uses
 System.Classes, System.SysUtils, System.JSON, Web.HTTPApp,
 Horse, horse.service.params.types, horse.controller.router.consts,
 {$IF DEFINED(FOCOS_SVC)}
 horse.model.regioes,
 {$ENDIF}
 horse.model.exceptions, horse.controller.router.exceptions;

type
 TRegioesEndpoints = class

 public
   class var Params: TBackendParams;

   class procedure GetRegionsEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetRegionsParentEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure PostNewRegion(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure PutRegion(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure RegistrarEndpoints;

 end;

implementation

{ TRegioesEndpoints }

class procedure TRegioesEndpoints.GetRegionsEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
   Response.Send<TJsonArray>(TModelRegioes.New(Params).ListRegions);
  except
  on E: ECosmosError do
   begin
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
   end;
  on E: Exception do
   begin
    Response.Send(E.Message).Status(THTTPStatus.InternalServerError);
   end;
  end;
end;

class procedure TRegioesEndpoints.GetRegionsParentEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  try
   Response.Send<TJsonArray>(TModelRegioes.New(Params).ListRegionsParent(Request.Params.Field('id').AsInteger));
  except
  on E: ECosmosError do
   begin
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
   end;
  on E: Exception do
   begin
    Response.Send(E.Message).Status(THTTPStatus.InternalServerError);
   end;
  end;
end;

class procedure TRegioesEndpoints.PostNewRegion(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
 try
  if not (Request.RawWebRequest.ContentType = TContentsTypes.Json) then
    raise EInvalidJsonContentType.Create;

  TModelRegioes.New(Params).NewRegion(Request.Body<TJsonObject>);
  Response.Send(string.Empty).Status(THTTPStatus.Created);

 except
  on E: ECosmosError do
   begin
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
   end;
  on E: Exception do
   begin
    Response.Send(E.Message).Status(THTTPStatus.InternalServerError);
   end;
 end;
end;

class procedure TRegioesEndpoints.PutRegion(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
 try
  if not (Request.RawWebRequest.ContentType = TContentsTypes.Json) then
    raise EInvalidJsonContentType.Create;

  Response.Send<TJsonObject>(TModelRegioes.New(Params)
    .UpdateRegion(Request.Body<TJsonObject>))
    .Status(THTTPStatus.Accepted);

 except
  on E: ECosmosError do
   begin
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.NotAcceptable);
   end;
  on E: Exception do
   begin
    Response.Send(E.Message).Status(THTTPStatus.InternalServerError);
   end;
 end;
end;

class procedure TRegioesEndpoints.RegistrarEndpoints;
begin
  if not self.Params.isValidConnectionStr then
    Exit;

  {$IF DEFINED(FOCOS_SVC)}
  //Endpoints do domínio REGIOES
  THorse.Routes.RegisterRoute(mtGet, TEndPointsRegions.Regions, GetRegionsEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TEndPointsRegions.RegionsParent, GetRegionsParentEndpoint);
  THorse.Routes.RegisterRoute(mtPost, TEndPointsRegions.Regions, PostNewRegion);
  THorse.Routes.RegisterRoute(mtPut,  TEndPointsRegions.RegionsMember, PutRegion);
  {$ENDIF}
end;

end.
