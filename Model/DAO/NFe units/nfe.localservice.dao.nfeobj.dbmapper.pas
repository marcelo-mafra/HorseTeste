unit nfe.localservice.dao.nfeobj.dbmapper;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, Data.DB, System.Variants,
  //nfe units...
  nfe.localservice.dao.nfeobj.interfaces,
  nfe.localservice.dao.connection.interfaces,
  nfe.localservice.dao.connection.factory,
  nfe.localservice.dao.exceptions,
  nfe.localservice.dao.exceptions.consts,
  nfe.localservice.model.params.types,
  nfe.localservice.dao.sqlconsts,
  nfe.localservice.model.nfeobj.types, 
  nfe.localservice.model.produto.interfaces, 
  nfe.localservice.dao.commands.builder, 
  nfe.localservice.dao.commands.interfaces ;

type
  TNFEObjectDBMapper = class(TInterfacedObject, INFEDAODbMapper)
    strict private
      procedure CloseAll(Ds: TDataset); inline;

    private
      FIConnection: IAbstractConnection;
      FParams: TModelServiceParams;
      function GetCommandBuilder: ICommandBuilder;
      function GetIConnectionIntf: IAbstractConnection;
      function DoExecuteSQL(const Command: string): TDataset;
      
    protected
      constructor Create(const ServiceParams: TModelServiceParams);
      procedure ReadDestinatarioInfo(const Info: TToraBranchsInfo; var DestInfo: TDestinatarioInfo);
      procedure ReadEmitenteteInfo(const Info: TToraBranchsInfo; var EmitInfo: TEmitenteInfo);
      procedure ReadFabricanteInfo(var FabrInfo: TFabricanteInfo);
      procedure ReadProdutosInfo(const Info: TToraBranchsInfo; List: IProdutosList; Fabricante: TFabricanteInfo);
      procedure ReadToraBranchsInfo(var Info: TDataInfo);

    public
      destructor Destroy; override;
      class function New(const ServiceParams: TModelServiceParams): INFEDAODbMapper;
      property CommandBuilder: ICommandBuilder read GetCommandBuilder;
      property Connection: IAbstractConnection read GetIConnectionIntf ;
      property Params: TModelServiceParams read FParams;
  end;

implementation

{ TNFEObjectDBMapper }

constructor TNFEObjectDBMapper.Create(const ServiceParams: TModelServiceParams);
begin
 inherited Create;
 FParams := ServiceParams;
end;

destructor TNFEObjectDBMapper.Destroy;
begin
  if Assigned(FIConnection) then FIConnection := nil;
  inherited Destroy;
end;

class function TNFEObjectDBMapper.New(const ServiceParams: TModelServiceParams): INFEDAODbMapper;
begin
 Result := self.Create(ServiceParams);
end;

procedure TNFEObjectDBMapper.CloseAll(Ds: TDataset);
begin
 if Assigned(Ds) and (Ds.Active) then Ds.Close;
 if Assigned(Ds) then FreeAndNil(Ds);
end;

function TNFEObjectDBMapper.DoExecuteSQL(const Command: string): TDataset;
begin
 //Excuta um comando "select"
 Result := Connection.CreateDataset(Command);
end;

function TNFEObjectDBMapper.GetCommandBuilder: ICommandBuilder;
begin
 Result := TCommandBuilder.New(Params);
end;

function TNFEObjectDBMapper.GetIConnectionIntf: IAbstractConnection;
begin
 //Método de leitura da property "Connection"
 if not Assigned(FIConnection) then
    FIConnection := TConnectionFactory.New(Params.Data, Params.Timeouts);

 if not Assigned(FIConnection) then
    raise EInvalidConnectionObject.Create(TDAOErrorMessages.InvalidConnection);
 Result := FIConnection;
end;

procedure TNFEObjectDBMapper.ReadDestinatarioInfo(const Info: TToraBranchsInfo;
  var DestInfo: TDestinatarioInfo);
var
 Ds: TDataset;
