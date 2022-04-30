program focosConsole;

{$APPTYPE CONSOLE}

{$DEFINE FOCOS_SVC}

{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  Horse,
  Horse.Request,
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
  horse.service.params.types in 'Service\horse.service.params.types.pas',
  horse.dao.connection.firedac in 'Model\DAO\horse.dao.connection.firedac.pas',
  horse.controller.router.focos in 'Controller\horse.controller.router.focos.pas',
  horse.model.focos.interfaces in 'Model\horse.model.focos.interfaces.pas',
  horse.model.focos in 'Model\horse.model.focos.pas',
  horse.dao.focos.interfaces in 'Model\DAO\horse.dao.focos.interfaces.pas',
  horse.dao.focos.datasets in 'Model\DAO\horse.dao.focos.datasets.pas',
  horse.dao.focos.sqlconsts in 'Model\DAO\horse.dao.focos.sqlconsts.pas',
  horse.controller.router.regioes in 'Controller\horse.controller.router.regioes.pas',
  horse.model.regioes in 'Model\horse.model.regioes.pas',
  horse.model.regioes.interfaces in 'Model\horse.model.regioes.interfaces.pas',
  horse.dao.regioes.datasets in 'Model\DAO\horse.dao.regioes.datasets.pas',
  horse.dao.regioes.interfaces in 'Model\DAO\horse.dao.regioes.interfaces.pas',
  horse.dao.regioes.sqlconsts in 'Model\DAO\horse.dao.regioes.sqlconsts.pas',
  horse.model.exceptions in 'Model\horse.model.exceptions.pas',
  horse.model.regioes.exceptions in 'Model\horse.model.regioes.exceptions.pas',
  horse.model.customobj in 'Model\horse.model.customobj.pas',
  horse.controller.router.exceptions in 'Controller\horse.controller.router.exceptions.pas',
  horse.model.params.builder.interfaces in 'Model\horse.model.params.builder.interfaces.pas',
  horse.dao.customobj.datasets in 'Model\DAO\horse.dao.customobj.datasets.pas',
  horse.dao.customobj.datasets.helpers in 'Model\DAO\horse.dao.customobj.datasets.helpers.pas';

procedure DoCallback(AReq: THorseRequest; ARes: THorseResponse; ANext: TNextProc);
begin
Writeln(AReq.Body);
end;

procedure InitializeService;
var
 Params: TBackendParams;
begin
  Writeln(Format(TBackendInfo.Starting, [TBackendInfo.SvcFocos]));
  Params := THorseRouter.New.ServiceParams;
  writeln(Format(TBackendInfo.HorseVersion, [THorseRouter.New.HorseVersion]));
  writeln(Format(TBackendInfo.Listenning, [TBackendInfo.SvcFocos, Params.Host + ':' + Params.Porta.ToString ]));
  THorseRouter.New.RegisterEndpoints
    .InitializeService
    (
      procedure(AReq: THorseRequest; ARes: THorseResponse; ANext: TNextProc)
      begin
        Writeln(AReq.Body);
      end
    );
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
