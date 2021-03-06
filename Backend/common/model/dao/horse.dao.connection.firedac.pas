unit horse.dao.connection.firedac;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils, System.variants, Data.DB,
 FireDAC.Stan.Param, FireDAC.Comp.Client, FireDAC.Stan.Def,
 FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.DApt, FireDAC.Stan.Factory,
 FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
 FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
 FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.DataSet,
 //horse units...
 horse.dao.connection.interfaces,
 horse.dao.connection.types,
 horse.dao.exceptions,
 horse.dao.exceptions.consts;

type
  //Abstrai o acesso a dados do dom?nio "Horse" usando Firedac
  TFiredacHorseConnection = class(TInterfacedObject, IAbstractConnection)
  private
   FConnectionStr: string;
   FConnectionTimeout, FCommandTimeout: integer;
   FFDConnObj: TFDConnection; //Objeto interno de connection usando FireDAC
   FFDDataset: TFDQuery; //Objeto interno de query usando FireDAC
   //Eventos mapeados
   FOnError: TOnDBErrorEvent;
   FOnExecuteCommand: TOnExecuteCommandEvent;
   procedure CommitTransaction(Obj: TFDConnection); inline;
   procedure Rollback(Obj: TFDConnection); inline;

   function CreateConnection: TFDConnection; inline;
   procedure DestroyConnection; inline;
   procedure DestroyQuery; inline;

  protected
   constructor Create(const ConnectionStr: string; const ConnectionTimeout: integer;
      const QueryTimeout: integer; OnError: TOnDBErrorEvent;
      OnExecuteCommand: TOnExecuteCommandEvent);
   //IAbstractConnection methods
   function Connection: TCustomConnection;
   function CreateDataset(const Command: string): TDataset; overload;
   function CreateDataset(const Command: string; const Params: TParams): TDataset; overload;
   procedure ExecuteCommand(const Command: string); overload;
   procedure ExecuteCommand(const Command: string; var Executed: boolean); overload;
   procedure ExecuteCommand(const Command: string; const Params: TParams); overload;
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
 //Retorna a interface de conex?o de dados e m?todos DAO
 Result := self.Create(ConnectionStr, ConnectionTimeout, QueryTimeout, OnError, OnExecuteCommand) as IAbstractConnection;
end;

procedure TFiredacHorseConnection.Rollback(Obj: TFDConnection);
begin
if TFDConnection(Connection).InTransaction then TFDConnection(Connection).Rollback;
end;

procedure TFiredacHorseConnection.CommitTransaction(Obj: TFDConnection);
begin
  if Obj.InTransaction then Obj.Commit;
end;

function TFiredacHorseConnection.Connection: TCustomConnection;
begin
 Result := self.CreateConnection as TFDConnection;
end;

function TFiredacHorseConnection.CreateConnection: TFDConnection;
begin
 //Cria, configura e conecta um objeto de conex?o com o database
 if not Assigned(FFDConnObj) then
  begin
    FFDConnObj := TFDConnection.Create(nil);
    FFDConnObj.ConnectionString := self.FConnectionStr;
    FFDConnObj.LoginPrompt := False;
  end;

  try
   Result := FFDConnObj;
   if not FFDConnObj.Connected then FFDConnObj.Connected := True;

  except
   on E: Exception do
    begin
     if Assigned(FFDConnObj) then FreeAndNil(FFDConnObj);
     Result := FFDConnObj;
    end;
  end;
end;

function TFiredacHorseConnection.CreateDataset(const Command: string;
  const Params: TParams): TDataset;
var
 FDParams: TFDParams;
begin
//Cria e retorna um dataset conectado a um TFDConnection
 Result := TFDQuery.Create(nil);
 FDParams := TFDParams.Create;
 FDParams.Assign(Params);
 try
   TFDQuery(Result).Connection := TFDConnection(self.Connection);
   TFDQuery(Result).SQL.Text := Command;
   TFDQuery(Result).Params.Assign(FDParams);
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
 //Destr?i o objeto TADOConnection usado nas opera??es
 try
  if Assigned(FFDConnObj) and (FFDConnObj.Connected) then FFDConnObj.Close;
 finally
  if Assigned(FFDConnObj) then FreeAndNil(FFDConnObj);
 end;
end;

procedure TFiredacHorseConnection.DestroyQuery;
begin
 //Destr?i o objeto TADODataset usado nas opera??es.
 try
  if Assigned(FFDDataset) and FFDDataset.Active then FFDDataset.Close;
 finally
  if Assigned(FFDDataset) then FreeAndNil(FFDDataset);
 end;
end;

procedure TFiredacHorseConnection.ExecuteCommand(const Command: string);
begin
 //Executa um comando SQL dentro de contexto transacional.
 try
  //Inicia uma nova transa??o e executa cada um dos comandos existentes em "Script"
  TFDConnection(Connection).StartTransaction;
  TFDConnection(Connection).ExecSQL(Command);
  //Finalmente, tenta dar "commit" em todas as execu??es dos comandos
  self.CommitTransaction(TFDConnection(Connection));

 except
  on E: Exception do
   begin
     //Rollback na execu?ao do comando
     self.Rollback(TFDConnection(Connection));
     raise;
   end;
 end;
end;

procedure TFiredacHorseConnection.ExecuteCommand(const Command: string;
  var Executed: boolean);
begin
 Executed := False;
 //Executa um comando SQL dentro de contexto transacional.
 try
  //Inicia uma nova transa??o e executa cada um dos comandos existentes em "Script"
  TFDConnection(Connection).StartTransaction;
  Executed := TFDConnection(Connection).ExecSQL(Command) > 0;
  //Finalmente, tenta dar "commit" em todas as execu??es dos comandos
  self.CommitTransaction(TFDConnection(Connection));

 except
  on E: Exception do
   begin
     //Rollback na execu?ao do comando
     self.Rollback(TFDConnection(Connection));
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
  //Inicia uma nova transa??o
  TFDConnection(Connection).StartTransaction;
  //Executa cada um dos comandos existentes em "Script"
  for I := 0 to Pred(Script.Count) do
   begin
    CurrentCmd := Script.Strings[I];
    if CurrentCmd.Trim = EmptyStr then Continue;
    TFDConnection(Connection).ExecSQL(CurrentCmd);
   end;
  //Finalmente, tenta dar "commit" em todas as execu??es dos comandos
  self.CommitTransaction(TFDConnection(Connection));

 except
  on E: Exception do
   begin
     //Reverte a execu??o de todos os comandos do script.
     self.Rollback(TFDConnection(Connection));
     //Dispara o evento OnExecuteCommand, ao t?rmino da execu??o com falha fatal.
     if Assigned(FOnExecuteCommand) then OnExecuteCommand(CurrentCmd, Script, E);
     raise;
   end;
 end;
end;

procedure TFiredacHorseConnection.ExecuteCommand(const Command: string;
    const Params: TParams);
var
 FDParams: TFDParams;
begin
 //Executa um comando SQL dentro de contexto transacional.
  FDParams := TFDParams.Create;
  FDParams.Assign(Params);

 try
  //Inicia uma nova transa??o e executa cada um dos comandos existentes em "Script"
  TFDConnection(Connection).StartTransaction;
  TFDConnection(Connection).ExecSQL(Command, FDParams);
  //Finalmente, tenta dar "commit" em todas as execu??es dos comandos
  self.CommitTransaction(TFDConnection(Connection));

 except
  on E: Exception do
   begin
     //Rollback na execu?ao do comando
     self.Rollback(TFDConnection(Connection));
     raise;
   end;
 end;
end;

end.
