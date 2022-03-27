unit nfe.localservice.dao.checkers.products;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils,  System.Variants, Data.DB,
  //nfe units
  nfe.localservice.model.params.types,
  nfe.localservice.model.process.types,
  nfe.localservice.model.nfeobj,
  nfe.localservice.model.produto.interfaces,
  nfe.localservice.model.nfeobj.types,
  nfe.localservice.dao.process.events,
  nfe.localservice.dao.sqlconsts,
  nfe.localservice.dao.checkers.interfaces,
  nfe.localservice.dao.checkers.dbobj, 
  nfe.localservice.dao.exceptions,
  nfe.localservice.dao.exceptions.consts;


type
  {Classe "checker" que implementa as validações de produtos previamente existentes
  no sit}
  TDAOCheckProducts = class sealed (TDAOCustomDBChecker, IDAOCheckProducts)
    private
      FList: TInterfaceList;
      procedure DoUpdatedProductInfo(var IProd: IProdutoNfe);

    protected
      constructor Create(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
      function ProductsExist(Obj: TNFEObject; var Script: TStringList): IDAOCheckProducts;

    public
      destructor Destroy; override;
      class function New(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): IDAOCheckProducts;

      //TDAOCustomDBChecker
      property CommandBuilder;
      property Connection;
      //TDAOCustomChecker
      property Formatter;
      property Logs;
      property Params;
      //eventos
      property OnCheckerExecute;      
      property OnUnknownData;
  end;

implementation

{ TDAOCheckProducts }

constructor TDAOCheckProducts.Create(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
begin
 inherited Create(ServiceParams, OnCheckerExecute, OnUnknownData);
 FList := TInterfaceList.Create;
end;

destructor TDAOCheckProducts.Destroy;
begin
 FList.Free;
 inherited Destroy;
end;

class function TDAOCheckProducts.New(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): IDAOCheckProducts;
begin
 Result := TDAOCheckProducts.Create(ServiceParams, OnCheckerExecute, OnUnknownData);
end;

procedure TDAOCheckProducts.DoUpdatedProductInfo(var IProd: IProdutoNfe);
var
 I: integer;
 Ds: TDataset;
 ProdInfo: TSitProdutoInfo;
 CurrentProd: IProdutoNfe;
begin
 //procura no cache local se os dados do produto já foram obtidos
 for I := 0 to Pred(FList.Count) do
   begin
    CurrentProd := IProdutoNfe(FList.Items[I]);
    if not Assigned(CurrentProd) then Continue;
    if Trim(CurrentProd.Fabricante.CodFab) = EmptyStr then Continue;
    if Trim(CurrentProd.RefFabricante) = EmptyStr then Continue;
    {verifica se o produto no cache local é do mesmo fabricante e
     tem o mesmo código (do fabricante)}
    if (CurrentProd.RefFabricante = IProd.RefFabricante) and
       (CurrentProd.Fabricante.CodFab = IProd.Fabricante.CodFab)
    then
     begin //produto encontrado no cache. não será preciso checar no banco do sit
      ProdInfo.codprod := CurrentProd.ProdInfo.codprod;
      IProd.ProdInfo := ProdInfo;
      Break;
     end;
   end;
 //se chegou aqui, o produto inexiste no cache
 if IProd.ProdInfo.codprod <> null then Exit;
 if Trim(IProd.RefFabricante) = EmptyStr then Exit;
 if Trim(IProd.Fabricante.CodFab) = EmptyStr then Exit;
 //se chegou aqui, vê se o produto já foi inserido no SIT por outro thread
 try
  //Tenta obter dados do produto se ele existir no SIT
  Ds := Connection.CreateDataset(CommandBuilder.Produtos.ProductExists(IProd));
  if not Assigned(Ds) then raise EInvalidDatasetState.Create(TDAOErrorMessages.UnexpectedDatasetError) ;
  if not Ds.IsEmpty then
   begin //produto já cadastrado no SIT
    ProdInfo.codprod := Ds.Fields.FieldByName(TNFEIFields.CodProd).value;
    ProdInfo.locprod := Ds.Fields.FieldByName(TNFEIFields.LocProd).value;
    IProd.ProdInfo := ProdInfo;
   end;
  if Ds.Active then Ds.Close;
  FreeAndNil(Ds);
 except
  if Ds.Active then Ds.Close;
  FreeAndNil(Ds);
  raise;
 end;
end;

function TDAOCheckProducts.ProductsExist(Obj: TNFEObject;
  var Script: TStringList): IDAOCheckProducts;
var
I: integer;
IProd: IProdutoNfe; //abstrai um produto descrito na nfe
Validated: boolean;
begin
 {Verifica se o produto está cadastrado na base de dados do SIT. Em caso negativo
  esse método não*** insere o novo produto, mas apenas gera um comando "insert" e
  o adiciona ao script de comandos SQL recebido }
 Result := self;
 //O param "Validated" aqui é irrelevante. então vai como hardcodded o valor "True"
 Validated := True;
 if not (Assigned(Obj)) or not (Assigned(Script)) then Exit;
 //percorre todos os produtos da nfe
 for I := 0 to Pred(Obj.Produtos.Total) do
   begin
    IProd := Obj.Produtos.Produto[I];
    if Assigned(IProd) and (IProd.ProdInfo.codprod <> null) then Continue;
    if Trim(IProd.RefFabricante) = EmptyStr then Continue;
    if Trim(IProd.Fabricante.CodFab) = EmptyStr then Continue;

    DoUpdatedProductInfo(IProd);
    //costrói o comando de inserção de produto
    if IProd.ProdInfo.codprod = null then
     begin
      CommandBuilder.Produtos.ProductInsert(IProd,Obj.Fabricante, Script);
      if Assigned(OnUnknownData) then OnUnknownData(self, Obj, diProduto, IProd.RefFabricante);
     end;
    FList.Add(IProd);
   end;
 if Assigned(OnCheckerExecute) then self.OnCheckerExecute(self, Obj, Validated);
end;


end.
