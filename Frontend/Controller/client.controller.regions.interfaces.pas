unit client.controller.regions.interfaces;

interface

uses
  System.Classes, System.Generics.Collections,
  client.controller.regions.types;

type
  IControllerRegions = interface
    ['{86E428B9-8986-4FD3-ABC9-01D45D371714}']
    function ListRegions: TRegionsList;
    function ListParentRegions(const OwnerId: integer): TRegionsList;
  end;

implementation

end.
