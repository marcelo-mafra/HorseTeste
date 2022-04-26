program alunosConsole;

{$APPTYPE CONSOLE}

{$DEFINE ALUNOS_SVC ON}

{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  horse.controller.router in 'Controller\horse.controller.router.pas',
  horse.controller.router.consts in 'Controller\horse.controller.router.consts.pas',
  horse.service.params in 'Service\horse.service.params.pas',
  horse.controller.router.types in 'Controller\horse.controller.router.types.pas',
  horse.service.params.consts in 'Service\horse.service.params.consts.pas',
  horse.dao.connection.factory in 'Model\DAO\horse.dao.connection.factory.pas',
  horse.model.params.types in 'Model\horse.model.params.types.pas',
  horse.model.params.builder.json in 'Model\horse.model.params.builder.json.pas',
  horse.model.params.builder in 'Model\horse.model.params.builder.pas',
  horse.model.params.exceptions in 'Model\horse.model.params.exceptions.pas',
  horse.dao.connection.interfaces in 'Model\DAO\horse.dao.connection.interfaces.pas',
  horse.dao.connection.types in 'Model\DAO\horse.dao.connection.types.pas',
  horse.dao.exceptions.consts in 'Model\DAO\horse.dao.exceptions.consts.pas',
  horse.dao.exceptions in 'Model\DAO\horse.dao.exceptions.pas',
  horse.dao.datasets.consts in 'Model\DAO\horse.dao.datasets.consts.pas',
  horse.service.params.types in 'Service\horse.service.params.types.pas',
  horse.dao.connection.firedac in 'Model\DAO\horse.dao.connection.firedac.pas',
  horse.controller.router.alunos in 'Controller\horse.controller.router.alunos.pas',
  horse.model.alunos in 'Model\horse.model.alunos.pas',
  horse.dao.alunos.datasets in 'Model\DAO\horse.dao.alunos.datasets.pas',
  horse.dao.alunos.sqlconsts in 'Model\DAO\horse.dao.alunos.sqlconsts.pas',
  horse.dao.alunos.interfaces in 'Model\DAO\horse.dao.alunos.interfaces.pas',
  horse.model.alunos.interfaces in 'Model\horse.model.alunos.interfaces.pas',
  horse.controller.router.focos in 'Controller\horse.controller.router.focos.pas',
  horse.model.params.builder.interfaces in 'Model\horse.model.params.builder.interfaces.pas';

procedure InitializeService;
var
 Params: TBackendParams;
begin
  Params := THorseRouter.New.ServiceParams;
  writeln(Format(TCoreBackendInfo.HorseVersion, [THorseRouter.New.HorseVersion]));
  writeln(Format(TCoreBackendInfo.Listenning, [Params.Host + ':' + Params.Porta.ToString ]));
  THorseRouter.New.RegisterEndpoints.InitializeService;
end;

begin
  try
    InitializeService;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
