unit horse.controller.router.focos;

interface

uses
 System.Classes, System.SysUtils, System.JSON, Web.HTTPApp,
 Horse, horse.service.params.types,
 {$IF DEFINED(FOCOS_SVC)}
 horse.model.focos,
 {$ENDIF}
 horse.controller.router.consts;

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
   class procedure RegistrarEndpoints;

 end;

implementation

{ TFocosEndpoints }

class procedure TFocosEndpoints.GetFocoEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
 Response.Send<TJsonObject>(TModelFocos.New(self.Params).ListMember(Request.Params.Field('id').AsInteger));
end;

class procedure TFocosEndpoints.GetFocosEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  Response.Send<TJsonArray>(TModelFocos.New(Params).ListAll);
end;

class procedure TFocosEndpoints.GetFocosParentEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  Response.Send<TJsonArray>(TModelFocos.New(Params).ListFocosParent(Request.Params.Field('id').AsInteger));
end;

class procedure TFocosEndpoints.GetFocosRegionEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  Response.Send<TJsonArray>(TModelFocos.New(Params).ListFocosRegion(Request.Params.Field('id').AsInteger));
end;

class procedure TFocosEndpoints.PutDesativarFocoEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
 Response.Send<TJsonObject>(TModelFocos.New(self.Params).DesativarFoco(Request.Params.Field('id').AsInteger));
end;

class procedure TFocosEndpoints.PutReativarFocoEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
 Response.Send<TJsonObject>(TModelFocos.New(self.Params).ReativarFoco(Request.Params.Field('id').AsInteger));
end;

class procedure TFocosEndpoints.RegistrarEndpoints;
begin
  if not self.Params.isValidConnectionStr then
    Exit;

  {$IF DEFINED(FOCOS_SVC)}
  //Endpoints do domínio FOCOS
  THorse.Routes.RegisterRoute(mtGet, TEndPointsFocos.Foco, GetFocoEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TEndPointsFocos.Focos, GetFocosEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TEndPointsFocos.FocosParent, GetFocosParentEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TEndPointsFocos.FocosRegions, GetFocosRegionEndpoint);
  THorse.Routes.RegisterRoute(mtPut, TEndPointsFocos.FocoDesativar, PutDesativarFocoEndpoint);
  THorse.Routes.RegisterRoute(mtPut, TEndPointsFocos.FocoReativar, PutReativarFocoEndpoint);
  {$ENDIF}
end;

end.
