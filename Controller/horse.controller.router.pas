unit horse.controller.router;

interface

uses
 System.Classes, System.SysUtils, Web.HTTPApp, System.JSON,
 Horse, Horse.Jhonson, Horse.Query,
 horse.controller.router.types, horse.service.params,
 horse.service.params.consts, horse.service.params.types,
 {$IF DEFINED(ALUNOS_SVC)}
 horse.controller.router.alunos,
 {$ENDIF}

 {$IF DEFINED(FOCOS_SVC)}
 horse.controller.router.focos,
 horse.controller.router.regioes,
 {$ENDIF}
 horse.controller.router.consts;

type
  {Encapsula a classe THorse para expor apenas as propriedades e métodos úteis
   para este service. Isso permite também modificar a classe que encapsula os
   protocolos http/https sem impacto nas demais classes deste service.}
  THorseRouter = class(TInterfacedObject, IHorseRouter)
    private
      FFileName: string;
      FServiceParams: TBackendParams;
      function GetParamsFile: string; inline;

    protected
      constructor Create;
      function InitializeService: IHorseRouter; overload;
      function InitializeService(ACallback: THorseCAllback): IHorseRouter; overload;
      function RegisterEndpoints: IHorseRouter;
      function GetServiceParams: TBackendParams;
      function HorseVersion: string;

    public
      destructor Destroy; override;
      class function New: IHorseRouter;

      property ParamsFile: string read GetParamsFile;
      property ServiceParams: TBackendParams read GetServiceParams;

  end;

implementation

{ THorseRouter }

constructor THorseRouter.Create;
begin
 inherited;
 {$IF DEFINED(ALUNOS_SVC)}
 FFileName := TServiceParamsFiles.Alunos;
 {$ENDIF}

 {$IF DEFINED(FOCOS_SVC)}
 FFileName := TServiceParamsFiles.Focos;
 {$ENDIF}

 THorseParams.New(self.ParamsFile).ReadParams(FServiceParams);
end;

destructor THorseRouter.Destroy;
begin

  inherited;
end;

class function THorseRouter.New: IHorseRouter;
begin
 Result := self.Create;
end;

function THorseRouter.GetParamsFile: string;
begin
  Result := GetCurrentDir + '\' + FFileName;
end;

function THorseRouter.GetServiceParams: TBackendParams;
begin
 Result := FServiceParams;
end;

function THorseRouter.HorseVersion: string;
begin
 Result := THorse.Version;
end;

function THorseRouter.InitializeService(
  ACallback: THorseCAllback): IHorseRouter;
begin
 Result := self;
 THorse
    .Use(Jhonson)
    .Use(Query)
    .AddCallback(ACallback);

 THorse.Listen(ServiceParams.Porta);
end;

function THorseRouter.InitializeService: IHorseRouter;
begin
 Result := self;
 THorse
    .Use(Jhonson)
    .Use(Query);

 THorse.Listen(ServiceParams.Porta);
end;

function THorseRouter.RegisterEndpoints: IHorseRouter;
begin
  Result := self;
  {$IF DEFINED(ALUNOS_SVC)}
  //Endpoints do domínio ALUNOS
  TAlunosEndpoints.Params := self.FServiceParams;
  TAlunosEndpoints.RegistrarEndpoints;
  {$ENDIF}

  {$IF DEFINED(FOCOS_SVC)}
  //Endpoints do domínio FOCOS
  TFocosEndpoints.Params := self.FServiceParams;
  TFocosEndpoints.RegistrarEndpoints;
  //Endpoints do domínio REGIOES
  TRegioesEndpoints.Params := self.FServiceParams;
  TRegioesEndpoints.RegistrarEndpoints;
  {$ENDIF}
end;


end.
