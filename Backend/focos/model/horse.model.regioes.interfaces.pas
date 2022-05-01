unit horse.model.regioes.interfaces;

interface

uses
  System.Classes, System.JSON;

type
  IModelRegioes = interface
    ['{1FEE284D-F805-46A5-B287-15060CA5EC92}']
      function ListRegions: TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function ListRegionsParent(const id: integer): TJsonArray;
      procedure NewRegion(obj: TJsonObject);
      function UpdateRegion(obj: TJsonObject): TJsonObject;
      function DeleteRegion(const id: integer): boolean;
  end;

implementation

end.
