unit nfe.localservice.dao.nfeobj.xmlmapper.transportadora;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, System.Variants, Xml.XmlDoc,
  Xml.XMLIntf, Xml.XmlDom,
  //nfe units
  nfe.localservice.dao.nfeobj.interfaces,
  nfe.localservice.model.nfeobj.types,
  nfe.localservice.dao.nfeobj.xmlmapper.consts,
  nfe.localservice.dao.nfeobj.xmlmapper.customobj,
  nfe.localservice.dao.sqlconsts;

type
  //Implementa o mapeamento O.R. de dados da transportadora a partir de fonte xml
  TDAOTransportadoraXmlMapper = class(TDAOCustomXmlMapper, IDAOTransportadoraXmlMapper)
    protected
     constructor Create;
     procedure CreateTransportadoraInfo(const XmlData: string; var TransInfo: TTransportadoraInfo;
        var EmitInfo: TEmitenteInfo);

    public
     class function New: IDAOTransportadoraXmlMapper;
     destructor Destroy; override;
  end;

implementation

{ TDAOTransportadoraXmlMapper }

constructor TDAOTransportadoraXmlMapper.Create;
begin
 inherited Create;
end;

destructor TDAOTransportadoraXmlMapper.Destroy;
begin
  inherited Destroy;
end;

class function TDAOTransportadoraXmlMapper.New: IDAOTransportadoraXmlMapper;
begin
 Result := self.Create;
end;

procedure TDAOTransportadoraXmlMapper.CreateTransportadoraInfo(
  const XmlData: string; var TransInfo: TTransportadoraInfo;
  var EmitInfo: TEmitenteInfo);
const //do not localize!
 CSNCnpj  = '33042730';
 CSNCnpj2 = '56993900';
 MagnCnpj = '08684547';
 InfAdicKeyCSN = 'DT:';
 InfAdicKeyMag = 'DTS.DOPROCESSO:';
var
  Doc: IXMLDocument;
  InfNode, EmpNode, AttrNode, RootNode: IXMLNode;
  InfAdicCSN, InfAdicMag: boolean;
  I: integer;
begin
 {Mapeia os atributos da transportadora a partir do conteúdo xml em "XmlData"}
  TransInfo.InfAdic := TSQLChars.NullChar; //default
  Doc := LoadXMLData(XmlData);
  RootNode := Doc.DocumentElement.ChildNodes.FindNode(TXmlTags.Root);
  if RootNode <> nil then InfNode := RootNode.ChildNodes.FindNode(TXmlTags.InfoNfe);
  if InfNode <> nil then EmpNode := InfNode.ChildNodes.FindNode(TXmlTags.Transp)
                                           .ChildNodes.FindNode(TXmlTags.Transporta);
  //Dados da transportadora
  if EmpNode <> nil then AttrNode := EmpNode.ChildNodes.FindNode(TXmlTags.TranspCnpj);
  //transportadora: CNPJ
  if AttrNode <> nil then TransInfo.Cnpj := VarToStr(AttrNode.NodeValue);
  //transportadora: Nome
  if EmpNode <> nil then AttrNode := EmpNode.ChildNodes.FindNode(TXmlTags.TranspNome);
  if AttrNode <> nil then TransInfo.Nome := VarToStr(AttrNode.NodeValue);

  //Informações adicionais
  //Busca pela raíz dos cnpj's da CSN ou Magnesita. Só segue se for um deles.
  InfAdicCSN := (Pos(CSNCnpj, EmitInfo.Cnpj) > 0) or (Pos(CSNCnpj2, EmitInfo.Cnpj) > 0);
  InfAdicMag :=  Pos(MagnCnpj, EmitInfo.Cnpj) > 0;
  if not InfAdicCSN and not InfAdicMag then Exit;

  if InfNode <> nil then EmpNode := InfNode.ChildNodes.FindNode(TXmlTags.InfAdic)
                                           .ChildNodes.FindNode(TXmlTags.InfCpl);
  //Info complementares: CSN
  if (EmpNode <> nil) and InfAdicCSN then
    begin
     InfAdicCSN := Pos(InfAdicKeyCSN, UpperCase(EmpNode.NodeValue)) <> 0;
     if not InfAdicCSN then Exit;
     I := Pos(InfAdicKeyCSN, UpperCase(EmpNode.NodeValue)) + Length(InfAdicKeyCSN);
     TransInfo.InfAdic := QuotedStr(Copy(EmpNode.NodeValue, I, 8));
    end;
  //Info complementares: Magnesita
  if (EmpNode <> nil) and InfAdicMag then
    begin
     InfAdicMag := Pos(InfAdicKeyMag, UpperCase(EmpNode.NodeValue)) <> 0;
     if not InfAdicMag then Exit;
     I := Pos(InfAdicKeyMag, UpperCase(EmpNode.NodeValue)) + Length(InfAdicKeyMag);
     TransInfo.InfAdic := QuotedStr(Copy(EmpNode.NodeValue, I, 10));
    end;
  TransInfo.InfAdic := Trim(TransInfo.InfAdic);

end;

end.
