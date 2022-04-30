unit client.model.regions.interfaces;

interface

uses
  System.Classes, System.JSON;

type
  IModelRegions = interface
    ['{2C2F9BFA-AE12-4C56-8FDB-3C74EAAA8BD8}']
    function GetRegions: string;
    function ListParentRegions(const OwnerId: integer): TJSONArray;
  end;

implementation

end.
