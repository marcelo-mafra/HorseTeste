unit nfe.localservice.dao.process;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils, Data.DB, System.Contnrs,
 System.variants, System.Win.ComObj,
 //NFe units...
 nfe.localservice.model.nfeobj.types,
 nfe.localservice.model.nfeobj,
 nfe.localservice.model.logs.types,
 nfe.localservice.model.process.types,
 nfe.localservice.model.params.types,
 nfe.localservice.dao.interfaces,
 nfe.localservice.dao.process.events,
 nfe.localservice.dao.connection.interfaces,
 nfe.localservice.dao.connection.factory,
 nfe.localservice.dao.exceptions,
 nfe.localservice.dao.exceptions.consts,
 nfe.localservice.dao.sqlconsts,
 nfe.localservice.dao.logs,
 nfe.localservice.dao.logs.interfaces,
 nfe.localservice.dao.checkers.factory,
 nfe.localservice.model.process.exceptions,
 nfe.localservice.dao.utils,
 nfe.localservice.dao.commands.interfaces,
 nfe.localservice.dao.commands.builder,
 nfe.localservice.dao.checkers.interfaces, 
  nfe.localservice.dao.process.datainfobuilder;


type
  //Classe DAO que implementa INFEDAOProcess para processamentos de cada NFe.
  TNFEDAOProcess = class(TInterfacedObject, INFEDAOProcess)
  private
   FIConnection: IAbstractConnection;
   FOnInvalidNfe: TOnValidationNfeEvent;
   FOnValidationNfe: TOnValidationNfeEvent;
   FServiceParams: TModelServiceParams;

   procedure DoValidateNFEObj(var Obj: TNFEObject);
   procedure FillEnvironmentInfo(var Data: TLogData; const Obj: TNFEObject); inline;
   function GetCheckers(const Events: TCheckerEvents = ceFullEvents): IFactoryCheckers;
   function GetCommandBuilder: ICommandBuilder;
   function GetIConnectionIntf: IAbstractConnection;
   function GetLogInterface: INFEDAOLogs; inline;
   procedure DoOnDAOErrorEvent(ErrorInfo: string; ErrorSource: string;
    Command: string);
   procedure DoOnDAOExecCommand(Command: string; Script: TStringList; E: Exception);
   procedure DoOnMappingError(Obj: TObject; E: Exception);
   procedure DoOnInvalidNfe(Sender: TObject; const Obj: TNFEObject);
   procedure DoOnValidationNfe(Sender: TObject; const Obj: TNFEObject);
   procedure DoOnCheckerExecute(Sender: TObject; const Obj: TNFEObject;
      var Validated: boolean);
   procedure DoOnUnknownData(Sender: TObject; const Obj: TNFEObject;
      const UnknownData: TProcessDataInfo; const RefProduto: string);


  protected
   constructor Create(const ServiceParams: TModelServiceParams);
   //INFEDAOProcess: Métodos de montagem de lista de objetos TNFEObject para iniciar o processamento
   procedure CreateQueue(var List: TObjectList);
   procedure ProcessNFEObj(var Obj: TNFEObject);

  public
   destructor  Destroy; override;
   class function New(const ServiceParams: TModelServiceParams): INFEDAOProcess;

   property CommandBuilder: ICommandBuilder read GetCommandBuilder;
   property Connection: IAbstractConnection read GetIConnectionIntf ;
   property Checkers[const Events: TCheckerEvents]: IFactoryCheckers read GetCheckers;
   property Logs: INFEDAOLogs read GetLogInterface;
   property Params: TModelServiceParams read FServiceParams;
   //Eventos
   property OnInvalidNfe: TOnValidationNfeEvent read FOnInvalidNfe;
   property OnValidationNfe: TOnValidationNfeEvent read FOnValidationNfe;
  end;

implementation

{ TNFEDAOProcess }

