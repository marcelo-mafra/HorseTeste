unit nfe.localservice.dao.nfeobj.interfaces;

interface

uses
 System.Classes,
 //nfe units
 nfe.localservice.model.produto.interfaces,
 nfe.localservice.model.nfeobj.types;

type
  //Define métodos de leitura de dados da NFe existentes na base de dados do SIT
  INFEDAODbMapper = interface
    ['{85F2BC06-BA3F-4C11-993E-C93A6F1C8611}']
    procedure ReadDestinatarioInfo(const Info: TToraBranchsInfo; var DestInfo: TDestinatarioInfo);
    procedure ReadEmitenteteInfo(const Info: TToraBranchsInfo; var EmitInfo: TEmitenteInfo);
    procedure ReadFabricanteInfo(var FabrInfo: TFabricanteInfo);
    procedure ReadProdutosInfo(const Info: TToraBranchsInfo; List: IProdutosList; Fabricante: TFabricanteInfo);
    procedure ReadToraBranchsInfo(var Info: TDataInfo);
  end;

  IDAOHeaderXmlMapper = interface
    ['{D07034D2-4705-4AC3-AB4E-5E0A287D0799}']
     procedure CreateHeaderInfo(const XmlData: string; var Header: THeaderInfo);
  end;

  IDAODestinatarioXmlMapper = interface
    ['{D34A2163-74EA-4C8B-A728-46ABA5ECA6EE}']
     procedure CreateDestinatarioInfo(const XmlData: string; var DestInfo: TDestinatarioInfo);
  end;

  IDAOEmitenteXmlMapper = interface
    ['{3A4AC586-C0EE-4C2F-9B94-241C487BBC96}']
     procedure CreateEmitenteInfo(const XmlData: string; var EmitInfo: TEmitenteInfo;
        var FabrInfo: TFabricanteInfo);
  end;

  IDAOProdutosXmlMapper = interface
    ['{CE48B961-976C-4360-98B1-951472B6468B}']
     procedure CreateProdutosInfo(const XmlData: string; var FabrInfo: TFabricanteInfo;
        var List: IProdutosList; const VeicInfo: TVeiculoInfo);    
  end;

  IDAOTaxesXmlMapper = interface
    ['{B5B00052-17FD-40AD-8423-9C4C1DB60ED1}']
     procedure CreateTaxesInfo(const XmlData: string; var Taxes: TTaxesInfo);
  end;

  IDAOTransportadoraXmlMapper = interface
    ['{AC12DC4B-9B91-4816-8715-8E2946A197EC}']
     procedure CreateTransportadoraInfo(const XmlData: string; var TransInfo: TTransportadoraInfo;
        var EmitInfo: TEmitenteInfo);
  end;

  IDAOVeiculoXmlMapper = interface
    ['{2A61D950-5D33-42AC-AF8E-D23EB8DB9CFD}']
     procedure CreateVeiculoInfo(const XmlData: string; var VeicInfo: TVeiculoInfo);
  end;

  //Define métodos de leitura de dados da NFe existentes no conteúdo XML da nfe
  INFEDAOXmlMapper = interface
    ['{85F2BC06-BA3F-4C11-993E-C93A6F1C8611}']
     function IsSummarizedNfe(const XmlData: string): boolean;
     function IsValidXML(const XmlData: string; var ErrorMsg: string): boolean;
     function GetDestinatario: IDAODestinatarioXmlMapper;
     function GetEmitente: IDAOEmitenteXmlMapper;
     function GetHeader: IDAOHeaderXmlMapper;
     function GetProdutos: IDAOProdutosXmlMapper;
     function GetTaxes: IDAOTaxesXmlMapper;
     function GetTransportadora: IDAOTransportadoraXmlMapper;
     function GetVeiculo: IDAOVeiculoXmlMapper;

     property Destinatario: IDAODestinatarioXmlMapper read GetDestinatario;
     property Emitente: IDAOEmitenteXmlMapper read GetEmitente;
     property Header: IDAOHeaderXmlMapper read GetHeader;
     property Produtos: IDAOProdutosXmlMapper read GetProdutos;
     property Taxes: IDAOTaxesXmlMapper read GetTaxes;
     property Transportadora: IDAOTransportadoraXmlMapper read GetTransportadora;
     property Veiculo: IDAOVeiculoXmlMapper read GetVeiculo;
  end;   



implementation

end.
