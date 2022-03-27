program backendhorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  horse.controller.router in 'Controller\horse.controller.router.pas',
  horse.controller.router.sample in 'Controller\horse.controller.router.sample.pas',
  horse.controller.router.consts in 'Controller\horse.controller.router.consts.pas',
  horse.service.params in 'Service\horse.service.params.pas',
  horse.controller.router.types in 'Controller\horse.controller.router.types.pas',
  horse.controller.router.clientes in 'Controller\horse.controller.router.clientes.pas',
  horse.service.params.consts in 'Service\horse.service.params.consts.pas',
  horse.dao.connection.factory in 'Model\DAO\horse.dao.connection.factory.pas',
  horse.model.params.types in 'Model\horse.model.params.types.pas',
  horse.model.params.builder.json in 'Model\horse.model.params.builder.json.pas',
  horse.model.params.builder in 'Model\horse.model.params.builder.pas',
  horse.model.params.exceptions in 'Model\horse.model.params.exceptions.pas',
  horse.dao.connection.interfaces in 'Model\DAO\horse.dao.connection.interfaces.pas',
  horse.dao.datasets.interfaces in 'Model\DAO\horse.dao.datasets.interfaces.pas',
  horse.dao.connection.ado.types in 'Model\DAO\horse.dao.connection.ado.types.pas',
  horse.dao.connection.ado in 'Model\DAO\horse.dao.connection.ado.pas',
  horse.dao.exceptions.consts in 'Model\DAO\horse.dao.exceptions.consts.pas',
  horse.dao.exceptions in 'Model\DAO\horse.dao.exceptions.pas',
  horse.dao.datasets.ado in 'Model\DAO\horse.dao.datasets.ado.pas',
  horse.dao.datasets.ado.consts in 'Model\DAO\horse.dao.datasets.ado.consts.pas',
  horse.service.params.types in 'Service\horse.service.params.types.pas';

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
