unit nfe.localservice.dao.nfeobj.xmlmapper.veiculo;

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
  //Implementa o mapeamento O.R. de dados do veículo a partir de fonte xml
  TDAOVeiculoXmlMapper = class(TDAOCustomXmlMapper, IDAOVeiculoXmlMapper)
    protected
     constructor Create;
     procedure CreateVeiculoInfo(const XmlData: string; var VeicInfo: TVeiculoInfo);

    public
     class function New: IDAOVeiculoXmlMapper;
     destructor Destroy; override;
  end;

implementation

{ TDAOVeiculoXmlMapper }

constructor TDAOVeiculoXmlMapper.Create;
begin
 inherited Create;
end;

destructor TDAOVeiculoXmlMapper.Destroy;
begin

  inherited Destroy;
end;

class function TDAOVeiculoXmlMapper.New: IDAOVeiculoXmlMapper;
begin
 Result := self.Create;
end;

procedure TDAOVeiculoXmlMapper.CreateVeiculoInfo(const XmlData: string;
  var VeicInfo: TVeiculoInfo);
var
  Doc: IXMLDocument;
  VolNode, AttrNode, RootNode: IXMLNode;
begin
 {Mapeia os atributos do veículo a partir do conteúdo xml em "XmlData"}
  Doc := LoadXMLData(XmlData);
  RootNode := Doc.DocumentElement.ChildNodes.FindNode(TXmlTags.Root);
  if RootNode <> nil then VolNode := RootNode.ChildNodes.FindNode(TXmlTags.InfoNfe)
                                             .ChildNodes.FindNode(TXmlTags.Transp)
                                             .ChildNodes.FindNode(TXmlTags.Volumes);
  if VolNode <> nil then
   begin
    //veículo: quantidade de volumes
    AttrNode := VolNode.ChildNodes.FindNode(TXmlTags.qtVol);
    if AttrNode <> nil then VeicInfo.qtVol:= AttrNode.NodeValue;
    //veículo: peso líquido
    AttrNode := VolNode.ChildNodes.FindNode(TXmlTags.PesoLq);
    if AttrNode <> nil then VeicInfo.PesoLq := self.Formatter.Numbers.AsPeso(AttrNode.NodeValue);
    //veículo: peso bruto
    AttrNode := VolNode.ChildNodes.FindNode(TXmlTags.PesoBr);
    if AttrNode <> nil then VeicInfo.PesoBr := self.Formatter.Numbers.AsPeso(AttrNode.NodeValue);
   end;
end;

end.
