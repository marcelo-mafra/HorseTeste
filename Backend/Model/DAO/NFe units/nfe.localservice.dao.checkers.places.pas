unit nfe.localservice.dao.checkers.places;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils,
  //nfe units
  nfe.localservice.model.params.types,
  nfe.localservice.model.process.types,
  nfe.localservice.dao.process.events,
  nfe.localservice.model.nfeobj,
  nfe.localservice.dao.sqlconsts,
  nfe.localservice.dao.checkers.interfaces,
  nfe.localservice.dao.checkers.dbobj;

type
  //Classe "checker" que implementa as validações de país e municípios
  TDAOCheckPlaces = class sealed (TDAOCustomDBChecker, IDAOCheckPlaces)
    protected
      constructor Create(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
      //ISitCheckPlaces
      function isValidPaisCode(Obj: TNFEObject; var Validated: boolean): IDAOCheckPlaces;
      function MunicipioExists(Obj: TNFEObject; var Validated: boolean): IDAOCheckPlaces;

    public
      destructor Destroy; override;
      class function New(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): IDAOCheckPlaces;

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

{ TDAOCheckPlaces }

constructor TDAOCheckPlaces.Create(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent);
begin
 inherited Create(ServiceParams, OnCheckerExecute, OnUnknownData);
end;

destructor TDAOCheckPlaces.Destroy;
begin
  inherited Destroy;
end;

class function TDAOCheckPlaces.New(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent; OnUnknownData: TOnUnknownDataEvent): IDAOCheckPlaces;
begin
 Result := TDAOCheckPlaces.Create(ServiceParams, OnCheckerExecute, OnUnknownData);
end;

function TDAOCheckPlaces.isValidPaisCode(Obj: TNFEObject; var Validated: boolean): IDAOCheckPlaces;
begin
 {Valida se país do destinatario/emitente são válidos. A validação aqui é
 hard-codded, conforme definição da Tora. }
 Result := self;
 Validated := Assigned(Obj) and (Obj.Emitente.PaisCod = TNFeDefValues.PaisCode);
           //and (Obj.Destinatario.PaisCod = TNFeDefValues.PaisCode);
 //dispara o evento OnCheckerExecute
 if Assigned(OnCheckerExecute) then OnCheckerExecute(self, Obj, Validated);
 //dispara o evento OnUnknownData caso o país não seja o esperado
 if not Validated and Assigned(OnUnknownData) then OnUnknownData(self, Obj, diPais, EmptyStr);
end;

function TDAOCheckPlaces.MunicipioExists(Obj: TNFEObject; var Validated: boolean): IDAOCheckPlaces;
begin
 {Verifica se os municípios do destinatário/emitente estão cadastrados
  previamente na base de dados do SIT}
 Result := self;
 //Município do destinatário..

 Validated := Assigned(Obj) and (HasData(CommandBuilder.Pracas.MunicipioExiste(QuotedStr(Obj.Destinatario.MunCod))));
 //Município do emitente. Só valida se o municipio do destinatio já existir
 if Validated then Validated := Assigned(Obj) and (HasData(CommandBuilder.Pracas.MunicipioExiste(QuotedStr(Obj.Emitente.MunCod))));
 //dispara o evento OnCheckerExecute
 if Assigned(OnCheckerExecute) then OnCheckerExecute(self, Obj, Validated);
 //dispara o evento OnUnknownData 
 if not Validated and Assigned(OnUnknownData) then OnUnknownData(self, Obj, diMunicipio, EmptyStr);
end;

end.
