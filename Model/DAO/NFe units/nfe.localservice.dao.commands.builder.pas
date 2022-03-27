unit nfe.localservice.dao.commands.builder;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, Data.DB, System.StrUtils,
  System.Variants,
  //nfe units...
  nfe.localservice.dao.commands.interfaces,
  nfe.localservice.model.produto.interfaces, 
  nfe.localservice.dao.sqlconsts,
  nfe.localservice.dao.connection.interfaces, 
  nfe.localservice.model.params.types,
  nfe.localservice.dao.connection.factory, 
  nfe.localservice.model.nfeobj.types, 
  nfe.localservice.model.nfeobj.interfaces,
  nfe.localservice.dao.formatters.helper,
  nfe.localservice.dao.formatters.interfaces,
  nfe.localservice.dao.formatters.types;

type
  {classe responsável apenas* por gerar comandos sql a partir de objetos ou interfaces
  passadas a ela. Esses objetos e interfaces são "gerados" no processo de
  mapeamento objeto-relacional e não* em TCommandBuilder.}
  TCommandBuilder = class sealed(TInterfacedObject, ICommandBuilder, IDestinatiosCommands,
      IEmitentesCommands, IFabricantesCommands, INFesCommands, IProdutosCommands,
      IPracasCommands, IToraCommands)
    private
      dtEmivalue, dtSaiValue, IcmsValue, IcmsAliq, ToraBranch: string;
      FParams: TModelServiceParams;
      procedure FormatVariables(const iNFe: INFeDocumment); inline;
      function GetConnection: IAbstractConnection;
      function GetIFormatterHelper: IFormatterHelper;
      function GetNewIdProduct: string;

    protected
      constructor Create(const Params: TModelServiceParams);
      //ICommandBuilder commands
      function Destinatarios: IDestinatiosCommands;
      function Emitentes: IEmitentesCommands;
      function Fabricantes: IFabricantesCommands;
      function NFes: INFesCommands;
      function Produtos: IProdutosCommands;
      function Pracas: IPracasCommands;
      function Tora: IToraCommands;

      //IDestinatiosCommands
      function DestinatarioExists(const ToraBranch, Cnpj: string): TCommand;
      function DestinatarioInfo(const ToraBranch, Cnpj: string): TCommand;
      //IEmitentesCommands
      function EmitenteExists(const ToraBranch, Cnpj: string): TCommand;
      function EmitenteInfo(const ToraBranch, cnpj: string): TCommand;
      //IFabricantesCommands
      function FabricanteExists(const Cnpj: string): TCommand;
      function FabricanteInfo(const cnpj: string): TCommand;
      //INFeCommands
      function FilaNotasFiscais: TCommand;
      function NfePendente(const ProcessedMark, PendencieMark: string; const Status: integer;
          const Sequencial: double): TCommand;
      function NfeProcessada(const ProcessedMark: string; const Status: integer;
          const Sequencial: double): TCommand;
      function NotaFiscalExiste(const ToraBranch, ChaveNFe: string): TCommand;
      procedure NotaFiscalInsert(iNFe: INFeDocumment; const ToraBranch: string; var Script: TStringList);
      procedure NotaFiscalItemsInsert(iNFe: INFeDocumment; const ToraBranch: string; var Script: TStringList);
      //IProdutosCommands
      function ProductExists(const RefFabricante: string; codfab: string): TCommand; overload;
      function ProductExists(IProd: IProdutoNfe): TCommand; overload;
      procedure ProductInsert(var IProd: IProdutoNfe; Fabricante: TFabricanteInfo; var Script: TStringList);
      //IPracasCommands
      function MunicipioExiste(const codmun: string): TCommand;
      //IToraCommands
      function ToraBranchsInfo(const CnpjShort: string): TCommand;

    public
      destructor Destroy; override;
      class function New(const Params: TModelServiceParams): ICommandBuilder;
      property Connection: IAbstractConnection read GetConnection ;
      property Formatter: IFormatterHelper read GetIFormatterHelper;
      property Params: TModelServiceParams read FParams;
  end;

implementation

{ TCommandBuilder }

constructor TCommandBuilder.Create(const Params: TModelServiceParams);
begin
 inherited Create;
 FParams := Params;
end;

destructor TCommandBuilder.Destroy;
begin
  inherited Destroy;
end;

class function TCommandBuilder.New(const Params: TModelServiceParams): ICommandBuilder;
begin
 Result := self.Create(Params);
end;

function TCommandBuilder.Destinatarios: IDestinatiosCommands;
begin
 Result := self as IDestinatiosCommands;
end;

function TCommandBuilder.DestinatarioExists(const ToraBranch, Cnpj: string): TCommand;
begin
 Result := Format(TSQLNFEI.DestExiste, [ToraBranch, ToraBranch, Cnpj]);
end;

function TCommandBuilder.DestinatarioInfo(const ToraBranch,
  Cnpj: string): TCommand;
begin
 Result := Format(TSQLNFEI.DestInfo, [ToraBranch, Cnpj]);
