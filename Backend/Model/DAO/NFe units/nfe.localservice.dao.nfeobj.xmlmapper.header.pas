unit nfe.localservice.dao.nfeobj.xmlmapper.header;

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
  //Implementa o mapeamento O.R. de dados do header da nfe a partir de fonte xml
  TDAOHeaderXmlMapper = class(TDAOCustomXmlMapper, IDAOHeaderXmlMapper)
    protected
     constructor Create;
     procedure CreateHeaderInfo(const XmlData: string; var Header: THeaderInfo);

    public
     class function New: IDAOHeaderXmlMapper;
     destructor Destroy; override;
  end;  

implementation

{ TDAOHeaderXmlMapper }

constructor TDAOHeaderXmlMapper.Create;
begin
 inherited Create;
end;

destructor TDAOHeaderXmlMapper.Destroy;
begin
  inherited Destroy;
end;

class function TDAOHeaderXmlMapper.New: IDAOHeaderXmlMapper;
begin
 Result := self.Create;
end;

procedure TDAOHeaderXmlMapper.CreateHeaderInfo(const XmlData: string;
  var Header: THeaderInfo);
const
 sZero = '0'; //do not localize
 NumNFeMask = '%s-%s';
var
  Doc: IXMLDocument;
  InfNode, IdeNode, AttrNode, RootNode: IXMLNode;
begin
  {Método privado usado para mapear atributos do cabeçalho da nfe a partir do
  conteúdo xml em "XmlData"}
  Doc := LoadXMLData(XmlData);
  RootNode := Doc.DocumentElement.ChildNodes.FindNode(TXmlTags.Root);
  if RootNode <> nil then InfNode := RootNode.ChildNodes.FindNode(TXmlTags.InfoNfe);
  if InfNode <> nil then IdeNode := InfNode.ChildNodes.FindNode(TXmlTags.Ide);
  if IdeNode <> nil then
    begin
     //Header: data da emissão
     AttrNode := IdeNode.ChildNodes.FindNode(TXmlTags.dhEmi) ;
     //busca alternativa da data de emissão em outra tag...
     if AttrNode = nil then AttrNode := IdeNode.ChildNodes.FindNode(TXmlTags.dEmi);
     if AttrNode <> nil then Header.dtEmissao := ConvertDateTime(AttrNode.NodeValue, ctDate);

     //Header: data da saída
     AttrNode := IdeNode.ChildNodes.FindNode(TXmlTags.dhSaida) ;
     //busca alternativa da data de saída em outra tag..
     if AttrNode = nil then AttrNode := IdeNode.ChildNodes.FindNode(TXmlTags.dSaida);
     if AttrNode <> nil then Header.dtSaida := ConvertDateTime(AttrNode.NodeValue, ctDate);

     //Header: número da NF
     AttrNode := IdeNode.ChildNodes.FindNode(TXmlTags.NumNF) ;
     if AttrNode <> nil then Header.numNF := AttrNode.NodeValue;
     //formata o número da NF para layout definido pela Tora
     while Length(Header.numNF) < 9 do
        Header.numNF := sZero + Header.numNF;

     //Header: série e número da NF + serie
     AttrNode := IdeNode.ChildNodes.FindNode(TXmlTags.Serie) ;
     if AttrNode <> nil then Header.serie := AttrNode.NodeValue;
     while Length(Header.serie) < 3 do
       Header.serie := sZero + Header.serie;
     //formata o número da NF + série para layout definido pela Tora
     Header.numNFSerie := Format(NumNFeMask, [Header.numNF, Header.serie]);
    end; //ideNode

end;

end.
