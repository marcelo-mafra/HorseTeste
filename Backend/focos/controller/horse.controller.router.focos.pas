unit horse.controller.router.focos;

interface

uses
 System.Classes, System.SysUtils, System.JSON, Web.HTTPApp,
 Horse, horse.service.params.types,
 {$IF DEFINED(FOCOS_SVC)}
 horse.model.focos,
 {$ENDIF}
 horse.controller.router.consts, horse.controller.router.focos.consts,
  horse.model.exceptions;

type
 TFocosEndpoints = class

 public
   class var Params: TBackendParams;
   class procedure GetFocoEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetFocosEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetFocosParentEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetFocosRegionEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure PutDesativarFocoEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure PutReativarFocoEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetFocosStatusEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetFocosTipoEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure RegistrarEndpoints;

 end;

implementation

{ TFocosEndpoints }

class procedure TFocosEndpoints.GetFocoEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
   Response.Send<TJsonObject>(TModelFocos.New(self.Params)
           .ListMember(Request.Params.Field('id').AsInteger));
  except
  on E: ECosmosError do
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
  end;
end;

class procedure TFocosEndpoints.GetFocosEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
    Response.Send<TJsonArray>(TModelFocos.New(Params).ListAll);
  except
  on E: ECosmosError do
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
  end;
end;

class procedure TFocosEndpoints.GetFocosParentEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  try
    Response.Send<TJsonArray>(TModelFocos.New(Params)
            .ListFocosParent(Request.Params.Field('id').AsInteger));
  except
  on E: ECosmosError do
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
  end;
end;

class procedure TFocosEndpoints.GetFocosRegionEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  try
    Response.Send<TJsonArray>(TModelFocos.New(Params)
            .ListFocosRegion(Request.Params.Field('id').AsInteger));
  except
  on E: ECosmosError do
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
  end;
end;

class procedure TFocosEndpoints.GetFocosStatusEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
    Response.Send<TJsonArray>(TModelFocos.New(Params)
            .ListFocosStatus(Request.Params.Field('status').AsBoolean));
  except
  on E: ECosmosError do
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
  end;
end;

class procedure TFocosEndpoints.GetFocosTipoEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
    Response.Send<TJsonArray>(TModelFocos.New(Params).ListFocosTipo
      (
        Request.Params.Field('idregiao').AsInteger,
        Request.Params.Field('tipo').Asstring
      ));
  except
  on E: ECosmosError do
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
  end;
end;

class procedure TFocosEndpoints.PutDesativarFocoEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
    Response.Send<TJsonObject>(TModelFocos.New(self.Params).DesativarFoco(Request.Params.Field('id').AsInteger));
  except
  on E: ECosmosError do
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
  end;
end;

class procedure TFocosEndpoints.PutReativarFocoEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
   Response.Send<TJsonObject>(TModelFocos.New(self.Params)
           .ReativarFoco(Request.Params.Field('id').AsInteger));
  except
  on E: ECosmosError do
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
  end;
end;

class procedure TFocosEndpoints.RegistrarEndpoints;
begin
  if not self.Params.isValidConnectionStr then
    Exit;

  {$IF DEFINED(FOCOS_SVC)}
  //Endpoints do domínio FOCOS
  THorse.Routes.RegisterRoute(mtGet, TFocosURI.Foco, GetFocoEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TFocosURI.Focos, GetFocosEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TFocosURI.FocosParent, GetFocosParentEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TFocosURI.FocosRegions, GetFocosRegionEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TFocosURI.FocosStatus, GetFocosStatusEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TFocosURI.FocosTipo, GetFocosTipoEndpoint);
  THorse.Routes.RegisterRoute(mtPut, TFocosURI.FocoDesativar, PutDesativarFocoEndpoint);
  THorse.Routes.RegisterRoute(mtPut, TFocosURI.FocoReativar, PutReativarFocoEndpoint);
  {$ENDIF}
end;

end.
