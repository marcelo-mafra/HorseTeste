unit nfe.localservice.dao.nfeobj.xmlmapper;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, System.Variants,
  System.Win.ComObj, Xml.XmlDoc, Xml.XMLIntf, Xml.XmlDom,
  //nfe units
  nfe.localservice.dao.nfeobj.interfaces,
  nfe.localservice.dao.nfeobj.xmlmapper.consts,
  nfe.localservice.dao.nfeobj.xmlmapper.header,
  nfe.localservice.dao.nfeobj.xmlmapper.veiculo, 
  nfe.localservice.dao.nfeobj.xmlmapper.destinatario, 
  nfe.localservice.dao.nfeobj.xmlmapper.emitente, 
  nfe.localservice.dao.nfeobj.xmlmapper.produtos, 
  nfe.localservice.dao.nfeobj.xmlmapper.taxes, 
  nfe.localservice.dao.nfeobj.xmlmapper.transportadora;

type
  //constantes usadas em todo o processamento do mapper xml (TNFEObjectDAOXmlMapper)
  TXmlConsts = class //do not localize!
   const
    OleObj = 'Msxml2.DOMDocument.6.0';
    ErrorMsg = 'Error Code : %s  Mensagem : %s linha : %s Posicao do caractere : %s Pos no xml : %s';
  end;

  //Implementa todo a leitura do xml da nfe e seu mapeamento para alguns objetos pascal
  TNFEObjectDAOXmlMapper = class(TInterfacedObject, INFEDAOXmlMapper, IDAODestinatarioXmlMapper,
      IDAOEmitenteXmlMapper, IDAOHeaderXmlMapper, IDAOProdutosXmlMapper, IDAOTaxesXmlMapper,
      IDAOTransportadoraXmlMapper, IDAOVeiculoXmlMapper)

    protected
     constructor Create;

     function IsSummarizedNfe(const XmlData: string): boolean;
     function IsValidXML(const XmlData: string; var ErrorMsg: string): boolean;
     function GetDestinatario: IDAODestinatarioXmlMapper;
     function GetEmitente: IDAOEmitenteXmlMapper;
     function GetHeader: IDAOHeaderXmlMapper;
     function GetProdutos: IDAOProdutosXmlMapper;
     function GetTaxes: IDAOTaxesXmlMapper;
     function GetTransportadora: IDAOTransportadoraXmlMapper;
     function GetVeiculo: IDAOVeiculoXmlMapper;

    public
     class function New: INFEDAOXmlMapper;
     destructor Destroy; override;

     property Destinatario: IDAODestinatarioXmlMapper read GetDestinatario implements IDAODestinatarioXmlMapper;
     property Emitente: IDAOEmitenteXmlMapper read GetEmitente implements IDAOEmitenteXmlMapper;
     property Header: IDAOHeaderXmlMapper read GetHeader implements IDAOHeaderXmlMapper;
     property Produtos: IDAOProdutosXmlMapper read GetProdutos implements IDAOProdutosXmlMapper;
     property Taxes: IDAOTaxesXmlMapper read GetTaxes implements IDAOTaxesXmlMapper;
     property Transportadora: IDAOTransportadoraXmlMapper read GetTransportadora implements IDAOTransportadoraXmlMapper;
     property Veiculo: IDAOVeiculoXmlMapper read GetVeiculo implements IDAOVeiculoXmlMapper;
  end;

implementation

{ TNFEObjectDAOXmlMapper }

constructor TNFEObjectDAOXmlMapper.Create;
begin
 inherited Create;
end;

destructor TNFEObjectDAOXmlMapper.Destroy;
begin
  inherited Destroy;
end;

class function TNFEObjectDAOXmlMapper.New: INFEDAOXmlMapper;
begin
 //método factory de TNFEObjectDAOXmlMapper
 Result := self.Create as INFEDAOXmlMapper;
end;

