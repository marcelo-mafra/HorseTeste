unit nfe.localservice.dao.commands.interfaces;

interface

uses
  Winapi.Windows, System.Classes,
  //nfe units..
  nfe.localservice.model.produto.interfaces, 
  nfe.localservice.model.nfeobj.types, 
  nfe.localservice.model.nfeobj.interfaces;

type
  TCommand = string;

  IDestinatiosCommands = interface;
  IEmitentesCommands   = interface;
  IFabricantesCommands = interface;
  INFesCommands        = interface;
  IProdutosCommands    = interface;
  IPracasCommands      = interface;
  IToraCommands        = interface;

  ICommandBuilder = interface
    ['{D4E0F3BC-8E40-4F90-8712-30F1212AD78C}']
    function Destinatarios: IDestinatiosCommands;
    function Emitentes: IEmitentesCommands;
    function Fabricantes: IFabricantesCommands;
    function NFes: INFesCommands;
    function Produtos: IProdutosCommands;
    function Pracas: IPracasCommands;
    function Tora: IToraCommands;
  end;

  IDestinatiosCommands = interface
    ['{E5E7F149-09CE-47AD-A13F-533FB71771C4}']
    function DestinatarioExists(const ToraBranch, Cnpj: string): TCommand;
    function DestinatarioInfo(const ToraBranch, Cnpj: string): TCommand;
  end;

  IEmitentesCommands = interface
    ['{ABC5F839-6228-481B-8EFF-DAFDD4849FB3}']
    function EmitenteExists(const ToraBranch, Cnpj: string): TCommand;
    function EmitenteInfo(const ToraBranch, cnpj: string): TCommand;
  end;

  IFabricantesCommands = interface
    ['{59D6F3B9-DE5B-4A4F-B970-D0A9AFC2DD3B}']
    function FabricanteExists(const Cnpj: string): TCommand;
    function FabricanteInfo(const cnpj: string): TCommand;
  end;

  INFesCommands = interface
    ['{DEF2B428-9154-4A88-9A1B-DD89E89A56BE}']
    function FilaNotasFiscais: TCommand;
    function NfePendente(const ProcessedMark, PendencieMark: string; const Status: integer;
        const Sequencial: double): TCommand;
    function NfeProcessada(const ProcessedMark: string; const Status: integer;
        const Sequencial: double): TCommand;
    function NotaFiscalExiste(const ToraBranch, ChaveNFe: string): TCommand;
    procedure NotaFiscalInsert(iNFe: INFeDocumment; const ToraBranch: string; var Script: TStringList);
    procedure NotaFiscalItemsInsert(iNFe: INFeDocumment; const ToraBranch: string; var Script: TStringList);
  end;

  IProdutosCommands = interface
    ['{1DD1CD72-642B-43F5-9568-3247A671DAA7}']
    function ProductExists(IProd: IProdutoNfe): string; overload;
    function ProductExists(const RefFabricante: string; codfab: string): TCommand; overload;
    procedure ProductInsert(var IProd: IProdutoNfe; Fabricante: TFabricanteInfo; var Script: TStringList);
  end;

  IPracasCommands = interface
    ['{D0023B08-B957-4F13-BC54-AEF2FB8A3C5A}']
    function MunicipioExiste(const codmun: string): TCommand;
  end;

  IToraCommands = interface
    ['{501383F5-BEDB-4563-90AE-07189BB8BFE9}']
    function ToraBranchsInfo(const CnpjShort: string): TCommand;
  end;

implementation

end.
