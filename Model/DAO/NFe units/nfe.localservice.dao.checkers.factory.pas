unit nfe.localservice.dao.checkers.factory;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils,
  //nfe units
  nfe.localservice.model.params.types,
  nfe.localservice.dao.process.events,
  nfe.localservice.dao.checkers.interfaces,
  nfe.localservice.dao.checkers.xmlstructobj,
  nfe.localservice.dao.checkers.companies, 
  nfe.localservice.dao.checkers.places,
  nfe.localservice.dao.checkers.products,
  nfe.localservice.dao.checkers.nfes;

type
  //classe "factory" que cria objetos de várias classes "checkers"
  TDAOFactoryCheckers = class(TInterfacedObject, IFactoryCheckers)
     private
      FParams: TModelServiceParams;
      FOnCheckerExecute: TOnCheckerExecuteEvent;
      FOnUnknownData: TOnUnknownDataEvent;
      
     protected
      constructor Create; overload;
      constructor Create(OnCheckerExecute: TOnCheckerExecuteEvent); overload;
      constructor Create(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent); overload;      
      function Companies: IDAOCheckCompanies;
      function NFes: IDAOCheckNFes;
      function Places: IDAOCheckPlaces;
      function Products: IDAOCheckProducts;
      function XmlCheckers(const XmlContent: string): IDAOCheckXMLStructure;

     public
      destructor Destroy; override;
      class function New: IFactoryCheckers; overload;
      class function New(OnCheckerExecute: TOnCheckerExecuteEvent): IFactoryCheckers; overload;
      class function New(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): IFactoryCheckers; overload;

      property Params: TModelServiceParams read FParams;
      //eventos
      property OnCheckerExecute: TOnCheckerExecuteEvent read FOnCheckerExecute;
      property OnUnknownData: TOnUnknownDataEvent read FOnUnknownData;
  end;

implementation

{ TDAOFactoryCheckers }

constructor TDAOFactoryCheckers.Create;
begin
 inherited Create;
end;

constructor TDAOFactoryCheckers.Create(OnCheckerExecute: TOnCheckerExecuteEvent);
begin
 inherited Create;
 FOnCheckerExecute := OnCheckerExecute;
end;

constructor TDAOFactoryCheckers.Create(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
begin
 inherited Create;
 FParams := ServiceParams;
 FOnCheckerExecute := OnCheckerExecute;
 FOnUnknownData := OnUnknownData;
end;

destructor TDAOFactoryCheckers.Destroy;
begin
 FOnCheckerExecute := nil;
 FOnUnknownData := nil;
 inherited Destroy;
end;

class function TDAOFactoryCheckers.New: IFactoryCheckers;
begin
 Result := self.Create;
end;

class function TDAOFactoryCheckers.New(OnCheckerExecute: TOnCheckerExecuteEvent): IFactoryCheckers;
begin
 Result := self.Create(OnCheckerExecute);
end;

class function TDAOFactoryCheckers.New(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): IFactoryCheckers;
begin
 Result := self.Create(ServiceParams, OnCheckerExecute, OnUnknownData);
end;

function TDAOFactoryCheckers.NFes: IDAOCheckNFes;
begin
 Result := TDAOCheckNFes.New(Params, OnCheckerExecute, OnUnknownData);
end;

function TDAOFactoryCheckers.Companies: IDAOCheckCompanies;
begin
 Result := TDAOCheckCompanies.New(Params, OnCheckerExecute, OnUnknownData);
end;

function TDAOFactoryCheckers.Places: IDAOCheckPlaces;
begin
 Result := TDAOCheckPlaces.New(Params, OnCheckerExecute, OnUnknownData);
end;

function TDAOFactoryCheckers.Products: IDAOCheckProducts;
begin
 Result := TDAOCheckProducts.New(Params, OnCheckerExecute, OnUnknownData);
end;

function TDAOFactoryCheckers.XmlCheckers(const XmlContent: string): IDAOCheckXMLStructure;
begin
 Result := TDAOCheckXMLStructure.New(XmlContent, OnCheckerExecute)
end;

end.