function TNFEObjectDAOXmlMapper.GetDestinatario: IDAODestinatarioXmlMapper;
begin
 Result := TDAODestinatarioXmlMapper.New;
end;

function TNFEObjectDAOXmlMapper.GetEmitente: IDAOEmitenteXmlMapper;
begin
 Result := TDAOEmitenteXmlMapper.New;
end;

function TNFEObjectDAOXmlMapper.GetHeader: IDAOHeaderXmlMapper;
begin
 Result := TDAOHeaderXmlMapper.New;
end;

function TNFEObjectDAOXmlMapper.GetProdutos: IDAOProdutosXmlMapper;
begin
 Result := TDAOProdutosXmlMapper.New;
end;

function TNFEObjectDAOXmlMapper.GetTaxes: IDAOTaxesXmlMapper;
begin
 Result := TDAOTaxesXmlMapper.New;
end;

function TNFEObjectDAOXmlMapper.GetTransportadora: IDAOTransportadoraXmlMapper;
begin
 Result := TDAOTransportadoraXmlMapper.New;
end;

function TNFEObjectDAOXmlMapper.GetVeiculo: IDAOVeiculoXmlMapper;
begin
 Result := TDAOVeiculoXmlMapper.New;
end;

function TNFEObjectDAOXmlMapper.IsSummarizedNfe(const XmlData: string): boolean;
var
  Doc: IXMLDocument;
  InfNode, DestNode, DestAttrNode, EmitNode, EmitAttrNode, RootNode: IXMLNode;
  EmitCNPJ, DestCNPJ: olevariant;
begin
  {Retorna se o conteúdo xml recebido em XmlData se refere a uma NFe "sumarizada".
  Por info recebida da Tora, o backend deve trabalhar com NFes "completas" ou
  "sumarizadas". O comportamento definido para cada um desses casos é diferente.}
  Doc := LoadXMLData(XmlData);
  RootNode := Doc.DocumentElement.ChildNodes.FindNode(TXmlTags.Root);
  if RootNode <> nil then InfNode := RootNode.ChildNodes.FindNode(TXmlTags.InfoNfe);
  if InfNode <> nil then EmitNode := InfNode.ChildNodes.FindNode(TXmlTags.Emit);
  if EmitNode <> nil then EmitAttrNode := EmitNode.ChildNodes.FindNode(TXmlTags.Cnpj) ;
  if EmitAttrNode <> nil then EmitCNPJ := EmitAttrNode.NodeValue;

  if InfNode <> nil then DestNode := InfNode.ChildNodes.FindNode(TXmlTags.Dest);
  if DestNode <> nil then DestAttrNode := DestNode.ChildNodes.FindNode(TXmlTags.Cnpj);
  if DestAttrNode <> nil then DestCNPJ := DestAttrNode.NodeValue;

  //será considerada "sumarizada" se qualquer dessas condições lógicas retornar "True"
  Result := (RootNode = nil) or (InfNode = nil) or (EmitNode = nil)
         or (EmitCNPJ = unassigned) or (DestNode = nil) or (DestCNPJ = unassigned);
end;

function TNFEObjectDAOXmlMapper.IsValidXML(const XmlData: string; var ErrorMsg: string): boolean;
var
  XmlDoc : OleVariant;
begin
  {Verifica se o conteúdo xml "XmlData" possui estrutura válida (parser xml simples)}
  XmlDoc := CreateOleObject(TXmlConsts.OleObj);
  try
    XmlDoc.Async := False;
    XmlDoc.validateOnParse := True;
    Result := (XmlDoc.LoadXML(XmlData)) and (XmlDoc.parseError.errorCode = 0);
    if not Result then ErrorMsg := Format(TXmlConsts.ErrorMsg, [XmlDoc.parseError.errorCode,
        XmlDoc.parseError.reason, XmlDoc.parseError.Line, XmlDoc.parseError.linepos,
        XmlDoc.parseError.filepos]);
  finally
    XmlDoc := Unassigned;
  end;
end;
end.




