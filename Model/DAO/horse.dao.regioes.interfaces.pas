unit horse.dao.regioes.interfaces;

interface

uses
  System.Classes, System.JSON;

type
  IDAORegioes = interface
    ['{BB3EC093-142E-41F2-91F2-FF13622DC239}']
    function ListRegions: TJsonArray;
    function ListMember(const id: integer): TJsonObject;
    function ListRegionsParent(const id: integer): TJsonArray;
    function NewRegion(obj: TJsonObject): IDAORegioes;
    function UpdateRegion(obj: TJsonObject): TJsonObject;
  end;

implementation

end.
