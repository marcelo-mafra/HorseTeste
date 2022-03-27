unit nfe.localservice.dao.checkers.customobj;

interface
uses
  Winapi.Windows, System.Classes, System.SysUtils,
  //nfe units
  nfe.localservice.model.params.types,
  nfe.localservice.dao.process.events,
  nfe.localservice.model.logs.types,
  nfe.localservice.dao.logs.interfaces, 
  nfe.localservice.dao.logs,
  nfe.localservice.dao.checkers.interfaces,
  nfe.localservice.dao.formatters.interfaces,
  nfe.localservice.dao.formatters.helper;

type
  {Classe-base de todas** as classes "checker".}
  TDAOCustomChecker = class (TInterfacedObject, ICustomChecker)
    private
      FParams: TModelServiceParams;
      FOnCheckerExecute: TOnCheckerExecuteEvent;
      function GetIFormatterHelper: IFormatterHelper;
      function GetLogInterface: INFEDAOLogs; inline;

    protected
      constructor Create; overload;
      constructor Create(OnCheckerExecute: TOnCheckerExecuteEvent); overload;
      constructor Create(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent); overload;
      function GetOnCheckerExecute: TOnCheckerExecuteEvent;
      
    public
      destructor Destroy; override;
      class function New: ICustomChecker; overload;
      class function New(OnCheckerExecute: TOnCheckerExecuteEvent): ICustomChecker; overload;
      class function New(const ServiceParams: TModelServiceParams;
          OnCheckerExecute: TOnCheckerExecuteEvent): ICustomChecker; overload;

      property Formatter: IFormatterHelper read GetIFormatterHelper;
      property Logs: INFEDAOLogs read GetLogInterface;
      property Params: TModelServiceParams read FParams;
      //eventos
      property OnCheckerExecute: TOnCheckerExecuteEvent read GetOnCheckerExecute;

  end;

implementation

{ TDAOCustomChecker }

constructor TDAOCustomChecker.Create;
begin
 inherited Create;
end;

constructor TDAOCustomChecker.Create(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent);
begin
 inherited Create;
 FParams := ServiceParams;
 FOnCheckerExecute := OnCheckerExecute;
end;

constructor TDAOCustomChecker.Create(OnCheckerExecute: TOnCheckerExecuteEvent);
begin
 inherited Create;
 FOnCheckerExecute := OnCheckerExecute;
end;

destructor TDAOCustomChecker.Destroy;
begin
 FOnCheckerExecute := nil;
 inherited Destroy;
end;

class function TDAOCustomChecker.New: ICustomChecker;
begin
 Result := TDAOCustomChecker.Create;
end;

class function TDAOCustomChecker.New(
  OnCheckerExecute: TOnCheckerExecuteEvent): ICustomChecker;
begin
 Result := TDAOCustomChecker.Create(OnCheckerExecute);
end;

class function TDAOCustomChecker.New(const ServiceParams: TModelServiceParams;
  OnCheckerExecute: TOnCheckerExecuteEvent): ICustomChecker;
begin
 Result := TDAOCustomChecker.Create(ServiceParams, OnCheckerExecute);
end;

function TDAOCustomChecker.GetIFormatterHelper: IFormatterHelper;
begin
 Result := TFormatterHelper.New;
end;

function TDAOCustomChecker.GetLogInterface: INFEDAOLogs;
begin
 //Retorna a interface DAO para escrita de logs
 Result := TNFEDAOLogs.New(nil, Params.Data, Params.Timeouts);
end;

function TDAOCustomChecker.GetOnCheckerExecute: TOnCheckerExecuteEvent;
begin
 Result := FOnCheckerExecute;
end;

end.