constructor TNFEDAOProcess.Create(const ServiceParams: TModelServiceParams);
begin
 inherited Create;
 FServiceParams := ServiceParams;
 //Apontamentos de eventos
 FOnInvalidNfe := DoOnInvalidNfe;
 FOnValidationNfe := DoOnValidationNfe;
end;

destructor TNFEDAOProcess.Destroy;
begin
  if Assigned(FIConnection) then FIConnection := nil;
  inherited Destroy;
end;

class function TNFEDAOProcess.New(const ServiceParams: TModelServiceParams): INFEDAOProcess;
begin
 //Retorna a interface DAO para trabalho ao nível do processo do backend
 Result := self.Create(ServiceParams) as INFEDAOProcess;
end;

procedure TNFEDAOProcess.FillEnvironmentInfo(var Data: TLogData; const Obj: TNFEObject);
begin
 //Preenche "Data" com as informações "default" dos logs
 Data.ThreadId  := Params.Task.ThreadId;
 Data.StartTime := Params.Task.StartTime;
 Data.EndTime   := Params.Task.EndTime;
 if Assigned(Obj) then
  begin
   Obj.ToText(Data.DetailsInfo);
   Data.ChaveNfe := Obj.ChaveNfe;
  end;
end;

procedure TNFEDAOProcess.DoOnCheckerExecute(Sender: TObject;
  const Obj: TNFEObject; var Validated: boolean);
begin
{Método de evento disparado quando uma classe "checker" for executada. Deveria
fazer coisas como gerar logs, mas em discussão com o time Tora decidimos deixar
isso como melhoria futura. Ficará vazio, pelo momento.}
end;

procedure TNFEDAOProcess.DoOnDAOErrorEvent(ErrorInfo: string;
  ErrorSource, Command: string);
var
 Data: TLogData;
begin
 //Implementa o evento "TOnADOErrorEvent" de TNFEADOConnection
  FillEnvironmentInfo(Data, nil);
  Data.Tipo := ltError;
  Data.Text := Format(TDAOErrorMessages.ErrorInfo, [ErrorSource, ErrorInfo]);
  Data.Command := Command;
  Data.ExceptionClass := ErrorSource;
  Data.SourceType := lsTechnicalInfo;
  self.Logs.RegisterLog(Data);
end;

procedure TNFEDAOProcess.DoOnDAOExecCommand(Command: string; Script: TStringList;
  E: Exception);
var
 Data: TLogData;
begin
 //Implementa o evento "OnExecuteCommand" de TNFEADOConnection
  FillEnvironmentInfo(Data, nil);
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
  Logs.RegisterLog(Data);
end;

procedure TNFEDAOProcess.DoOnInvalidNfe(Sender: TObject; const Obj: TNFEObject);
var
 Data: TLogData;
begin
 //Implementa o evento "OnInvalidNfe"
 if not Assigned(Obj) then Exit;
 FillEnvironmentInfo(Data, Obj);
 Data.Text := TDAOStatusNfeError.InvalidNfe;
 Data.Tipo := ltError;
 Data.SourceType := lsBusiness;
 Logs.RegisterLog(Data);
end;

procedure TNFEDAOProcess.DoOnMappingError(Obj: TObject; E: Exception);
var
 Data: TLogData;
begin
//Implementa o evento "OnMappingError" de TNFEObject
 if not Assigned(Obj) then Exit;
 if not (Obj is TNFEObject) then Exit;
 FillEnvironmentInfo(Data, Obj as TNFEObject);
 Data.Tipo := ltError;
 Data.SourceType := lsMappingInfo;
 Data.Text := E.Message;
 if Assigned(E) then Logs.RegisterLog(Data, E)
 else
  Logs.RegisterLog(Data);
end;

procedure TNFEDAOProcess.DoOnUnknownData(Sender: TObject; const Obj: TNFEObject;
  const UnknownData: TProcessDataInfo; const RefProduto: string);
var
 Data: TLogData;
 IMessageBuilder: IProcessDataInfoBuilder;
