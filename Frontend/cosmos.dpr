program cosmos;

uses
  System.StartUpCopy,
  FMX.Forms,
  cosmos.view.main in 'view\cosmos.view.main.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
