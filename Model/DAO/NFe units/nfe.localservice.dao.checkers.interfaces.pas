unit nfe.localservice.dao.checkers.interfaces;

interface

uses
  Winapi.Windows, System.Classes,
  //nfe units
  nfe.localservice.model.nfeobj,
  nfe.localservice.dao.process.events;

type
  //Abstrai os 3 conjuntos de eventos disponíveis em cada instanciamento de uma classe checker
  TCheckerEvents = (ceFullEvents, ceOnExecute, ceNone);

  IDAOCheckCompanies    = interface;
  IDAOCheckNFes         = interface;
  IDAOCheckPlaces       = interface;
  IDAOCheckProducts     = interface;
  IDAOCheckXMLStructure = interface;

  //Interface da classe factory de todos os "checkers"
  IFactoryCheckers = interface
    ['{DC9C385A-159C-466E-8FFD-2B0EB1F3E029}']
    function Companies: IDAOCheckCompanies;
    function NFes: IDAOCheckNFes;
    function Places: IDAOCheckPlaces;
    function Products: IDAOCheckProducts;
    function XmlCheckers(const XmlContent: string): IDAOCheckXMLStructure;

  end;

  //interface base de todas interfaces implementadas por classes "checkers"
  ICustomChecker = interface
    ['{123CC5C9-A9A1-4FDC-BDA4-FA88B421A226}']
    function GetOnCheckerExecute: TOnCheckerExecuteEvent;
    property OnCheckerExecute: TOnCheckerExecuteEvent read GetOnCheckerExecute;
  end;

  IDAOCheckXMLStructure = interface(ICustomChecker)
    ['{71279150-443E-4278-8B51-A9E0BAA4D9C3}']
    function IsValidXML(var ErrorMsg: string): boolean;
    function XmlIsEmpty: boolean;
  end;

  //Interface usada na classe-base de todos as classes "checker" do service.
  ICustomDBChecker = interface(ICustomChecker)
    ['{23285342-0FF3-4EBE-8593-8251AC1EF605}']
    function HasData(const command: string): boolean;    
  end;

  //Define o contrato de validações de país e municípios das nfe's frente ao sit
  IDAOCheckPlaces = interface(ICustomDBChecker)
    ['{12E6DB2B-3103-49E0-8EDC-25C6CFD9BD92}']
    function isValidPaisCode(Obj: TNFEObject; var Validated: boolean): IDAOCheckPlaces;
    function MunicipioExists(Obj: TNFEObject; var Validated: boolean): IDAOCheckPlaces;
  end;

  //Define o contrato de validações de empresas envolvidas das nfe's frente ao sit
  IDAOCheckCompanies = interface(ICustomDBChecker)
    ['{D71F6EF9-8E0E-46AC-9803-887A73364CC0}']
    function DestinatarioExists(Obj: TNFEObject; var Validated: boolean): IDAOCheckCompanies;
    function EmitenteExists(Obj: TNFEObject; var Validated: boolean): IDAOCheckCompanies;
    function FabricanteExists(Obj: TNFEObject; var Validated: boolean): IDAOCheckCompanies;
  end;

  //Define o contrato de validações de produtos das nfe's frente ao sit
  IDAOCheckProducts = interface(ICustomDBChecker)
    ['{F6098EDA-10B6-4B77-932C-DC6421A205CE}']
    function ProductsExist(Obj: TNFEObject; var Script: TStringList): IDAOCheckProducts;
  end;

  //Define o contrato de validações de produtos das nfe's frente ao sit
  IDAOCheckNFes = interface(ICustomDBChecker)
    ['{D220FE6E-847B-408C-B8BC-D2C52A359FB1}']
    function NotaFiscalExiste(var Obj: TNFEObject; var Script: TStringList): IDAOCheckNFes;
  end;

implementation

end.
