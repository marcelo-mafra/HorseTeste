unit nfe.localservice.dao.checkers.companies;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils,
  //nfe units
  nfe.localservice.model.params.types,
  nfe.localservice.model.process.types,
  nfe.localservice.model.nfeobj,
  nfe.localservice.dao.process.events,
  nfe.localservice.dao.checkers.interfaces,
  nfe.localservice.dao.checkers.dbobj;

type
  {Classe "checker" que implementa as validações de destinatários, emitentes
  e fabricantes previamente existentes no sit}
  TDAOCheckCompanies = class sealed (TDAOCustomDBChecker, IDAOCheckCompanies)
    protected
      constructor Create(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
      //IDAOCheckCompanies
      function DestinatarioExists(Obj: TNFEObject; var Validated: boolean): IDAOCheckCompanies;
      function EmitenteExists(Obj: TNFEObject; var Validated: boolean): IDAOCheckCompanies;
      function FabricanteExists(Obj: TNFEObject; var Validated: boolean): IDAOCheckCompanies;

    public
      destructor Destroy; override;
      class function New(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): IDAOCheckCompanies;

      //TDAOCustomDBChecker
      property CommandBuilder;
      property Connection ;
      //TDAOCustomChecker
      property Formatter;
      property Logs;
      property Params;
      //eventos
      property OnCheckerExecute;      
      property OnUnknownData;
  end;

implementation

{ TDAOCheckCompanies }

constructor TDAOCheckCompanies.Create(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
begin
 inherited Create(ServiceParams, OnCheckerExecute, OnUnknownData);
end;

destructor TDAOCheckCompanies.Destroy;
begin
 inherited Destroy;
end;

class function TDAOCheckCompanies.New(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): IDAOCheckCompanies;
begin
 Result := TDAOCheckCompanies.Create(ServiceParams, OnCheckerExecute, OnUnknownData);
end;

function TDAOCheckCompanies.DestinatarioExists(Obj: TNFEObject;
  var Validated: boolean): IDAOCheckCompanies;
begin
 //Verifica se o destinatário está cadastrado na base de dados
 Result := self;
 Validated := Assigned(Obj) and HasData(CommandBuilder.Destinatarios.DestinatarioExists(Obj.ToraBranch.ToraBranch,
                                        QuotedStr(Obj.Destinatario.Cnpj)));
 if Assigned(OnCheckerExecute) then self.OnCheckerExecute(self, Obj, Validated);
 if not Validated and Assigned(OnUnknownData) then OnUnknownData(self, Obj, diDestinatario, EmptyStr);
end;

function TDAOCheckCompanies.EmitenteExists(Obj: TNFEObject;
  var Validated: boolean): IDAOCheckCompanies;
begin
 //Verifica se o emitente está cadastrado na base de dados do SIT
 Result := self;
 Validated := Assigned(Obj) and HasData(CommandBuilder.Emitentes.EmitenteExists(Obj.ToraBranch.ToraBranch,
                                        QuotedStr(Obj.Emitente.Cnpj)));
 if Assigned(OnCheckerExecute) then self.OnCheckerExecute(self, Obj, Validated);
 if not Validated and Assigned(OnUnknownData) then OnUnknownData(self, Obj, diEmitente, EmptyStr);
end;

function TDAOCheckCompanies.FabricanteExists(Obj: TNFEObject;
  var Validated: boolean): IDAOCheckCompanies;
begin
 //Verifica se o fabricante está cadastrado na base de dados do SIT
 Result := self;
 Validated := Assigned(Obj) and HasData(CommandBuilder.Fabricantes.FabricanteExists(QuotedStr(Obj.Fabricante.CnpjRoot)));
 if Assigned(OnCheckerExecute) then self.OnCheckerExecute(self, Obj, Validated);
 if not Validated and Assigned(OnUnknownData) then OnUnknownData(self, Obj, diFabricante, EmptyStr);
end;

end.

