unit nfe.localservice.dao.nfeobj.xmlmapper.taxes;

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
  //Implementa o mapeamento O.R. de dados dos impostos a partir de fonte xml
  TDAOTaxesXmlMapper = class(TDAOCustomXmlMapper, IDAOTaxesXmlMapper)
    protected
     constructor Create;
     procedure CreateTaxesInfo(const XmlData: string; var Taxes: TTaxesInfo);

    public
     class function New: IDAOTaxesXmlMapper;
     destructor Destroy; override;
     property Formatter;
     property FormatSqlVar;
     property FormatXmlVar;

  end;

implementation

{ TDAOTaxesXmlMapper }

constructor TDAOTaxesXmlMapper.Create;
begin
 inherited Create;
end;

destructor TDAOTaxesXmlMapper.Destroy;
begin
  inherited Destroy;
end;

class function TDAOTaxesXmlMapper.New: IDAOTaxesXmlMapper;
begin
 Result := self.Create;
end;

procedure TDAOTaxesXmlMapper.CreateTaxesInfo(const XmlData: string;
  var Taxes: TTaxesInfo);
const
 DefvNF = 0;//default apenas caso o valor total venha uma string vazia. Definição da equipe Tora.
var
  Doc: IXMLDocument;
  RootNode, IcmsNode, CfopNode, ProdNode, AttrNode: IXMLNode;
  AttrValue: olevariant;
begin
  {Mapeia os impostos a partir do conteúdo xml em "XmlData"}
  Doc := LoadXMLData(XmlData);
  RootNode := Doc.DocumentElement.ChildNodes.FindNode(TXmlTags.Root);
  if RootNode = nil then Exit;
  //Raíz de diversos impostos
  IcmsNode := RootNode.ChildNodes.FindNode(TXmlTags.InfoNfe)
                      .ChildNodes.FindNode(TXmlTags.Total)
                      .ChildNodes.FindNode(TXmlTags.ICMSTot);
  if IcmsNode <> nil then
   begin
      //Taxes: vBC
      AttrNode := IcmsNode.ChildNodes.FindNode(TXmlTags.BC);
      if AttrNode <> nil then Taxes.vBC := self.Formatter.Numbers.AsBC(AttrNode.NodeValue);
      //Taxes: alíquota do ICMS
      Taxes.ICMSAliq := null;
      AttrNode := IcmsNode.ChildNodes.FindNode(TXmlTags.pICMS);
      if AttrNode <> nil then Taxes.ICMSAliq := self.Formatter.Numbers.AsIcmsAliq(AttrNode.NodeValue);
      //Taxes: valor do ICMS
      Taxes.ICMS := null;
      AttrNode := IcmsNode.ChildNodes.FindNode(TXmlTags.vICMS);
      if AttrNode <> nil then Taxes.ICMS := self.Formatter.Numbers.AsIcms(AttrNode.NodeValue);
      //Taxes: valor total da NFe
      AttrNode := IcmsNode.ChildNodes.FindNode(TXmlTags.vNF);
      if AttrNode <> nil then
       begin
        if (Trim(VarToStr(AttrNode.NodeValue)) <> EmptyStr) and (AttrNode.NodeValue <> null) then
            Taxes.vNF := self.Formatter.Numbers.AsValorTotal(AttrNode.NodeValue)
        else
            Taxes.vNF := DefvNF;
       end;
   end;
  //Raíz do CFOP
  ProdNode := Doc.DocumentElement.ChildNodes.FindNode(TXmlTags.Root)
                                 .ChildNodes.FindNode(TXmlTags.InfoNfe)
                                 .ChildNodes.FindNode(TXmlTags.ProdMk);
  if ProdNode = nil then CfopNode := ProdNode.ChildNodes.Get(0); //hardcodded: lê apenas o primeiro produto para obter o CFOP. Pedido da Tora
  if (CfopNode <> nil) and (CfopNode.NodeType = ntElement)
      and (ProdNode.HasAttribute(TXmlTags.ProdId))
      and (CfopNode.NodeName = TXmlTags.ProdTag)
  then
    begin
     CfopNode := CfopNode.ChildNodes.FindNode(TXmlTags.Cfop);
     if CfopNode <> nil then
       begin
        AttrValue := CfopNode.NodeValue;
        Taxes.CFOP := AttrValue;
       end;
    end;

end;

end.
