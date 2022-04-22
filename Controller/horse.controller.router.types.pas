unit horse.controller.router.types;

interface

uses
 System.Classes,
 horse.service.params, horse.service.params.types, Horse.Callback;

type
  IHorseRouter = interface
    ['{DA2E7FE4-47BD-4183-BFA4-018E00B7D85C}']
    function InitializeService: IHorseRouter; overload;
    function InitializeService(ACallback: THorseCAllback): IHorseRouter; overload;
    function RegisterEndpoints: IHorseRouter;
    function HorseVersion: string;
    function GetServiceParams: TBackendParams;
    property ServiceParams:TBackendParams read GetServiceParams;
  end;




implementation

end.
