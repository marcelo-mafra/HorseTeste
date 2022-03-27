unit nfe.localservice.dao.logs;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils,
  //NFe units...
  nfe.localservice.model.logs.types,
  nfe.localservice.model.logs.utils,
  nfe.localservice.model.params.types,
  nfe.localservice.dao.logs.interfaces,
  nfe.localservice.dao.connection.interfaces,
  nfe.localservice.dao.sqlconsts,
  nfe.localservice.dao.connection.factory,
  nfe.localservice.dao.exceptions,
  nfe.localservice.dao.exceptions.consts;


type
 //Classe DAO que implementa INFEDAOLogs para escrita de logs em banco
  TNFEDAOLogs = class(TInterfacedObject, INFEDAOLogs)
    private
     FDataParams: TModelDatabaseParams;
     FTimeoutsParams: TModelTimeouts;
     FIConnection: IAbstractConnection;
     procedure DoQuoted(var value: string); inline;
     function AsCommand(Data: TLogData): string; inline;
     function GetIConnectionIntf: IAbstractConnection;

    protected
     constructor Create(const IConnection: IAbstractConnection;
          const DataParams: TModelDatabaseParams; const TimeoutsParams: TModelTimeouts); reintroduce;
     //INFEDAOLogs
     procedure RegisterLog(Data: TLogData); overload;
     procedure RegisterLog(Data: TLogData; E: Exception); overload;
     procedure RegisterLog(Data: TLogData; iConnection: IAbstractConnection); overload;

    public
     class function New(const IConnectionIntf: IAbstractConnection;
          const DataParams: TModelDatabaseParams; const TimeoutsParams: TModelTimeouts): INFEDAOLogs;
     destructor Destroy; override;

     property Connection: IAbstractConnection read GetIConnectionIntf;
     property DataParams: TModelDatabaseParams read FDataParams;
     property TimeoutsParams: TModelTimeouts read FTimeoutsParams;
  end;

implementation

{ TNFEDAOLogs }

constructor TNFEDAOLogs.Create(const IConnection: IAbstractConnection;
  const DataParams: TModelDatabaseParams; const TimeoutsParams: TModelTimeouts);
begin
 inherited Create;
 FDataParams := DataParams;
 FTimeoutsParams := TimeoutsParams;
 FIConnection := IConnection;
 if not Assigned(FIConnection) then FIConnection := TConnectionFactory.New(DataParams, TimeoutsParams);
end;

destructor TNFEDAOLogs.Destroy;
begin
  FIConnection := nil;
  inherited Destroy;
end;

procedure TNFEDAOLogs.DoQuoted(var value: string);
begin
 //se "value" for diferente de 'null' insere aspas simples em "value"
 if value <> TSQLChars.NullChar then  Value := QuotedStr(value);
end;

class function TNFEDAOLogs.New(const IConnectionIntf: IAbstractConnection;
    const DataParams: TModelDatabaseParams; const TimeoutsParams: TModelTimeouts): INFEDAOLogs;
begin
 //método factory de TNFEDAOLogs
 Result := self.Create(IConnectionIntf, DataParams, TimeoutsParams) as INFEDAOLogs;
end;

procedure TNFEDAOLogs.RegisterLog(Data: TLogData; E: Exception);
var
 ClassRef: TClass;
begin
//Registra um novo log no contexto do tratamento da exception E
  ClassRef := E.ClassType;
  if ClassRef <> nil then Data.ExceptionClass := ClassRef.ClassName;
  self.RegisterLog(Data);
end;

function TNFEDAOLogs.GetIConnectionIntf: IAbstractConnection;
begin
 //Retorna uma interface abstrata de conectividade com uma fonte de dados.
 if not Assigned(FIConnection) then
    FIConnection := TConnectionFactory.New(DataParams, TimeoutsParams);

 if not Assigned(FIConnection) then
    raise EInvalidConnectionObject.Create(TDAOErrorMessages.InvalidConnection);
 Result := FIConnection;
end;

function TNFEDAOLogs.AsCommand(Data: TLogData): string;
var
 Info: TLogValues;
begin
 {Transforma a estrutura de dados "TLogData" em um comando SQL para inserir um novo
  log. As variáveis de ambiente são coletadas por meio da interface INFELogsUtils}
 Info := TNFELogsUtils.New.FillData(Data);

 //Trata o comprimento máximo do conteúdo "Text" do novo log a ser registrado
 if Length(Info.Text) > TLogsCommands.MaxLength then
    Info.Text := Copy(Data.Text, 0, TLogsCommands.MaxLength - 1); //Trunca o texto do log...

 //Trata o comprimento máximo do conteúdo "command" do novo log a ser registrado
 if Length(Info.Command) > TLogsCommands.MaxCmdLength then
    Info.Command := Copy(Data.Command, 0, TLogsCommands.MaxCmdLength - 1); //Trunca o texto do log...

 //Monta o comando sql final com as variáveis coletadas
 DoQuoted(Info.Text);
 DoQuoted(Info.Tipo);
 DoQuoted(Info.SystemName);
 DoQuoted(Info.ExceptionClass);
 DoQuoted(Info.Command);
 DoQuoted(Info.SourceType);
 DoQuoted(Info.ChaveNfe);

 Result := Format(TLogsCommands.NewLog, [Info.Text, Info.Tipo, Info.SystemName,
                  Info.ExceptionClass, Data.ThreadId, Info.Command, Info.SourceType,
                  Info.ChaveNfe]);
end;

procedure TNFEDAOLogs.RegisterLog(Data: TLogData; iConnection: IAbstractConnection);
begin
//Registra um novo log a partir de uma interface IAbstractConnection recebida
 if Assigned(iConnection) then iConnection.ExecuteCommand(AsCommand(Data))
end;

procedure TNFEDAOLogs.RegisterLog(Data: TLogData);
begin
//Registra um novo log sem tratamento específico de tipo de log ou contexto de exceptions
  Connection.ExecuteCommand(self.AsCommand(Data));
end;

end.
