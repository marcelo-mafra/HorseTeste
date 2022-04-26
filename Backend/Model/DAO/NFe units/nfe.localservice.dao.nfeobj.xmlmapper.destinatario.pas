unit nfe.localservice.dao.nfeobj.xmlmapper.destinatario;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, System.Variants, Xml.XmlDoc,
  Xml.XMLIntf, Xml.XmlDom,
  //nfe units
  nfe.localservice.dao.nfeobj.interfaces,
  nfe.localservice.model.nfeobj.types,
  nfe.localservice.dao.nfeobj.xmlmapper.consts,
  nfe.localservice.dao.nfeobj.xmlmapper.customobj;

type
  //Implementa o mapeamento O.R. de dados do destinat�rio a partir de fonte xml
  TDAODestinatarioXmlMapper = class(TDAOCustomXmlMapper, IDAODestinatarioXmlMapper)
    protected
     constructor Create;
     procedure CreateDestinatarioInfo(const XmlData: string; var DestInfo: TDestinatarioInfo); 

    public
     class function New: IDAODestinatarioXmlMapper;
     destructor Destroy; override;
  end;

implementation

{ TDAODestinatarioXmlMapper }

constructor TDAODestinatarioXmlMapper.Create;
begin
 inherited Create;
end;

destructor TDAODestinatarioXmlMapper.Destroy;
begin
  inherited Destroy;
end;

class function TDAODestinatarioXmlMapper.New: IDAODestinatarioXmlMapper;
begin
 Result := self.Create;
end;

procedure TDAODestinatarioXmlMapper.CreateDestinatarioInfo(
  const XmlData: string; var DestInfo: TDestinatarioInfo);
var
  Doc: IXMLDocument;
  InfNode, EmpNode, AttrNode, EndrNode, RootNode: IXMLNode;
  EmpCNPJ, AttrValue: olevariant;
begin
 {Mapeia os atributos do destinat�rio a partir do conte�do xml em "XmlData"}
  Doc := LoadXMLData(XmlData);
  RootNode := Doc.DocumentElement.ChildNodes.FindNode(TXmlTags.Root);
  if RootNode <> nil then InfNode := RootNode.ChildNodes.FindNode(TXmlTags.InfoNfe);
  if InfNode <> nil then EmpNode := InfNode.ChildNodes.FindNode(TXmlTags.Dest);
  //In�cio da coleta dos dados do destinat�rio
  if EmpNode <> nil then AttrNode := EmpNode.ChildNodes.FindNode(TXmlTags.Cnpj);
  //Destinat�rio: CNPJ
  if AttrNode <> nil then
     begin
      EmpCNPJ := AttrNode.NodeValue;
      DestInfo.Cnpj := VarToStr(EmpCNPJ);
     end;
  //Destinat�rio: Pa�s
  EndrNode := nil;
  AttrNode := nil;
  if EmpNode <> nil then EndrNode := EmpNode.ChildNodes.FindNode(TXmlTags.EndDest) ; //endere�o
  if EndrNode <> nil then AttrNode := EndrNode.ChildNodes.FindNode(TXmlTags.Pais);
  if AttrNode <> nil then
     begin
      AttrValue := AttrNode.NodeValue;
      DestInfo.PaisCod := VarToStr(AttrValue);
     end;
  //Destinat�rio: c�digo do munic�pio
  if EndrNode <> nil then AttrNode := EndrNode.ChildNodes.FindNode(TXmlTags.MunCode);
  if AttrNode <> nil then
     begin
      AttrValue := AttrNode.NodeValue;
      DestInfo.MunCod := AttrValue;
     end;

end;

end.
