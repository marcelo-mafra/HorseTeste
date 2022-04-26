unit nfe.localservice.dao.nfeobj.xmlmapper.produtos;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, System.Variants, Xml.XmlDoc,
  Xml.XMLIntf, Xml.XmlDom,
  //nfe units
  nfe.localservice.dao.nfeobj.interfaces,
  nfe.localservice.model.nfeobj.types,
  nfe.localservice.model.produto,
  nfe.localservice.model.produto.interfaces,
  nfe.localservice.dao.nfeobj.xmlmapper.consts,
  nfe.localservice.dao.nfeobj.xmlmapper.customobj;

type
  //Implementa o mapeamento O.R. de dados de produtos a partir de fonte xml
  TDAOProdutosXmlMapper = class(TDAOCustomXmlMapper, IDAOProdutosXmlMapper)
    private
     procedure CalculateApportionment(List: IProdutosList; const VeicInfo: TVeiculoInfo);
     function CalculateUnits(const Nodevalue: olevariant; const Refvalue: olevariant): double;
     function IsProdutoNode(Node: IXMLNode): boolean; inline;

    protected
     constructor Create;
     procedure CreateProdutosInfo(const XmlData: string; var FabrInfo: TFabricanteInfo;
        var List: IProdutosList; const VeicInfo: TVeiculoInfo);

    public
     class function New: IDAOProdutosXmlMapper;
     destructor Destroy; override;
  end;

implementation

{ TDAOProdutosXmlMapper }

procedure TDAOProdutosXmlMapper.CalculateApportionment(List: IProdutosList;
  const VeicInfo: TVeiculoInfo);
var
 I: integer;
begin
 {Pesos líquido e bruto do produto (apenas esse rateio, a pedido da Tora).
  O rateio só pode ser feito após a chamada de List.AddProduto! }
 for I := 0 to Pred(List.Total) do
  begin
    List.Produto[I].PesoLiq   := (VeicInfo.PesoLq / List.Total);
    List.Produto[I].PesoBruto := (VeicInfo.PesoBr / List.Total);
  end;
end;

function TDAOProdutosXmlMapper.CalculateUnits(const Nodevalue,
  Refvalue: olevariant): double;
const
 idPC  = 'PC'; //do not localize!
 idTon = 'T'; //do not localize!
 defValue = 1;
 multValue = 1000;
begin
{Cálculo simples da unidade do peso (toneladas, quilos etc) a partir de orientações
passadas pela equipe da Tora.}
 Result := defValue;
 if not TryStrToFloat(Refvalue, Result) then Exit;
 //passo 1 - procura descobrir a unidade de peso
 if Pos(idTon, NodeValue) > 0 then Result := Refvalue * multValue //<qCom> em toneladas
 else
  //passo 2 - somente se teste do passo 1 for negatico (definição da Tora)
  if Trim(NodeValue) = idPC then Result := Refvalue; //<qCom>

end;

constructor TDAOProdutosXmlMapper.Create;
begin
 inherited Create;
end;

destructor TDAOProdutosXmlMapper.Destroy;
begin
  inherited Destroy;
end;

function TDAOProdutosXmlMapper.IsProdutoNode(Node: IXMLNode): boolean;
begin
 //verifica se Node se refere a um produto da NFe
 Result := (Node <> nil) and (Node.NodeType = ntElement) and
           (Node.HasAttribute(TXmlTags.ProdId)) and
           (Node.NodeName = TXmlTags.ProdMk);
end;

class function TDAOProdutosXmlMapper.New: IDAOProdutosXmlMapper;
begin
 Result := self.Create;
end;

procedure TDAOProdutosXmlMapper.CreateProdutosInfo(const XmlData: string;
  var FabrInfo: TFabricanteInfo; var List: IProdutosList;
  const VeicInfo: TVeiculoInfo);
var
  I: integer;
  IProdObj: IProdutoNfe;
  Doc: IXMLDocument;
  RootNode, InfNode, ProdItemNode, ProdNode, ProdDetNode: IXMLNode;
begin
  {Mapeia os atributos dos produtos a partir do conteúdo xml em "XmlData"}
  //somente avança caso a Lista de produtos existir e estiver vazia
  if (List = nil) or not (List.IsEmpty) then Exit;
  Doc := LoadXMLData(XmlData);
  RootNode := Doc.DocumentElement.ChildNodes.FindNode(TXmlTags.Root); //NFe
  if RootNode <> nil then InfNode := RootNode.ChildNodes.FindNode(TXmlTags.InfoNfe); //infNFe
  if InfNode = nil then Exit;
  //se chegou até aqui, pode iniciar a criação das interfaces que representam os produtos da nfe
  for I := 0 to Pred(InfNode.ChildNodes.Count) do
   begin
     ProdItemNode := InfNode.ChildNodes.Get(I);
     //se não for um node de produto da NFe, vai para o prox Node
     if not IsProdutoNode(ProdItemNode) then Continue;
     IProdObj := TProdutoNfe.New(FabrInfo);
     //índice do produto
     IProdObj.ProdIndex := ProdItemNode.Attributes[TXmlTags.ProdId];
     ProdNode := ProdItemNode.ChildNodes.FindNode(TXmlTags.ProdTag);
     if ProdNode = nil then Continue;
     //Referencia do fabricante
     ProdDetNode := ProdNode.ChildNodes.FindNode(TXmlTags.ProdCod);
     if ProdDetNode <> nil then IProdObj.RefFabricante := ProdDetNode.NodeValue;
     //Nome do produto
     ProdDetNode := ProdNode.ChildNodes.FindNode(TXmlTags.ProdName);
     if ProdDetNode <> nil then IProdObj.NomeProd := ProdDetNode.NodeValue;
     //NCM do produto
     ProdDetNode := ProdNode.ChildNodes.FindNode(TXmlTags.ProdNCM);
     if ProdDetNode <> nil then IProdObj.NCM := ProdDetNode.NodeValue;
     //Valor unitário do produto
     ProdDetNode := ProdNode.ChildNodes.FindNode(TXmlTags.ProdUnit);
     if ProdDetNode <> nil then IProdObj.ValorUnit := self.Formatter.Numbers.AsValorUnit(ProdDetNode.NodeValue);
     //Valor total do produto
     ProdDetNode := ProdNode.ChildNodes.FindNode(TXmlTags.ProdTot);
     if ProdDetNode <> nil then IProdObj.TotalItem := self.Formatter.Numbers.AsValorTotal(ProdDetNode.NodeValue);
     //Quantidade do produto (em unidades ou peso)
     IProdObj.Quantidade := IProdObj.PesoLiq; //segundo Tora, deve ser o "padrão"
     ProdDetNode  := ProdNode.ChildNodes.FindNode(TXmlTags.ProdUCom);
     ProdItemNode := ProdNode.ChildNodes.FindNode(TXmlTags.ProdQCom);
     if (ProdDetNode <> nil) and (ProdItemNode <> nil) then
       IProdObj.Quantidade := self.CalculateUnits(ProdDetNode.NodeValue, ProdItemNode.NodeValue);
     //adiciona o novo produto à lista "List"
     if Assigned(IProdObj) then List.AddProduto(IProdObj);
   end; //endfor
  //Faz o cálculo do rateio de pesos dos produtos da NFe
  CalculateApportionment(List, VeicInfo);

end;

end.
