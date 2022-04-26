unit nfe.localservice.dao.nfeobj.xmlmapper.emitente;

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
  //Implementa o mapeamento O.R. de dados do emitente a partir de fonte xml
  TDAOEmitenteXmlMapper = class(TDAOCustomXmlMapper, IDAOEmitenteXmlMapper)
    protected
     constructor Create;
     procedure CreateEmitenteInfo(const XmlData: string; var EmitInfo: TEmitenteInfo;
        var FabrInfo: TFabricanteInfo);

    public
     class function New: IDAOEmitenteXmlMapper;
     destructor Destroy; override;
  end;

implementation

{ TDAOEmitenteXmlMapper }

constructor TDAOEmitenteXmlMapper.Create;
begin
 inherited Create;
end;

destructor TDAOEmitenteXmlMapper.Destroy;
begin
  inherited Destroy;
end;

class function TDAOEmitenteXmlMapper.New: IDAOEmitenteXmlMapper;
begin
 Result := self.Create;
end;

procedure TDAOEmitenteXmlMapper.CreateEmitenteInfo(const XmlData: string;
  var EmitInfo: TEmitenteInfo; var FabrInfo: TFabricanteInfo);
var
  Doc: IXMLDocument;
  InfNode, EmpNode, AttrNode, EndrNode, RootNode: IXMLNode;
  EmpCNPJ, AttrValue: olevariant;
begin
  {M�todo privado usado para mapear atributos tanto do emitente quanto do fabricante
   a partir do conte�do xml em "XmlData". Por defini��o da Tora, o "Fabricante"
   � sempre o mesmo do Emitente}
  Doc := LoadXMLData(XmlData);
  RootNode := Doc.DocumentElement.ChildNodes.FindNode(TXmlTags.Root);
  if RootNode <> nil then InfNode := RootNode.ChildNodes.FindNode(TXmlTags.InfoNfe);
  if InfNode <> nil then EmpNode := InfNode.ChildNodes.FindNode(TXmlTags.Emit);
  //Emitente: CNPJ
  if EmpNode <> nil then AttrNode := EmpNode.ChildNodes.FindNode(TXmlTags.Cnpj);
  if AttrNode <> nil then
     begin
      EmpCNPJ := AttrNode.NodeValue;
      EmitInfo.Cnpj := EmpCNPJ;
      FabrInfo.Cnpj := EmitInfo.Cnpj; //Fabricante � o mesmo que o emitente
      FabrInfo.CnpjRoot := Copy(FabrInfo.Cnpj, 1, 8);
     end;
  //Emitente: Pa�s
  if EmpNode <> nil then EndrNode := EmpNode.ChildNodes.FindNode(TXmlTags.EndEmit) ; //endere�o
  if EndrNode <> nil then AttrNode := EndrNode.ChildNodes.FindNode(TXmlTags.Pais); //C�digo do pa�s
  if AttrNode <> nil then
     begin
      AttrValue := AttrNode.NodeValue;
      EmitInfo.PaisCod := AttrValue;
      FabrInfo.PaisCod := EmitInfo.PaisCod; //Fabricante
     end;
  //Emitente: c�digo do munic�pio
  if EmpNode <> nil then EndrNode := EmpNode.ChildNodes.FindNode(TXmlTags.EndEmit) ; //endere�o
  if EndrNode <> nil then AttrNode := EndrNode.ChildNodes.FindNode(TXmlTags.MunCode) ;
  if AttrNode <> nil then
     begin
      AttrValue := AttrNode.NodeValue;
      EmitInfo.MunCod := AttrValue;
      FabrInfo.MunCod := EmitInfo.MunCod; //Fabricante
     end;

end;

end.
