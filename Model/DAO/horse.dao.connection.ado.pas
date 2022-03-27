unit horse.dao.connection.ado;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils, Data.DB, Data.Win.ADODB,
 System.variants, Winapi.ActiveX, System.Win.ComObj,
 //horse units...
 horse.dao.connection.interfaces,
 horse.dao.connection.ado.types,
 horse.dao.exceptions,
 horse.dao.exceptions.consts,
 horse.dao.datasets.interfaces,
 horse.dao.datasets.ado;

type
  //Abstrai o acesso a dados do domínio "Horse" usando ADO
  THorseADOConnection = class(TInterfacedObject, IHorseADOConnection)
  private
   FConnectionStr: string;
   FConnectionTimeout, FCommandTimeout: integer;
   FADOConnObj: TADOConnection; //Objeto interno de connection usando ADO (OLEDB)
   FADODataset: TADODataset; //Objeto interno de query usando ADO (OLEDB)
   //Eventos mapeados
   FOnError: TOnADOErrorEvent;
   FOnExecuteCommand: TOnExecuteCommandEvent;

   procedure InternalOnInfoMessage(Connection: TADOConnection; const Error: Error; var EventStatus: TEventStatus);
   function CreateConnection: TADOConnection; inline;
   procedure DestroyConnection; inline;
   procedure DestroyQuery; inline;

  protected
   constructor Create(const ConnectionStr: string; const ConnectionTimeout: integer;
      const QueryTimeout: integer; OnError: TOnADOErrorEvent;
      OnExecuteCommand: TOnExecuteCommandEvent);
   //IAbstractConnection methods
   function Connection: TCustomConnection;
   function CreateDataset(const Command: string): TDataset; inline;
   procedure ExecuteCommand(const Command: string);
   procedure ExecuteScript(var Script: TStringList);
   //IHorseADOConnection
   function GetIDataset: IDataset;

  public
   destructor  Destroy; override;
   class function New(const ConnectionStr: string; const ConnectionTimeout: integer;
      const QueryTimeout: integer; OnError: TOnADOErrorEvent; OnExecuteCommand: TOnExecuteCommandEvent): IHorseADOConnection;
   //IHorseADOConnection
   property Dataset: IDataset read GetIDataset;
   //Eventos de THorseADOConnection
   property OnError: TOnADOErrorEvent read FOnError;
   property OnExecuteCommand: TOnExecuteCommandEvent read FOnExecuteCommand;
  end;

implementation

{ THorseADOConnection }

constructor THorseADOConnection.Create(const ConnectionStr: string;
  const ConnectionTimeout: integer; const QueryTimeout: integer;
  OnError: TOnADOErrorEvent; OnExecuteCommand: TOnExecuteCommandEvent);
begin
 FConnectionStr := ConnectionStr;
 FConnectionTimeout := ConnectionTimeout;
 FCommandTimeout := QueryTimeout;
 inherited Create;
 if Assigned(OnError) then FOnError := OnError;
 if Assigned(OnExecuteCommand) then FOnExecuteCommand := OnExecuteCommand;
 CoInitialize(nil);
end;

destructor THorseADOConnection.Destroy;
begin
  FOnError := nil;
  FOnExecuteCommand := nil;
  DestroyQuery;
  DestroyConnection;

  CoUnInitialize;
  inherited Destroy;
end;

class function THorseADOConnection.New(const ConnectionStr: string; const ConnectionTimeout: integer;
    const QueryTimeout: integer; OnError: TOnADOErrorEvent; OnExecuteCommand: TOnExecuteCommandEvent): IHorseADOConnection;
begin
 //Retorna a interface de conexão de dados e métodos DAO
 Result := self.Create(ConnectionStr, ConnectionTimeout, QueryTimeout, OnError, OnExecuteCommand) as IHorseADOConnection;
end;

function THorseADOConnection.Connection: TCustomConnection;
begin
 Result := self.CreateConnection as TADOConnection;
end;

function THorseADOConnection.CreateConnection: TADOConnection;
begin
 //Cria, configura e conecta um objeto de conexão com o database
 if not Assigned(FADOConnObj) then
  begin
    FADOConnObj := TADOConnection.Create(nil);
    FADOConnObj.ConnectionString := self.FConnectionStr;
    FADOConnObj.LoginPrompt := False;
    FADOConnObj.ConnectionTimeout := FConnectionTimeout;
    FADOConnObj.CommandTimeout := FCommandTimeout;
    FADOConnObj.OnInfoMessage := InternalOnInfoMessage;
  end;

  try
   Result := FADOConnObj;
   if not FADOConnObj.Connected then FADOConnObj.Connected := True;

  except
   on E: EOleException do
    begin
     if Assigned(FADOConnObj) then FreeAndNil(FADOConnObj);
     Result := FADOConnObj;
    end;
   on E: Exception do
    begin
     if Assigned(FADOConnObj) then FreeAndNil(FADOConnObj);
     Result := FADOConnObj;
    end;
  end;