begin
//Implementa o evento "OnUnknownData"
 if not Assigned(Obj) then Exit;
 FillEnvironmentInfo(Data, Obj);
 Data.Tipo := ltInfo;
 Data.SourceType := lsBusiness;
 IMessageBuilder := TProcessDataInfoBuilder.New;
 Data.Text := IMessageBuilder.MessageInfo(Obj, UnknownData, RefProduto);
 Logs.RegisterLog(Data);
end;

procedure TNFEDAOProcess.DoOnValidationNfe(Sender: TObject;
  const Obj: TNFEObject);
var
 Data: TLogData;
begin
 //Implementa o evento "OnValidationNfe"
 if not Assigned(Obj) then Exit;
 FillEnvironmentInfo(Data, Obj);
 //validação do "status" ou tipo da NFe
 Data.Tipo := ltError;
 case Obj.Status of
   snCompleted:
    begin
     Data.Tipo := ltInfo;
     Data.Text := TDAOStatusValidationNFe.Completed;
     Data.SourceType := lsBusiness;
    end;
   snSummarized:
    begin
     Data.Tipo := ltInfo;
     Data.Text := TDAOStatusValidationNFe.Summarized;
     Data.SourceType := lsBusiness;
    end;
   snIndetermined: self.OnInvalidNfe(self, Obj);
 end;
 //Registra o resultado da validação
 Logs.RegisterLog(Data);

 //validação do resultado do mapeamento O.R.
 case Obj.MapperStatus of
   msNormalMapping:
    begin
     Data.Tipo := ltInfo;
     Data.Text := TDAOMappingValidationNFe.Normal;
     Data.SourceType := lsMappingInfo;
    end;
   msBrokenXmlMapping:
    begin
     Data.Tipo := ltError;
     Data.Text := TDAOMappingValidationNFe.InvalidSchema;
     Data.SourceType := lsMappingInfo;
    end;
   msIncompleteDbMapping:
    begin
     Data.Tipo := ltError;
     Data.Text := TDAOMappingValidationNFe.InvalidDbMapping;
     Data.SourceType := lsMappingInfo;
    end;
 end;
 //Registra o resultado da validação do mapeamento
 Logs.RegisterLog(Data);
end;

procedure TNFEDAOProcess.DoValidateNFEObj(var Obj: TNFEObject);
var
 ErrorMsg: string;
 valdest, valemit, valfabr: boolean;
begin
 {Valida a nfe passada do param "Obj". Esse método deve sempre***
  criar um Exception no caso de falha da validação específica}
 try
   if not Assigned(Obj) then raise EInvalidNFeObject.Create;
   //verifica se o xml existe (não está vazio)
   if Checkers[ceOnExecute].XmlCheckers(Obj.XmlData).XmlIsEmpty then raise EEmptyXML.Create;
   //verifica se o xml é válido: parser geral do xml
   if not Checkers[ceOnExecute].XmlCheckers(Obj.XmlData).IsValidXML(ErrorMsg) then
      raise EInvalidXML.Create(ErrorMsg);
   //só prossegue se o mapeamento foi "normal" e a NFe é "completa" (não sumarizada)
   if (Obj.MapperStatus = msNormalMapping) and (Obj.Status = snCompleted) then
    begin
     //Existem cnpj's dos envolvidos na nfe...
     if not Obj.HasCompaniesInfo then raise EMissingCompaniesInfo.Create;
     //Envolvidos na NFe (destinatário, emitente e fabricante) estão cadastrados no SIT..
     Checkers[ceFullEvents]
          .Companies
            .DestinatarioExists(Obj, valdest)
            .EmitenteExists(Obj, valemit)
            .FabricanteExists(Obj, valfabr);
     if (not valdest) or (not valemit) or (not valfabr) then raise ESitUnknownCompanies.Create;
    end;
 except
  raise;
 end;
end;

