program cosmos;

uses
  System.StartUpCopy,
  FMX.Forms,
  cosmos.view.main in 'view\cosmos.view.main.pas' {FrmMain},
  client.dao.http.connection in 'Model\DAO\client.dao.http.connection.pas',
  client.dao.http.connection.interfaces in 'Model\DAO\client.dao.http.connection.interfaces.pas',
  client.controller.regions in 'Controller\client.controller.regions.pas',
  client.controller.regions.interfaces in 'Controller\client.controller.regions.interfaces.pas',
  client.model.regions in 'Model\client.model.regions.pas',
  client.model.regions.interfaces in 'Model\client.model.regions.interfaces.pas',
  client.model.customobj in 'Model\client.model.customobj.pas',
  client.dao.http.connection.consts in 'Model\DAO\client.dao.http.connection.consts.pas',
  client.model.regions.regionobj in 'Model\client.model.regions.regionobj.pas',
  client.model.regions.factory in 'Model\client.model.regions.factory.pas',
  cosmos.view.regions.actions in 'view\cosmos.view.regions.actions.pas',
  client.controller.regions.types in 'Controller\client.controller.regions.types.pas',
  cosmos.view.regions.actions.interfaces in 'view\cosmos.view.regions.actions.interfaces.pas',
  client.dao.http.connection.regions in 'Model\DAO\client.dao.http.connection.regions.pas',
  client.dao.http.connection.regions.interfaces in 'Model\DAO\client.dao.http.connection.regions.interfaces.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