end;

function TCommandBuilder.EmitenteExists(const ToraBranch,
  Cnpj: string): TCommand;
begin
 Result := Format(TSQLNFEI.EmitExiste, [ToraBranch, ToraBranch, Cnpj]);
end;

function TCommandBuilder.Emitentes: IEmitentesCommands;
begin
 Result := self as IEmitentesCommands;
end;

function TCommandBuilder.EmitenteInfo(const ToraBranch, cnpj: string): TCommand;
begin
 Result := Format(TSQLNFEI.EmitInfo, [ToraBranch, Cnpj]);
end;

function TCommandBuilder.FabricanteExists(const Cnpj: string): TCommand;
begin
 Result := Format(TSQLNFEI.FabrExiste, [Cnpj]);
end;

function TCommandBuilder.FabricanteInfo(const cnpj: string): TCommand;
begin
 Result := Format(TSQLNFEI.FabrInfo, [cnpj]);
end;

function TCommandBuilder.Fabricantes: IFabricantesCommands;
begin
 Result := self as IFabricantesCommands;
end;

function TCommandBuilder.FilaNotasFiscais: TCommand;
begin
 Result := TSQLNFEI.FilaNFEI;
end;

procedure TCommandBuilder.FormatVariables(const iNFe: INFeDocumment);
begin
 //variáveis globais formatadas usadas nessa classe
 ToraBranch := iNFe.ToraBranch.ToraBranch;
 dtEmivalue := Formatter.DateTime.SQLValue(iNFe.Header.dtEmissao, dtDate);
 dtSaiValue := Formatter.DateTime.SQLValue(iNFe.Header.dtSaida, dtDate);

 //valor do icms
 IcmsValue := TSQLChars.NullChar;
 if iNFe.Taxes.ICMS <> null then
   IcmsValue := Formatter.Numbers.AsIcms(VarToStr(iNFe.Taxes.ICMS).ToDouble).ToString;
 //Alíquota do icms
 IcmsAliq  := TSQLChars.NullChar;
 if iNFe.Taxes.ICMSAliq <> null then
   IcmsAliq := Formatter.Numbers.AsIcmsAliq(iNFe.Taxes.ICMSAliq).ToString;
end;

function TCommandBuilder.NfePendente(const ProcessedMark, PendencieMark: string;
  const Status: integer; const Sequencial: double): TCommand;
var
 SeqValue: string;
begin
 SeqValue := FloatToStrF(Sequencial, ffFixed, 15,0); //conversão pedida pelo time da Tora
 Result := Format(TSQLNFEI.NfeiPendente, [ProcessedMark, Status, PendencieMark, SeqValue]);
end;

function TCommandBuilder.NfeProcessada(const ProcessedMark: string; const Status: integer;
  const Sequencial: double): TCommand;
var
 SeqValue: string;
begin
 SeqValue := FloatToStrF(Sequencial, ffFixed, 15,0); //conversão pedida pelo time da Tora
 Result := Format(TSQLNFEI.NfeiProcessada, [ProcessedMark, Status, SeqValue]);
end;

function TCommandBuilder.NFes: INFesCommands;
begin
 Result := self as INFesCommands;
end;

function TCommandBuilder.NotaFiscalExiste(const ToraBranch,
  ChaveNFe: string): TCommand;
begin
 Result :=  Format(TSQLNFEI.NFeExiste, [ToraBranch ,ChaveNFe]);
end;

procedure TCommandBuilder.NotaFiscalInsert(iNFe: INFeDocumment;
  const ToraBranch: string; var Script: TStringList);
var
 Command: string;
begin
 FormatVariables(iNFe);
 Command := Format(TSQLNFEI.NFeInsert,
      [ToraBranch,
      QuotedStr(iNFe.Header.ChaveNfe), dtEmivalue, dtSaiValue, QuotedStr(TNFeDefValues.NewNFEObs),
      QuotedStr(iNFe.Header.serie), iNFe.Veiculo.qtVol, iNFe.Veiculo.PesoLq, iNFe.Veiculo.PesoBr,
      QuotedStr(IntToStr(iNFe.Taxes.CFOP)), iNFe.Taxes.vBC, IcmsValue, QuotedStr(iNFe.Header.numNFSerie), dtSaiValue, IcmsAliq,
      iNFe.Emitente.Filcod, iNFe.Emitente.Orgcod, iNFe.Emitente.Pcacod, iNFe.Destinatario.Filcod,
      iNFe.Destinatario.Orgcod, iNFe.Destinatario.Pcacod, iNFe.Transportadora.InfAdic, iNFe.Taxes.vNF],
      Formatter.Settings.FormatSqlVar);
 //adiciona o comando "insert" ao script
 Command := ReplaceStr(Command, TSQLChars.ThousandSep, EmptyStr);
 Script.Append(Command);
end;

procedure TCommandBuilder.NotaFiscalItemsInsert(iNFe: INFeDocumment;
  const ToraBranch: string; var Script: TStringList);
