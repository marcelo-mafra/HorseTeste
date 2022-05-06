unit horse.controller.router.usuarios;

interface

uses
 System.Classes, System.SysUtils, System.JSON, Web.HTTPApp,
 Horse,
 horse.service.params.types,
 horse.controller.router.consts, horse.controller.router.usuarios.consts,
 horse.model.usuarios, horse.model.exceptions;

type
 TUsuariosEndpoints = class
  public
   class var Params: TBackendParams;

   class procedure GetUsuarioEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetUsuariosEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure PostUsuarioEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure PutUsuarioEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetAutenticarEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);

   class procedure RegistrarEndpoints;

 end;

implementation

{ TUsuariosEndpoints }

class procedure TUsuariosEndpoints.GetAutenticarEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin

end;

class procedure TUsuariosEndpoints.GetUsuarioEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
    Response.Send<TJsonObject>(TModelUsuarios.New(Params)
            .ListMember(Request.Params.Field('id').AsInteger));
  except
  on E: ECosmosError do
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
  end;
end;

class procedure TUsuariosEndpoints.GetUsuariosEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
   Response.Send<TJsonArray>(TModelUsuarios.New(Params).ListMembers);
  except
  on E: ECosmosError do
    Response.Send<TJsonObject>(E.AsJson).Status(THTTPStatus.InternalServerError);
  end;
end;

class procedure TUsuariosEndpoints.PostUsuarioEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin

end;

class procedure TUsuariosEndpoints.PutUsuarioEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin

end;

class procedure TUsuariosEndpoints.RegistrarEndpoints;
begin
  if not self.Params.isValidConnectionStr then
    Exit;

  //Endpoints do domínio SECURITY
  THorse.Routes.RegisterRoute(mtGet, TUsuariosURI.Autenticar, GetAutenticarEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TUsuariosURI.Usuarios, GetUsuariosEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TUsuariosURI.Usuario, GetUsuarioEndpoint);
  THorse.Routes.RegisterRoute(mtPost,TUsuariosURI.Usuarios, PostUsuarioEndpoint);
  THorse.Routes.RegisterRoute(mtPut, TUsuariosURI.Usuario, PutUsuarioEndpoint);
end;

end.