begin
 //Obtém alguns dados do destinatário a partir do banco de dados do SIT
  try
    if Trim(DestInfo.Cnpj) = EmptyStr then raise ENFeObjectDbMapping.Create(TDAOErrorMessages.EmptyCnpjDest);
    //busca o cnpj no banco de dados do sit
    Ds := self.DoExecuteSQL(CommandBuilder.Destinatarios.DestinatarioInfo(Info.ToraBranch, QuotedStr(DestInfo.Cnpj)));
    //falha na tentativa de localizar...
    if not Assigned(Ds) then raise EInvalidDatasetState.Create(TDAOErrorMessages.UnexpectedDatasetError) ;
    if not Ds.IsEmpty then //infos localizadas no sit..
      begin
        DestInfo.Filcod := Ds.Fields.FieldByName(TNFEIFields.Filcod).Value;
        DestInfo.Pcacod := Ds.Fields.FieldByName(TNFEIFields.Pcacod).Value;
        DestInfo.Orgcod := Ds.Fields.FieldByName(TNFEIFields.Orgcod).Value;
      end
    else //não foi localizado no sit ...
      raise ENFeObjectDbMapping.Create(Format(TDAOErrorMessages.UnknownCnpjDest, [DestInfo.Cnpj]));

    CloseAll(Ds);
  except
   on E: EInvalidDatasetState do
     begin
      if Assigned(Ds) then CloseAll(Ds);
      raise;
     end;
   on E: ENFeObjectDbMapping do
     begin
      if Assigned(Ds) then CloseAll(Ds);
      raise;
     end;
   on E: Exception do
     begin
      if Assigned(Ds) then CloseAll(Ds);
      raise;
     end;
  end;
end;

procedure TNFEObjectDBMapper.ReadEmitenteteInfo(const Info: TToraBranchsInfo;
    var EmitInfo: TEmitenteInfo);
var
 Ds: TDataset;
begin
 //Obtém alguns dados do emitente a partir do banco de dados do SIT
  try
    if Trim(EmitInfo.Cnpj) = EmptyStr then //cnpj vazio (inexistente na NFe)
      raise ENFeObjectDbMapping.Create(Format(TDAOErrorMessages.InvalidCnpjEmit, [EmitInfo.Cnpj]));
    //busca o cnpj no banco de dados do sit
    Ds := self.DoExecuteSQL(CommandBuilder.Emitentes.EmitenteInfo(Info.ToraBranch, QuotedStr(EmitInfo.Cnpj)));
    //falha na tentativa de localizar...
    if not Assigned(Ds) then raise EInvalidDatasetState.Create(TDAOErrorMessages.UnexpectedDatasetError) ;
    if not Ds.IsEmpty then //infos localizadas no sit..
      begin
        EmitInfo.Filcod := Ds.Fields.FieldByName(TNFEIFields.Filcod).Value;
        EmitInfo.Pcacod := Ds.Fields.FieldByName(TNFEIFields.Pcacod).Value;
        EmitInfo.Orgcod := Ds.Fields.FieldByName(TNFEIFields.Orgcod).Value;
      end
    else //não foi localizado no sit ...
      raise ENFeObjectDbMapping.Create(Format(TDAOErrorMessages.UnknownCnpjEmit, [EmitInfo.Cnpj]));

   CloseAll(Ds);
  except
   on E: EInvalidDatasetState do
     begin
      CloseAll(Ds);
      raise;
     end;
   on E: ENFeObjectDbMapping do
     begin
      CloseAll(Ds);
      raise;
     end;
   on E: Exception do
   begin
    CloseAll(Ds);
    raise;
   end;
  end;
end;

procedure TNFEObjectDBMapper.ReadFabricanteInfo(var FabrInfo: TFabricanteInfo);
const
 posIni = 1; //posição inicial e final para cópia do fragmento do cnpj
 posFim = 8;
var
 Ds: TDataset;
 CnpjShort: string;
begin
  CnpjShort := QuotedStr(Copy(FabrInfo.Cnpj, posIni, posFim));
  try
    //cnpj vazio (inexistente na NFe)
    if Trim(CnpjShort) = EmptyStr then raise ENFeObjectDbMapping.Create(Format(TDAOErrorMessages.InvalidCnpjFabr, [FabrInfo.Cnpj]));
    //busca o cnpj no banco de dados do sit
    Ds := self.DoExecuteSQL(CommandBuilder.Fabricantes.FabricanteInfo(CnpjShort));
    if Assigned(Ds) and not (Ds.IsEmpty) then //infos localizadas no sit..
      begin
        FabrInfo.CodFab := Ds.Fields.FieldByName(TNFEIFields.CodFab).Value;
        FabrInfo.LocFab := Ds.Fields.FieldByName(TNFEIFields.LocFab).Value;
      end;
   //não foi localizado no sit o cnpj do fabricante (ou falha na tentativa de localizar)...
   if Assigned(Ds) and (Ds.IsEmpty) then raise ENFeObjectDbMapping.Create(Format(TDAOErrorMessages.UnknownCnpjFabr, [FabrInfo.Cnpj]));
   //não foi localizado no sit o cnpj do fabricante (ou falha na tentativa de localizar)...
   if not Assigned(Ds) then raise EInvalidDatasetState.Create(TDAOErrorMessages.UnexpectedDatasetError) ;

   CloseAll(Ds);
  except
   on E: EInvalidDatasetState do
     begin
      CloseAll(Ds);
      raise;
     end;
   on E: ENFeObjectDbMapping do
     begin
      CloseAll(Ds);
      raise;
     end;
   on E: Exception do
   begin
    CloseAll(Ds);
    raise;
   end;
  end;