var
Command: string;
ValorUnit, TotalItem: double;
I: integer;
IProd: IProdutoNfe;
begin
 {Adiciona novos comandos "insert" para cada produto na NFE.}
 if not Assigned(iNFe) then exit;
 FormatVariables(iNFe);

 //loop nos itens da nfe
 for I := 0 to Pred(iNFe.Produtos.Total) do
  begin
   IProd := iNFe.Produtos.Produto[I];
   if not Assigned(IProd) then Continue;
   if (IProd.ProdInfo.codprod = unassigned) or (IProd.ProdInfo.codprod = null) then Continue;

   //valor unitário
   ValorUnit := IProd.ValorUnit;
   Formatter.Numbers.AsDouble(ValorUnit, nf16_6);
   //total do item
   TotalItem := IProd.TotalItem;
   Formatter.Numbers.AsDouble(TotalItem, nf10_2);
   //monta o comando insert
   Command := Format(TSQLNFEI.ItemNFeInsert,
      [ToraBranch, iNFe.Emitente.Filcod, iNFe.Emitente.Orgcod, iNFe.Emitente.Pcacod,
      QuotedStr(iNFe.Header.numNFSerie), IProd.UnidValue, ValorUnit.ToString,
      TotalItem.ToString, IcmsValue, iNFe.Taxes.vBC, IProd.PesoLiq, IProd.PesoBruto,
      IProd.Quantidade, IProd.ProdIndex, IProd.ProdInfo.locprod,
      QuotedStr(IProd.ProdInfo.codprod)],
      Formatter.Settings.FormatSqlVar);

   //adiciona o comando "insert" nos itens da NF ao script e dispara o evento OnUnknownData
   Script.Append(ReplaceStr(Command, TSQLChars.ThousandSep, EmptyStr));
  end;
 //Gera o comando "insert" em TRANSIT_TIMRA e o adiciona ao script
 Command := Format(TSQLNFEI.TransitTimeInsert,
      [ToraBranch, iNFe.Emitente.Filcod, iNFe.Emitente.Orgcod, iNFe.Emitente.Pcacod,
      QuotedStr(iNFe.Header.numNFSerie), dtEmivalue],
      Formatter.Settings.FormatSqlVar);

 Script.Append(ReplaceStr(Command, TSQLChars.ThousandSep, EmptyStr));
end;

function TCommandBuilder.GetConnection: IAbstractConnection;
begin
 Result := TConnectionFactory.New(Params.Data, Params.Timeouts);
end;

function TCommandBuilder.GetIFormatterHelper: IFormatterHelper;
begin
 Result := TFormatterHelper.New;
end;

function TCommandBuilder.GetNewIdProduct: string;
var
 Ds: TDataset;
begin
 Result := EmptyStr;
 Ds := Connection.CreateDataset(TSQLNFEI.ProdNewId);
 if Assigned(Ds) and (Ds.Active) then Result := Ds.Fields.Fields[0].Value;
end;

function TCommandBuilder.MunicipioExiste(const codmun: string): TCommand;
begin
 Result := Format(TSQLNFEI.MunicipioExiste, [codmun]);
end;

function TCommandBuilder.Pracas: IPracasCommands;
begin
 Result := self as IPracasCommands;
end;

function TCommandBuilder.ProductExists(IProd: IProdutoNfe): TCommand;
begin
 Result := Format(TSQLNFEI.ProdExiste, [QuotedStr(IProd.RefFabricante), QUotedStr(IProd.Fabricante.CodFab)]);
end;

function TCommandBuilder.ProductExists(const RefFabricante: string; codfab: string): TCommand;
begin
 Result := Format(TSQLNFEI.ProdExiste, [RefFabricante, CodFab]);
end;

procedure TCommandBuilder.ProductInsert(var IProd: IProdutoNfe;
 Fabricante: TFabricanteInfo; var Script: TStringList);
var
Command, NewId: string;
ProdInfo: TSitProdutoInfo;
begin
 if not (Assigned(IProd)) or not (Assigned(Script)) then Exit;
 NewId := GetNewIdProduct;
 Command := Format(TSQLNFEI.ProdInsert, [QuotedStr(NewId), QuotedStr(IProd.RefFabricante),
                       QuotedStr(IProd.NomeProd), QuotedStr(TNFeDefValues.ProdTipo),
                       QuotedStr(IProd.NCM), QuotedStr(Fabricante.LocFab),
                       QuotedStr(Fabricante.CodFab)]);
 Script.Append(Command);
 ProdInfo := IProd.ProdInfo;
 Prodinfo.codprod := NewId;
 IProd.ProdInfo := ProdInfo;
end;

function TCommandBuilder.Produtos: IProdutosCommands;
begin
 Result := self as IProdutosCommands;
end;

function TCommandBuilder.Tora: IToraCommands;
begin
 Result := self as IToraCommands;
end;

function TCommandBuilder.ToraBranchsInfo(const CnpjShort: string): TCommand;
begin
 Result := Format(TSQLNFEI.EmpresasTora, [CnpjShort]);
end;

end.
