unit nfe.localservice.dao.process.pendings;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils,
  //nfe units...
  nfe.localservice.dao.interfaces,
  nfe.localservice.model.nfeobj,
  nfe.localservice.model.process.exceptions,
  nfe.localservice.dao.sqlconsts,
  nfe.localservice.dao.connection.factory, 
  nfe.localservice.model.params.types,
  nfe.localservice.model.nfeobj.types, 
  nfe.localservice.dao.utils,
  nfe.localservice.dao.commands.interfaces, 
  nfe.localservice.dao.commands.builder;

type
  //Abstrai a geração de pendências no processamento de NFes
  TDAOPendencies = class(TInterfacedObject, INFEDAOPendencies)
    private
      FServiceParams: TModelServiceParams;
      function GetCommandBuilder: ICommandBuilder;
      function PendenciesChar(Obj: TNFEObject; E: EValidateNfeObject): TFormatedChars; inline;

    protected
      constructor Create(const ServiceParams: TModelServiceParams);
      function CreatePendencie(var Obj: TNFEObject; E: EValidateNfeObject): INFEDAOPendencies;

    public
      destructor Destroy; override;
      class function New(const ServiceParams: TModelServiceParams): INFEDAOPendencies;

      property CommandBuilder: ICommandBuilder read GetCommandBuilder;
      property Params: TModelServiceParams read FServiceParams;
  end;

implementation

{ TDAOPendencies }

constructor TDAOPendencies.Create(const ServiceParams: TModelServiceParams);
begin
 inherited Create;
 FServiceParams := ServiceParams;
end;

destructor TDAOPendencies.Destroy;
begin
  inherited Destroy;
end;

class function TDAOPendencies.New(const ServiceParams: TModelServiceParams): INFEDAOPendencies;
begin
 Result := self.Create(ServiceParams);
end;

function TDAOPendencies.GetCommandBuilder: ICommandBuilder;
begin
 Result := TCommandBuilder.New(self.Params);
end;

function TDAOPendencies.CreatePendencie(var Obj: TNFEObject;
  E: EValidateNfeObject): INFEDAOPendencies;
var
 ProcessedMark, PendencieMark: string;
 idStatusNFe: integer;
 Chars: TFormatedChars;
begin
 Result := self;
 Chars         :=  PendenciesChar(Obj, E);
 ProcessedMark := Chars.ProcessedMark;
 PendencieMark := Chars.PendencieMark;
 idStatusNFe   := Chars.StatusNFe;
 //com as informações acima coletadas, monta o comando e o executa no database
 TConnectionFactory.New(Params.Data, Params.Timeouts).ExecuteCommand(
    CommandBuilder.NFes.NfePendente(ProcessedMark, PendencieMark, idStatusNFe,
    Obj.Sequencial));
end;

function TDAOPendencies.PendenciesChar(Obj: TNFEObject; E: EValidateNfeObject): TFormatedChars;
begin
 Result := TSQLUtils.GenerateChars(Obj);
 Result.PendencieMark := QuotedStr(E.PendencieId);
end;


end.

