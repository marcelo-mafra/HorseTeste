unit nfe.localservice.dao.checkers.nfes;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, System.StrUtils, System.Variants,
  //nfe units
  nfe.localservice.model.params.types,
  nfe.localservice.model.process.types,
  nfe.localservice.model.nfeobj,
  nfe.localservice.dao.process.events,
  nfe.localservice.dao.sqlconsts,
  nfe.localservice.dao.checkers.interfaces,
  nfe.localservice.dao.checkers.dbobj,
  nfe.localservice.model.produto.interfaces,
  nfe.localservice.dao.formatters.interfaces,
  nfe.localservice.dao.formatters.types,
  nfe.localservice.model.nfeobj.interfaces;

type
  {Classe "checker" que implementa as validações de notas fiscais previamente
   existentes no sit}
  TDAOCheckNFes = class sealed (TDAOCustomDBChecker, IDAOCheckNFes)
    private
      dtEmivalue, dtSaiValue, IcmsValue, IcmsAliq, ToraBranch: string;

      procedure CreateCommands(iNFe: INFeDocumment; var Script: TStringList);
      procedure FormatVariables(const Obj: TNFEObject); inline;

    protected
      constructor Create(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
      function NotaFiscalExiste(var Obj: TNFEObject; var Script: TStringList): IDAOCheckNFes;

    public
      destructor Destroy; override;
      class function New(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): IDAOCheckNFes;

      //TDAOCustomDBChecker
      property CommandBuilder;
      property Connection;
      //TDAOCustomChecker
      property Formatter;
      property Logs;
      property Params;
      //eventos
      property OnCheckerExecute;      
      property OnUnknownData;
 end;

implementation

{ TDAOCheckNFes }

constructor TDAOCheckNFes.Create(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
begin
 inherited Create(ServiceParams, OnCheckerExecute, OnUnknownData);
end;

destructor TDAOCheckNFes.Destroy;
begin
 inherited Destroy;
end;

class function TDAOCheckNFes.New(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): IDAOCheckNFes;
begin
 Result := TDAOCheckNFes.Create(ServiceParams, OnCheckerExecute, OnUnknownData);
end;

procedure TDAOCheckNFes.FormatVariables(const Obj: TNFEObject);
begin
 //variáveis globais formatadas usadas nessa classe
 ToraBranch := Obj.Data.ToraBranch.ToraBranch;
 dtEmivalue := Formatter.DateTime.SQLValue(Obj.Header.dtEmissao, dtDate);
 dtSaiValue := Formatter.DateTime.SQLValue(Obj.Header.dtSaida, dtDate);

 //valor do icms
 IcmsValue := TSQLChars.NullChar;
 if Obj.Taxes.ICMS <> null then IcmsValue := Formatter.Numbers.AsIcms(VarToStr(Obj.Taxes.ICMS).ToDouble).ToString;

 //valor e alíquota do icms
 IcmsAliq  := TSQLChars.NullChar;
 if Obj.Taxes.ICMSAliq <> null then
   IcmsAliq := Formatter.Numbers.AsIcmsAliq(Obj.Taxes.ICMSAliq).ToString;
end;

procedure TDAOCheckNFes.CreateCommands(iNfe: INFeDocumment;
  var Script: TStringList);
begin
 //insere o comando "insert" para a nota fiscal em si.
 CommandBuilder.NFes.NotaFiscalInsert(INFe, ToraBranch, Script);
 //insere os comandos "insert" para os itens da nfe
 CommandBuilder.NFes.NotaFiscalItemsInsert(INFe, ToraBranch, Script);
end;

function TDAOCheckNFes.NotaFiscalExiste(var Obj: TNFEObject; var Script: TStringList): IDAOCheckNFes;
var
Validated: boolean;
iNFe: INFeDocumment;
begin
 {Verifica se a NFe está cadastrada na base de dados do SIT. Em caso negativo
 esse método não*** insere a nova NFe, mas apenas gera comandos "insert" e
 os adicionas ao script de comandos SQL recebido }
 Result := self;
 Validated :=  Assigned(Obj) and Assigned(Script);
 if not Validated then Exit;
 FormatVariables(Obj);

 if not HasData(CommandBuilder.NFes.NotaFiscalExiste(ToraBranch, QuotedStr(Obj.ChaveNfe))) then
  begin
   //nfe ainda não cadastrada: adiciona comandos em "Script" e dispara o evento OnUnknownData
   iNFe := Obj as INFeDocumment;
   CreateCommands(iNFe, Script);
   if Assigned(OnUnknownData) then OnUnknownData(self, Obj, diNFe, EmptyStr);
  end;
 if Assigned(OnCheckerExecute) then self.OnCheckerExecute(self, Obj, Validated);
end;
end.