function TNFEDAOProcess.GetCheckers(const Events: TCheckerEvents): IFactoryCheckers;
begin
 {Retorna uma interface para acesso a diversas classes do tipo "checkers". Este
 método de leitura da array property "Checkers" retorna IFactoryCheckers com
 diferentes eventos disponíveis, conforme valor recebido no param "Events" }
 case Events of
  ceFullEvents: Result := TDAOFactoryCheckers.New(Params, DoOnCheckerExecute, DoOnUnknownData);
  ceOnExecute:  Result := TDAOFactoryCheckers.New(DoOnCheckerExecute);
  ceNone:       Result := TDAOFactoryCheckers.New;
 end;
end;

function TNFEDAOProcess.GetCommandBuilder: ICommandBuilder;
begin
 //Método de leitura da propert "CommandBuilder"
 Result := TCommandBuilder.New(Params);
end;

function TNFEDAOProcess.GetIConnectionIntf: IAbstractConnection;
begin
 //Método de leitura da property "Connection"
 if not Assigned(FIConnection) then
    FIConnection := TConnectionFactory.New(Params.Data, Params.Timeouts, DoOnDAOErrorEvent, DoOnDAOExecCommand);

 if not Assigned(FIConnection) then raise EInvalidConnectionObject.Create(TDAOErrorMessages.InvalidConnection);
 Result := FIConnection;
end;

function TNFEDAOProcess.GetLogInterface: INFEDAOLogs;
begin
 //Retorna a interface DAO para escrita de logs
 Result := TNFEDAOLogs.New(self.FIConnection, Params.Data, Params.Timeouts);
end;

procedure TNFEDAOProcess.CreateQueue(var List: TObjectList);
var
 Ds: TDataset;
 Obj: TNFEObject;
begin
{Cria uma fila de objetos TNFEObject que ainda não foram processados. Esta
fila será usada para os demais passos de processamento}
 if not Assigned(List) then Exit;
 try
   List.Clear;
   //Busca no banco do SIT os registros ainda não processados e sem pendências
   Ds := Connection.CreateDataset(CommandBuilder.NFes.FilaNotasFiscais);
   if Assigned(Ds) and (Ds.Active) then
   begin
    Ds.First;
    while not Ds.Eof do
      begin
       //cria um objeto TNFEObject e o adiciona à fila
       Obj := TNFEObject.Create(Params, DoOnMappingError);
       with Ds.Fields do
        begin
         Obj.Sequencial := FieldByName(TNFEIFields.ID).Value;
         Obj.ChaveNfe   := FieldByName(TNFEIFields.Chave).Value;
         try
          Obj.XmlData   := FieldByName(TNFEIFields.Xml).AsString;

         except
          on E: ENFeObjectXmlMapping do
           begin
            //Ds.Next;
           end;
          on E: ENFeObjectDbMapping do
           begin
            //Ds.Next;
           end;
          on E: EAccessViolation do
           begin
           // Ds.Next;
           end;
          on E: Exception do
           begin
            //Ds.Next;
           end;
         end;
        end;
        List.Add(Obj); //sempre adiciona o obj à fila. Mesmo em caso de erros.
        Ds.Next;
      end;
    FreeAndNil(Ds);
   end;
 except
   if Assigned(Ds) then FreeAndNil(Ds);
   raise;
 end;
end;

procedure TNFEDAOProcess.ProcessNFEObj(var Obj: TNFEObject);
var
 Command: string;
 aScript: TStringList;
 Chars: TFormatedChars;
