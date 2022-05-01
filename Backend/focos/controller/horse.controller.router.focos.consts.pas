unit horse.controller.router.focos.consts;

interface

uses
 System.Classes;

type
 TFocosURI = class
   const
     Focos         = '/focos';
     Foco          = '/focos/:id';
     FocosParent   = '/focos/parent/:id';
     FocosRegions  = '/focos/regions/:id';
     FocoDesativar = '/focos/:id/desativar';
     FocoReativar  = '/focos/:id/reativar';
     FocosStatus   = '/focos/status/:status';
     FocosTipo     = '/focos/tipos/:idregiao/:tipo';

 end;

 TRegionsURI = class
   const
     Regions        = '/regions';
     Region         = '/regions/:id';
     RegionsMember  = '/regions/members/:id';
 end;

implementation

end.