end;

procedure TNFEObjectDBMapper.ReadProdutosInfo(const Info: TToraBranchsInfo;
  List: IProdutosList; Fabricante: TFabricanteInfo);
var
 I: integer;
 Ds: TDataset;
 IProd: IProdutoNfe;
 ProdInfo: TSitProdutoInfo;
begin
 for I := 0 to Pred(List.Total) do
  begin
   IProd := List.Produto[I];
   //valores default de ProdInfo
   ProdInfo.codprod := null;
   ProdInfo.locprod := 0;
   try
    //Tenta obter dados do produto se ele existir no SIT
    Ds := self.DoExecuteSQL(CommandBuilder.Produtos.ProductExists(QuotedStr(IProd.RefFabricante), QuotedSTr(Fabricante.CodFab) ));
    if not Assigned(Ds) then raise EInvalidDatasetState.Create(TDAOErrorMessages.UnexpectedDatasetError) ;
    if not Ds.IsEmpty then
     begin //produto já cadastrado no SIT
      ProdInfo.codprod := Ds.Fields.FieldByName(TNFEIFields.CodProd).value;
      ProdInfo.locprod := Ds.Fields.FieldByName(TNFEIFields.LocProd).value;
     end;
    IProd.ProdInfo := ProdInfo;
    IProd.Fabricante := Fabricante;
    self.CloseAll(Ds);
   except
    raise;
   end;
  end;
end;

procedure TNFEObjectDBMapper.ReadToraBranchsInfo(var Info: TDataInfo);
const
 posIni = 1; //posição inicial e final para cópia do fragmento do cnpj
 posFim = 8;
var
 Ds: TDataset;
 CnpjShort: string;
begin
{
Resgra estabelecida pelo time Tora:
1- Localizar em CNPJ_EMPRESA o usuário a partir do CNPJ do DESTINATÁRIO
2 - Caso a pesquisa do paso 1 não encontre nada, fazer o mesmo usando o CNPJ da TRANSPORTADORA.
3 - Caso também o passo 2 não encontre nada, estourar exception ENFeObjectDbMapping

Esas regras são válidas para qualquer** NFE, de transporte ou armazenagem
}
  //inicia limpando as infos de TDataInfo
  Info.ToraBranch.ToraBranch := EmptyStr;
  Info.ToraBranch.ToraCnpj   := EmptyStr;
  try
    //Passo 1: localiza a empresa Tora a partir do cnpj do destinatário
    CnpjShort := QuotedStr(Copy(Info.Destinatario.Cnpj, posIni, posFim));
    Ds := self.DoExecuteSQL(CommandBuilder.Tora.ToraBranchsInfo(CnpjShort));
    if Assigned(Ds) and (Ds.IsEmpty) and (Info.Destinatario.Cnpj <> Info.Transportadora.Cnpj) then
     begin
     //Passo 2: como o passo 1 nada encontrou, inicia a busca usando o cnpj da transportadora
       self.CloseAll(Ds);
       CnpjShort := QuotedStr(Copy(Info.Transportadora.Cnpj, posIni, posFim));
       Ds := self.DoExecuteSQL(CommandBuilder.Tora.ToraBranchsInfo(CnpjShort));
     end;
    //Usuário localizado em CNPJ_EMPRESA (no passo 1 ou no passo 2)
    if Assigned(Ds) and not (Ds.IsEmpty) then
      begin
        Info.ToraBranch.ToraBranch := TrimRight(Ds.Fields.FieldByName(TNFEIFields.ToraBranch).Value);
        Info.ToraBranch.ToraCnpj   := CnpjShort;
      end;
    CloseAll(Ds);

  except
   on E: EInvalidDatasetState do
     begin
      CloseAll(Ds);
      raise;
     end;
   on E: ENFeObjectDbMapping do
     begin
      CloseAll(Ds);
      raise;
     end;
   on E: Exception do
   begin
    CloseAll(Ds);
    raise;
   end;
  end;
end;


end.
