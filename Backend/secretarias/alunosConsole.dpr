program alunosConsole;

{$APPTYPE CONSOLE}

{$DEFINE ALUNOS_SVC}

{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  horse.controller.router in '..\common\controller\horse.controller.router.pas',
  horse.controller.router.consts in '..\common\controller\horse.controller.router.consts.pas',
  horse.service.params in '..\common\service\horse.service.params.pas',
  horse.controller.router.types in '..\common\controller\horse.controller.router.types.pas',
  horse.service.params.consts in '..\common\service\horse.service.params.consts.pas',
  horse.dao.connection.factory in '..\common\model\dao\horse.dao.connection.factory.pas',
  horse.model.params.types in '..\common\Model\horse.model.params.types.pas',
  horse.model.params.builder.json in '..\common\Model\horse.model.params.builder.json.pas',
  horse.model.params.builder in '..\common\Model\horse.model.params.builder.pas',
  horse.model.params.exceptions in '..\common\Model\horse.model.params.exceptions.pas',
  horse.dao.connection.interfaces in '..\common\model\dao\horse.dao.connection.interfaces.pas',
  horse.dao.connection.types in '..\common\model\dao\horse.dao.connection.types.pas',
  horse.dao.exceptions.consts in '..\common\model\dao\horse.dao.exceptions.consts.pas',
  horse.dao.exceptions in '..\common\model\dao\horse.dao.exceptions.pas',
  horse.dao.datasets.consts in '..\common\model\dao\horse.dao.datasets.consts.pas',
  horse.service.params.types in '..\common\service\horse.service.params.types.pas',
  horse.dao.connection.firedac in '..\common\model\dao\horse.dao.connection.firedac.pas',
  horse.controller.router.alunos in 'Controller\horse.controller.router.alunos.pas',
  horse.model.alunos in 'Model\horse.model.alunos.pas',
  horse.dao.alunos.datasets in 'Model\DAO\horse.dao.alunos.datasets.pas',
  horse.dao.alunos.sqlconsts in 'Model\DAO\horse.dao.alunos.sqlconsts.pas',
  horse.dao.alunos.interfaces in 'Model\DAO\horse.dao.alunos.interfaces.pas',
  horse.model.alunos.interfaces in 'Model\horse.model.alunos.interfaces.pas',
  horse.model.params.builder.interfaces in '..\common\Model\horse.model.params.builder.interfaces.pas',
  horse.controller.router.alunos.consts in 'Controller\horse.controller.router.alunos.consts.pas',
  horse.dao.customobj.datasets in '..\common\model\dao\horse.dao.customobj.datasets.pas',
  horse.dao.helpers.json in '..\common\model\dao\horse.dao.helpers.json.pas',
  horse.model.exceptions in '..\common\model\horse.model.exceptions.pas',
  horse.model.customobj in '..\common\model\horse.model.customobj.pas';

procedure InitializeService;
var
 Params: TBackendParams;
 SvcRouter: IHorseRouter;
begin
  Writeln(Format(TBackendInfo.Starting, [TBackendInfo.SvcAlunos]));
  SvcRouter := THorseRouter.New;
  Params := SvcRouter.ServiceParams;
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
