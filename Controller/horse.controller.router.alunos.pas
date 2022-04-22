unit horse.controller.router.alunos;

interface

uses
 System.Classes, System.SysUtils, System.JSON, Web.HTTPApp,
 Horse, horse.service.params.types,
 horse.controller.router.consts, horse.model.params.builder,
 {$IF DEFINED(ALUNOS_SVC)}
 horse.model.alunos,
 {$ENDIF}
 horse.model.params.builder.json;
type
 TAlunosEndpoints = class

 public
   class var Params: TBackendParams;

   class procedure GetAlunoEndpoint(Request: THorseRequest; Response: THorseResponse;
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
 Response.Send<TJsonObject>(TModelAlunos.New(self.Params).ListMember(Request.Params.Field('id').AsInteger));
end;

class procedure TAlunosEndpoints.GetAlunosEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
 Response.Send<TJsonArray>(TModelAlunos.New(self.Params).ListAll);
end;

class procedure TAlunosEndpoints.GetAlunosFocoEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
 Response.Send<TJsonArray>(TModelAlunos.New(self.Params).ListByFoco(Request.Params.Field('id').AsInteger));
end;

class procedure TAlunosEndpoints.GetAlunosGroupEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
 Response.Send<TJsonArray>(TModelAlunos.New(self.Params).ListByGroup(Request.Params.Field('focoid').AsInteger,
    Request.Params.Field('groupid').AsInteger));
end;

class procedure TAlunosEndpoints.RegistrarEndpoints;
begin
  if not self.Params.isValidConnectionStr then
    Exit;

  {$IF DEFINED(ALUNOS_SVC)}
  //Endpoints do domínio ALUNOS
  THorse.Routes.RegisterRoute(mtGet, TEndPoints.Alunos, GetAlunosEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TEndPoints.Aluno, GetAlunoEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TEndPoints.AlunosFoco, GetAlunosFocoEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TEndPoints.AlunosFocoGroup, GetAlunosGroupEndpoint);
  {$ENDIF}
end;

end.
