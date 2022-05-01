unit horse.controller.router.alunos;

interface

uses
 System.Classes, System.SysUtils, System.JSON, Web.HTTPApp,
 Horse, horse.service.params.types,
 horse.controller.router.consts, horse.model.params.builder,
 {$IF DEFINED(ALUNOS_SVC)}
 horse.model.alunos,
 {$ENDIF}
 horse.model.params.builder.json, horse.controller.router.alunos.consts,
  horse.model.exceptions;
type
 TAlunosEndpoints = class

 public
   class var Params: TBackendParams;

   class procedure GetAlunoEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetAlunoMatriculaEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetAlunosEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetAlunosFocoEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure GetAlunosGroupEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure RegistrarEndpoints;
 end;

implementation

{ TAlunosEndpoints }

class procedure TAlunosEndpoints.GetAlunoEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
   Response.Send<TJsonObject>(TModelAlunos.New(self.Params).ListMember(Request.Params.Field('id').AsInteger));
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

class procedure TAlunosEndpoints.GetAlunoMatriculaEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  try
   Response.Send<TJsonObject>(TModelAlunos.New(self.Params).ListMemberMatricula(Request.Params.Field('matricula').AsString));
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

class procedure TAlunosEndpoints.GetAlunosEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  try
   Response.Send<TJsonArray>(TModelAlunos.New(self.Params).ListAll);
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

class procedure TAlunosEndpoints.GetAlunosFocoEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  try
   Response.Send<TJsonArray>(TModelAlunos.New(self.Params).ListByFoco(Request.Params.Field('id').AsInteger));
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

class procedure TAlunosEndpoints.GetAlunosGroupEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  try
   Response.Send<TJsonArray>(TModelAlunos.New(self.Params).ListByGroup(Request.Params.Field('focoid').AsInteger,
      Request.Params.Field('groupid').AsString));
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

class procedure TAlunosEndpoints.RegistrarEndpoints;
begin
  if not self.Params.isValidConnectionStr then
    Exit;

  {$IF DEFINED(ALUNOS_SVC)}
  //Endpoints do domínio ALUNOS
  THorse.Routes.RegisterRoute(mtGet, TAlunosURI.Alunos, GetAlunosEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TAlunosURI.Aluno, GetAlunoEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TAlunosURI.AlunoMatricula, GetAlunoMatriculaEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TAlunosURI.AlunosFoco, GetAlunosFocoEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TAlunosURI.AlunosFocoGroup, GetAlunosGroupEndpoint);
  {$ENDIF}
end;

end.