end;

function THorseADOConnection.CreateDataset(const Command: string): TDataset;
begin
//Cria e retorna um dataset conectado a um TADOConnection
 Result := TADODataSet.Create(nil);
 try
   TADODataSet(Result).Connection := TADOConnection(self.Connection);
   TADODataSet(Result).CommandType := cmdText;
   TADODataSet(Result).CommandText := Command;
   TADODataSet(Result).CommandTimeout := self.FCommandTimeout;
   TADODataSet(Result).Open;
 except
   on E: Exception do
    begin
     if Assigned(Result) then
      begin
       if Result.Active then TADODataSet(Result).Close;
       FreeAndNil(Result);
      end;
     if Assigned(FOnError) then self.OnError(E.Message, E.ClassName, Command);
     raise;
    end;
 end;
end;

procedure THorseADOConnection.DestroyConnection;
begin
 //Destrói o objeto TADOConnection usado nas operações
 try
  if Assigned(FADOConnObj) and (FADOConnObj.Connected) then FADOConnObj.Close;
 finally
  if Assigned(FADOConnObj) then FreeAndNil(FADOConnObj);
 end;
end;

procedure THorseADOConnection.DestroyQuery;
begin
 //Destrói o objeto TADODataset usado nas operações.
 try
  if Assigned(FADODataset) and FADODataset.Active then FADODataset.Close;
 finally
  if Assigned(FADODataset) then FreeAndNil(FADODataset);
 end;
end;

procedure THorseADOConnection.InternalOnInfoMessage(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
begin
//Dispara o evento OnError para tratamento externo
 if Assigned(FOnError) then
 begin
  //Dispara o evento "OnError"
  case EventStatus of
   esOK, esErrorsOccured, esUnwantedEvent: OnError(Error.Description, Error.Source, EmptyStr);
   esCantDeny: Exit;
   esCancel: Exit;
  end;
 end;
end;

procedure THorseADOConnection.ExecuteCommand(const Command: string);
begin
 //Executa um comando SQL dentro de contexto transacional.
 try
  //Inicia uma nova transação e executa cada um dos comandos existentes em "Script"
  TADOConnection(Connection).BeginTrans;
  TADOConnection(Connection).Execute(Command, cmdText, [eoExecuteNoRecords]);
  //Finalmente, tenta dar "commit" em todas as execuções dos comandos
  if TADOConnection(Connection).InTransaction then TADOConnection(Connection).CommitTrans;

 except
  on E: Exception do
   begin
     //Rollback na execuçao do comando
     if TADOConnection(Connection).InTransaction then TADOConnection(Connection).RollbackTrans;
     raise;
   end;
 end;
end;

procedure THorseADOConnection.ExecuteScript(var Script: TStringList);
var
 I: integer;
 CurrentCmd: string;
begin
//Executa um script de diversos comandos SQL dentro de um mesmo contexto transacional
 if not (Assigned(Script)) or (Script.Count = 0) then Exit;
 try
  //Inicia uma nova transação
  TADOConnection(Connection).BeginTrans;
  //Executa cada um dos comandos existentes em "Script"
  for I := 0 to Pred(Script.Count) do
   begin
    CurrentCmd := Script.Strings[I];
    if Trim(CurrentCmd) = EmptyStr then Continue;
    TADOConnection(Connection).Execute(CurrentCmd, cmdText, [eoExecuteNoRecords]);
   end;
  //Finalmente, tenta dar "commit" em todas as execuções dos comandos
  if TADOConnection(Connection).InTransaction then TADOConnection(Connection).CommitTrans;

 except
  on E: Exception do
   begin
     //Reverte a execução de todos os comandos do script.
     if TADOConnection(Connection).InTransaction then TADOConnection(Connection).RollbackTrans;
     //Dispara o evento OnExecuteCommand, ao término da execução com falha fatal.
     if Assigned(FOnExecuteCommand) then OnExecuteCommand(CurrentCmd, Script, E);
     raise;
   end;
 end;
end;

function THorseADOConnection.GetIDataset: IDataset;
begin
 //Retorna uma nova interface IDataset.
 Result := TADOIDataset.New(Connection);
end;


end.
