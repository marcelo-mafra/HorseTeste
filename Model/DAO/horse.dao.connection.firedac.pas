unit horse.dao.connection.firedac;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils, Data.DB,
 System.variants, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.DApt, FireDAC.Stan.Factory,
 FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
 FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
 FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
 //horse units...
 horse.dao.connection.interfaces,
 horse.dao.connection.types,
 horse.dao.exceptions,
 horse.dao.exceptions.consts;

type
  //Abstrai o acesso a dados do domínio "Horse" usando Firedac
  TFiredacHorseConnection = class(TInterfacedObject, IAbstractConnection)
  private
   FConnectionStr: string;
   FConnectionTimeout, FCommandTimeout: integer;
   FADOConnObj: TFDConnection; //Objeto interno de connection usando FireDAC
   FADODataset: TFDQuery; //Objeto interno de query usando FireDAC
   //Eventos mapeados
   FOnError: TOnDBErrorEvent;
   FOnExecuteCommand: TOnExecuteCommandEvent;

   function CreateConnection: TFDConnection; inline;
   procedure DestroyConnection; inline;
   procedure DestroyQuery; inline;

  protected
   constructor Create(const ConnectionStr: string; const ConnectionTimeout: integer;
      const QueryTimeout: integer; OnError: TOnDBErrorEvent;
      OnExecuteCommand: TOnExecuteCommandEvent);
   //IAbstractConnection methods
   function Connection: TCustomConnection;
   function CreateDataset(const Command: string): TDataset; inline;
   procedure ExecuteCommand(const Command: string);
   procedure ExecuteScript(var Script: TStringList);

  public
   destructor  Destroy; override;
   class function New(const ConnectionStr: string; const ConnectionTimeout: integer;
      const QueryTimeout: integer; OnError: TOnDBErrorEvent; OnExecuteCommand: TOnExecuteCommandEvent): IAbstractConnection;

   //Eventos de TFiredacHorseConnection
   property OnError: TOnDBErrorEvent read FOnError;
   property OnExecuteCommand: TOnExecuteCommandEvent read FOnExecuteCommand;
  end;

implementation

{ TFiredacHorseConnection }

constructor TFiredacHorseConnection.Create(const ConnectionStr: string;
  const ConnectionTimeout: integer; const QueryTimeout: integer;
  OnError: TOnDBErrorEvent; OnExecuteCommand: TOnExecuteCommandEvent);
begin
 FConnectionStr := ConnectionStr;
 FConnectionTimeout := ConnectionTimeout;
 FCommandTimeout := QueryTimeout;
 inherited Create;
 if Assigned(OnError) then FOnError := OnError;
 if Assigned(OnExecuteCommand) then FOnExecuteCommand := OnExecuteCommand;
end;

destructor TFiredacHorseConnection.Destroy;
begin
  FOnError := nil;
  FOnExecuteCommand := nil;
  DestroyQuery;
  DestroyConnection;

  inherited Destroy;
end;

class function TFiredacHorseConnection.New(const ConnectionStr: string; const ConnectionTimeout: integer;
    const QueryTimeout: integer; OnError: TOnDBErrorEvent; OnExecuteCommand: TOnExecuteCommandEvent): IAbstractConnection;
begin
 //Retorna a interface de conexão de dados e métodos DAO
 Result := self.Create(ConnectionStr, ConnectionTimeout, QueryTimeout, OnError, OnExecuteCommand) as IAbstractConnection;
end;

function TFiredacHorseConnection.Connection: TCustomConnection;
begin
 Result := self.CreateConnection as TFDConnection;
end;

function TFiredacHorseConnection.CreateConnection: TFDConnection;
begin
 //Cria, configura e conecta um objeto de conexão com o database
 if not Assigned(FADOConnObj) then
  begin
    FADOConnObj := TFDConnection.Create(nil);
    FADOConnObj.ConnectionString := self.FConnectionStr;
    FADOConnObj.LoginPrompt := False;
  end;

  try
   Result := FADOConnObj;
   if not FADOConnObj.Connected then FADOConnObj.Connected := True;

  except
   on E: Exception do
    begin
     if Assigned(FADOConnObj) then FreeAndNil(FADOConnObj);
     Result := FADOConnObj;
    end;
  end;
end;

function TFiredacHorseConnection.CreateDataset(const Command: string): TDataset;
begin
//Cria e retorna um dataset conectado a um TFDConnection
 Result := TFDQuery.Create(nil);
 try
   TFDQuery(Result).Connection := TFDConnection(self.Connection);
   TFDQuery(Result).SQL.Text := Command;
   TFDQuery(Result).Open;
 except
   on E: Exception do
    begin
     if Assigned(Result) then
      begin
       if Result.Active then TFDQuery(Result).Close;
       FreeAndNil(Result);
      end;
     if Assigned(FOnError) then self.OnError(E.Message, E.ClassName, Command);
     raise;
    end;
 end;
end;

procedure TFiredacHorseConnection.DestroyConnection;
begin
 //Destrói o objeto TADOConnection usado nas operações
 try
  if Assigned(FADOConnObj) and (FADOConnObj.Connected) then FADOConnObj.Close;
 finally
  if Assigned(FADOConnObj) then FreeAndNil(FADOConnObj);
 end;
end;

procedure TFiredacHorseConnection.DestroyQuery;
begin
 //Destrói o objeto TADODataset usado nas operações.
 try
  if Assigned(FADODataset) and FADODataset.Active then FADODataset.Close;
 finally
  if Assigned(FADODataset) then FreeAndNil(FADODataset);
 end;
end;

procedure TFiredacHorseConnection.ExecuteCommand(const Command: string);
begin
 //Executa um comando SQL dentro de contexto transacional.
 try
  //Inicia uma nova transação e executa cada um dos comandos existentes em "Script"
  TFDConnection(Connection).StartTransaction;
  TFDConnection(Connection).ExecSQL(Command);
  //Finalmente, tenta dar "commit" em todas as execuções dos comandos
  if TFDConnection(Connection).InTransaction then TFDConnection(Connection).Commit;

 except
  on E: Exception do
   begin
     //Rollback na execuçao do comando
     if TFDConnection(Connection).InTransaction then TFDConnection(Connection).Rollback;
     raise;
   end;
 end;
end;

procedure TFiredacHorseConnection.ExecuteScript(var Script: TStringList);
var
 I: integer;
 CurrentCmd: string;
begin
//Executa um script de diversos comandos SQL dentro de um mesmo contexto transacional
 if not (Assigned(Script)) or (Script.Count = 0) then Exit;
 try
  //Inicia uma nova transação
  TFDConnection(Connection).StartTransaction;
  //Executa cada um dos comandos existentes em "Script"
  for I := 0 to Pred(Script.Count) do
   begin
    CurrentCmd := Script.Strings[I];
    if Trim(CurrentCmd) = EmptyStr then Continue;
    TFDConnection(Connection).ExecSQL(CurrentCmd);
   end;
  //Finalmente, tenta dar "commit" em todas as execuções dos comandos
  if TFDConnection(Connection).InTransaction then TFDConnection(Connection).Commit;

 except
  on E: Exception do
   begin
     //Reverte a execução de todos os comandos do script.
     if TFDConnection(Connection).InTransaction then TFDConnection(Connection).Rollback;
     //Dispara o evento OnExecuteCommand, ao término da execução com falha fatal.
     if Assigned(FOnExecuteCommand) then OnExecuteCommand(CurrentCmd, Script, E);
     raise;
   end;
 end;
end;


end.
