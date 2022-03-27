unit nfe.localservice.dao.checkers.dbobj;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, Data.DB,
  //nfe units
  nfe.localservice.model.params.types,
  nfe.localservice.dao.process.events,
  nfe.localservice.dao.connection.interfaces,
  nfe.localservice.dao.connection.factory,
  nfe.localservice.dao.exceptions.consts,
  nfe.localservice.model.logs.types,
  nfe.localservice.dao.logs.interfaces,
  nfe.localservice.dao.logs,  
  nfe.localservice.model.nfeobj,
  nfe.localservice.dao.checkers.interfaces,
  nfe.localservice.dao.checkers.customobj, 
  nfe.localservice.dao.commands.interfaces, 
  nfe.localservice.dao.commands.builder;

type
  {Classe-base de todas as classes "checker" que acessam banco de dados }
  TDAOCustomDBChecker = class (TDAOCustomChecker, ICustomDBChecker)
    strict private
      procedure DoOnDAOErrorEvent(ErrorInfo: string; ErrorSource: string;
          Command: string);
      procedure DoOnDAOExecCommand(Command: string; Script: TStringList; E: Exception);

    private
      FOnUnknownData: TOnUnknownDataEvent;
      function GetCommandBuilder: ICommandBuilder;
      function GetConnection: IAbstractConnection;
      procedure FillEnvironmentInfo(var Data: TLogData; const Obj: TNFEObject); inline;

    protected
      constructor Create(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
      //ICustomDBChecker
      function HasData(const command: string): boolean;

    public
      destructor Destroy; override;
      class function New(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): ICustomDBChecker;

      property CommandBuilder: ICommandBuilder read GetCommandBuilder;
      property Connection: IAbstractConnection read GetConnection ;
      //TDAOCustomChecker
      property Formatter;
      property Logs;
      property Params;
      //eventos
      property OnCheckerExecute;
      property OnUnknownData: TOnUnknownDataEvent read FOnUnknownData;
  end;

implementation

{ TDAOCustomDBChecker }

constructor TDAOCustomDBChecker.Create(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
begin
 inherited Create(ServiceParams, OnCheckerExecute);
 FOnUnknownData := OnUnknownData;
end;

destructor TDAOCustomDBChecker.Destroy;
begin
 FOnUnknownData := nil;
 inherited Destroy;
end;

class function TDAOCustomDBChecker.New(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): ICustomDBChecker;
begin
 Result := TDAOCustomDBChecker.Create(ServiceParams, OnCheckerExecute, OnUnknownData);
end;

function TDAOCustomDBChecker.HasData(const command: string): boolean;
var
 Ds: TDataset;
begin
 try
  //Excuta um comando "select" e verifica se algum registro foi encontrado
  Ds := TConnectionFactory.New(Params.Data, Params.Timeouts).CreateDataset(Command);
  Result := Assigned(Ds) and (Ds.Active) and not (Ds.IsEmpty);

 finally
  if Assigned(Ds) then
   begin
    if Ds.Active then Ds.Close;
    FreeAndNil(Ds);
   end;
 end;
end;

procedure TDAOCustomDBChecker.DoOnDAOErrorEvent(ErrorInfo, ErrorSource,
  Command: string);
var
 Data: TLogData;
begin
 //Implementa o evento "TOnADOErrorEvent" de TNFEADOConnection
 Data.Tipo           := ltError;
 Data.Text           := Format(TDAOErrorMessages.ErrorInfo, [ErrorSource, ErrorInfo]);
 Data.Command        := Command;
 Data.ExceptionClass := ErrorSource;
 Data.SourceType     := lsTechnicalInfo;
 FillEnvironmentInfo(Data, nil);
 self.Logs.RegisterLog(Data);
end;

procedure TDAOCustomDBChecker.DoOnDAOExecCommand(Command: string; Script: TStringList;
  E: Exception);
var
 Data: TLogData;
begin
 //Aponta para o evento "OnExecuteCommand" de TNFEADOConnection
 if Assigned(Script) and (Script.Text <> EmptyStr) then Data.Command := Script.Text
 else
    if Command <> EmptyStr then Data.Command := Command;

 if Assigned(E) then //Cenário de erro ocorrido
  begin
   Data.Tipo := ltError;
   Data.Text := Format(TDAOErrorMessages.ExecScriptError, [E.Message]);
   Data.ExceptionClass := E.ClassName;
   Data.SourceType := lsTechnicalInfo;
  end
  else
   begin //Cenário de sucesso
    Data.Tipo := ltInfo;
    Data.Text := Format(TDAOInfoMessages.ExecScriptInfo, [Script.Count]);
    Data.SourceType := lsTechnicalInfo;
   end;
  FillEnvironmentInfo(Data, nil);
  Logs.RegisterLog(Data);
end;

procedure TDAOCustomDBChecker.FillEnvironmentInfo(var Data: TLogData;
  const Obj: TNFEObject);
begin
 //Preenche "Data" com as informações do ambiente de execução
 Data.ThreadId  := Params.Task.ThreadId;
 Data.StartTime := Params.Task.StartTime;
 Data.EndTime   := Params.Task.EndTime;

 if Assigned(Obj) then
  begin
   Obj.ToText(Data.DetailsInfo);
   Data.ChaveNfe := Obj.ChaveNfe;
  end;
end;

function TDAOCustomDBChecker.GetCommandBuilder: ICommandBuilder;
begin
 //Retorna uma interface para a "construção" de comandos sql
 Result := TCommandBuilder.New(Params);
end;

function TDAOCustomDBChecker.GetConnection: IAbstractConnection;
begin
 Result := TConnectionFactory.New(Params.Data, Params.Timeouts,
                                  DoOnDAOErrorEvent, DoOnDAOExecCommand);
end;

end.
