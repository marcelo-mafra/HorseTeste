program cosmosec;

{$APPTYPE CONSOLE}

{$DEFINE SECURITY_SVC}

{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  horse.service.params.consts in '..\common\service\horse.service.params.consts.pas',
  horse.service.params in '..\common\service\horse.service.params.pas',
  horse.service.params.types in '..\common\service\horse.service.params.types.pas',
  horse.controller.router.consts in '..\common\controller\horse.controller.router.consts.pas',
  horse.controller.router.exceptions in '..\common\controller\horse.controller.router.exceptions.pas',
  horse.controller.router in '..\common\controller\horse.controller.router.pas',
  horse.controller.router.types in '..\common\controller\horse.controller.router.types.pas',
  horse.model.customobj in '..\common\model\horse.model.customobj.pas',
  horse.model.exceptions in '..\common\model\horse.model.exceptions.pas',
  horse.model.params.builder.interfaces in '..\common\model\horse.model.params.builder.interfaces.pas',
  horse.model.params.builder.json in '..\common\model\horse.model.params.builder.json.pas',
  horse.model.params.builder in '..\common\model\horse.model.params.builder.pas',
  horse.model.params.exceptions in '..\common\model\horse.model.params.exceptions.pas',
  horse.model.params.types in '..\common\model\horse.model.params.types.pas',
  horse.controller.router.usuarios in 'controller\horse.controller.router.usuarios.pas',
  horse.controller.router.usuarios.consts in 'controller\horse.controller.router.usuarios.consts.pas',
  horse.model.usuarios in 'model\horse.model.usuarios.pas',
  horse.model.usuarios.interfaces in 'model\horse.model.usuarios.interfaces.pas',
  horse.dao.usuarios in 'model\dao\horse.dao.usuarios.pas',
  horse.dao.usuarios.interfaces in 'model\dao\horse.dao.usuarios.interfaces.pas',
  horse.dao.customobj.datasets in '..\common\model\dao\horse.dao.customobj.datasets.pas',
  horse.dao.connection.factory in '..\common\model\dao\horse.dao.connection.factory.pas',
  horse.dao.connection.interfaces in '..\common\model\dao\horse.dao.connection.interfaces.pas',
  horse.dao.connection.firedac in '..\common\model\dao\horse.dao.connection.firedac.pas',
  horse.dao.connection.types in '..\common\model\dao\horse.dao.connection.types.pas',
  horse.dao.exceptions.consts in '..\common\model\dao\horse.dao.exceptions.consts.pas',
  horse.dao.exceptions in '..\common\model\dao\horse.dao.exceptions.pas',
  horse.dao.usuarios.sqlconsts in 'model\dao\horse.dao.usuarios.sqlconsts.pas';

procedure InitializeService;
var
 Params: TBackendParams;
 SvcRouter: IHorseRouter;
begin
  SvcRouter := THorseRouter.New;
  Params := SvcRouter.ServiceParams;
  Writeln(Format(TBackendInfo.Starting, [Params.ServiceName]));
  writeln(Format(TBackendInfo.HorseVersion, [SvcRouter.HorseVersion]));
  writeln(Format(TBackendInfo.Listenning, [Params.ServiceName, Params.Host + ':' + Params.Porta.ToString]));
  writeln(Format(TBackendInfo.ParamsInfo, [Params.ServiceName, Params.ParamsFile]));
  SvcRouter.RegisterEndpoints.InitializeService.Listen;
end;

begin
  try
    ReportMemoryLeaksOnShutdown := True;
    InitializeService;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
