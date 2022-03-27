unit horse.controller.router;

interface

uses
 System.Classes, System.SysUtils, Web.HTTPApp, System.JSON,
 Horse, Horse.Jhonson,
 horse.controller.router.consts, horse.controller.router.types,
 horse.service.params, horse.model.params.builder,
 horse.model.params.builder.json, horse.controller.router.sample,
 horse.controller.router.clientes, horse.service.params.consts,
 horse.service.params.types;

type
  {Encapsula a classe THorse para expor apenas as propiedades e métodos úteis
   para este service. Isso permite também modificar a classe que encapsula os
   protocolos http/https sem impacto nas demais classes deste service.}
  THorseRouter = class(TInterfacedObject, IHorseRouter)
    private
      FServiceParams: TBackendParams;
    protected
      constructor Create;
      function InitializeService: IHorseRouter;
      function RegisterEndpoints: IHorseRouter;
      function GetServiceParams: TBackendParams;
      function HorseVersion: string;

    public
      destructor Destroy; override;
      class function New: IHorseRouter;
      property ServiceParams:TBackendParams read GetServiceParams;

  end;

implementation

{ THorseRouter }

constructor THorseRouter.Create;
begin
 inherited;
 THorseParams.New(GetCurrentDir + '\' + TServiceInfo.ParamsFile).ReadParams(FServiceParams);
end;

destructor THorseRouter.Destroy;
begin

  inherited;
end;

function THorseRouter.GetServiceParams: TBackendParams;
begin
 Result := FServiceParams;
end;

class function THorseRouter.New: IHorseRouter;
begin
 Result := self.Create;
end;

function THorseRouter.HorseVersion: string;
begin
 Result := THorse.Version;
end;

function THorseRouter.InitializeService: IHorseRouter;
begin
 Result := self;
 THorse.Use(Jhonson);
 THorse.Listen(ServiceParams.Porta);
 THorse
end;

function THorseRouter.RegisterEndpoints: IHorseRouter;
begin
  Result := self;
  THorse.Routes.RegisterRoute(mtGet, TEndPoints.Sample, TSampleEndpoints.ExecuteSampleEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TEndPoints.Clientes, TClientesEndpoints.ExecuteClientesEndpoint);
  THorse.Routes.RegisterRoute(mtGet, TEndPoints.Cliente, TClientesEndpoints.ExecuteClienteEndpoint);
end;


end.