begin
  {Processa um objeto TNFEObject a nível da camada dao. Exacuta validações e
  termina com a execução de script de escrita de dados no database do SIT}
  Chars := TSQLUtils.GenerateChars(Obj);
  try
  //Validações iniciais:
   //Resultado do mapeamento O.R.: schema XML não validado pelo parser impede o mapeamento.
   if Obj.MapperStatus = msBrokenXmlMapping then raise EInvalidXML.Create;
   //Resultado do mapeamento O.R.: mapeamento incompleto de dados vindos do banco de dados do SIT.
   if Obj.MapperStatus = msIncompleteDbMapping then raise EIncompletedMapping.Create;
   //Erro de acesso à memória ou genérico durante o mapeamento O.R.
   if Obj.MapperStatus = msFatalFailureOnMapping then raise EReadMemoryProcess.Create;

   //tipo de documento não é o esperado (apenas NF-e)
   if Obj.DocummentType <> dtNFe then raise EInvalidDoc.Create;
   //domain da empresa Tora responsável pela NFe não foi encontrado
   if Obj.ToraBranch.ToraBranch = EmptyStr then raise EMissingToraBranchInfo.Create;
   //Demais validações ligadas ao XML e SIT.
   DoValidateNFEObj(Obj);
  //trata apenas alguns tipos de exceptions. As demais são tratadas na camada model
  except
   on E: EInvalidDoc do //é um dtCte ou dtUnknown
    begin
     Command := CommandBuilder.NFes.NfeProcessada(Chars.ProcessedMark, Chars.StatusNFe, Obj.Sequencial);
     Connection.ExecuteCommand(Command); //marca TNFEObject como processado e abandona o método
     raise;
    end;
   on E: EMissingToraBranchInfo do //não possui informação do "branch" do grupo Tora
    begin
     Command := CommandBuilder.NFes.NfeProcessada(Chars.ProcessedMark, Chars.StatusNFe, Obj.Sequencial);
     Connection.ExecuteCommand(Command); //marca TNFEObject como processado e abandona o método
     raise;
    end;
   on E: EMappingError do
    begin
     Command := CommandBuilder.NFes.NfeProcessada(Chars.ProcessedMark, Chars.StatusNFe, Obj.Sequencial);
     Connection.ExecuteCommand(Command); //marca TNFEObject como processado e abandona o método
     raise;
    end;
   on E: EReadMemoryProcess do
    begin
     Command := CommandBuilder.NFes.NfePendente(Chars.ProcessedMark, E.PendencieId, Chars.StatusNFe, Obj.Sequencial);
     Connection.ExecuteCommand(Command); //marca TNFEObject como processado e abandona o método
     raise;
    end;
   //todos os outros tipos de exceptions
   on E: Exception do raise;  //raise para camada model tratar e gerar pendências
  end;
  //se chegou aqui, não** há pendência que impeça o processamento.
  aScript := TStringList.Create;
  try
     //Executa tarefas distintas conforme o "status" de cada TNFEObject
     case Obj.Status of
      snCompleted: //NFe completa
        begin
         //se chegou aqui, insere no script eventuais novos produtos
         Checkers[ceFullEvents].Products.ProductsExist(Obj, aScript);
         //verifica se a NFe já está cadastrada no SIT
         Checkers[ceFullEvents].NFes.NotaFiscalExiste(Obj, aScript);
         //Finalmente, gera o comando para marcar que a NFe foi processada
         Command := CommandBuilder.NFes.NfeProcessada(Chars.ProcessedMark, Chars.StatusNFe, Obj.Sequencial)
        end;
      snSummarized, snIndetermined: //NFe sumarizada ou com "status" indeterminado
        begin
         Command := CommandBuilder.NFes.NfeProcessada(Chars.ProcessedMark, Chars.StatusNFe, Obj.Sequencial);
         if Assigned(OnValidationNfe) then  OnValidationNfe(self, Obj);
        end;
     end;
     //Adiciona o último comando ao script e...
     if Command <> EmptyStr then aScript.Append(Command);
     try
      //Finalmente, executa todo o script de comandos sql
      Connection.ExecuteScript(aScript);
     except
       on E: EOleException do //retorna para Model uma exception EEndedFatalFailure
        begin
         raise EEndedFatalFailure.Create;
        end;
     end;

  finally
   if Assigned(aScript) then FreeAndNil(aScript);
  end;
end;

end.
