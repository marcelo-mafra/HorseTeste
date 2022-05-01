program focosConsole;

{$APPTYPE CONSOLE}

{$DEFINE FOCOS_SVC}

{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  Horse,
  Horse.Request,
  horse.controller.router in '..\common\controller\horse.controller.router.pas',
  horse.controller.router.consts in '..\common\controller\horse.controller.router.consts.pas',
  horse.service.params in '..\common\service\horse.service.params.pas',
  horse.controller.router.types in '..\common\controller\horse.controller.router.types.pas',
  horse.service.params.consts in '..\common\service\horse.service.params.consts.pas',
  horse.dao.connection.factory in '..\common\model\dao\horse.dao.connection.factory.pas',
  horse.model.params.types in '..\common\model\horse.model.params.types.pas',
  horse.model.params.builder.json in '..\common\model\horse.model.params.builder.json.pas',
  horse.model.params.builder in '..\common\model\horse.model.params.builder.pas',
  horse.model.params.exceptions in '..\common\model\horse.model.params.exceptions.pas',
  horse.dao.connection.interfaces in '..\common\model\dao\horse.dao.connection.interfaces.pas',
  horse.dao.connection.types in '..\common\model\dao\horse.dao.connection.types.pas',
  horse.dao.exceptions.consts in '..\common\model\dao\horse.dao.exceptions.consts.pas',
  horse.dao.exceptions in '..\common\model\dao\horse.dao.exceptions.pas',
  horse.service.params.types in '..\common\service\horse.service.params.types.pas',
  horse.dao.connection.firedac in '..\common\model\dao\horse.dao.connection.firedac.pas',
  horse.controller.router.focos in 'Controller\horse.controller.router.focos.pas',
  horse.model.focos.interfaces in 'Model\horse.model.focos.interfaces.pas',
  horse.model.focos in 'Model\horse.model.focos.pas',
  horse.dao.focos.interfaces in 'Model\DAO\horse.dao.focos.interfaces.pas',
  horse.dao.focos.datasets in 'model\dao\horse.dao.focos.datasets.pas',
  horse.dao.focos.sqlconsts in 'Model\DAO\horse.dao.focos.sqlconsts.pas',
  horse.controller.router.regioes in 'Controller\horse.controller.router.regioes.pas',
  horse.model.regioes in 'Model\horse.model.regioes.pas',
  horse.model.regioes.interfaces in 'Model\horse.model.regioes.interfaces.pas',
  horse.dao.regioes.datasets in 'Model\DAO\horse.dao.regioes.datasets.pas',
  horse.dao.regioes.interfaces in 'Model\DAO\horse.dao.regioes.interfaces.pas',
  horse.dao.regioes.sqlconsts in 'Model\DAO\horse.dao.regioes.sqlconsts.pas',
  horse.model.exceptions in '..\common\model\horse.model.exceptions.pas',
  horse.model.regioes.exceptions in 'Model\horse.model.regioes.exceptions.pas',
  horse.model.customobj in '..\common\model\horse.model.customobj.pas',
  horse.controller.router.exceptions in '..\common\controller\horse.controller.router.exceptions.pas',
  horse.model.params.builder.interfaces in '..\common\model\horse.model.params.builder.interfaces.pas',
  horse.dao.customobj.datasets in '..\common\model\dao\horse.dao.customobj.datasets.pas',
  horse.controller.router.focos.consts in 'Controller\horse.controller.router.focos.consts.pas',
  horse.dao.helpers.json in '..\common\model\dao\horse.dao.helpers.json.pas';

procedure InitializeService;
var
 Params: TBackendParams;
 SvcRouter: IHorseRouter;
begin
  Writeln(Format(TBackendInfo.Starting, [TBackendInfo.SvcFocos]));
  SvcRouter := THorseRouter.New;
  Params := SvcRouter.ServiceParams;
  writeln(Format(TBackendInfo.HorseVersion, [SvcRouter.HorseVersion]));
  writeln(Format(TBackendInfo.Listenning, [Params.ServiceName, Params.Host + ':' + Params.Porta.ToString]));
  writeln(Format(TBackendInfo.ParamsInfo, [Params.ServiceName, Params.ParamsFile]));
  SvcRouter.RegisterEndpoints
    .InitializeService
    (
      procedure(AReq: THorseRequest; ARes: THorseResponse; ANext: TNextProc)
      begin
        Writeln(AReq.Body);
      end
    ).Listen;
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
