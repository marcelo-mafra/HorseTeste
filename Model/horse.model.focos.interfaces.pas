unit horse.model.focos.interfaces;

interface

uses
  System.Classes, System.JSON;

type
  IModelFocos = interface
    ['{09646FF8-10C9-45EE-8D57-D8F52D619811}']
      function ListAll: TJsonArray;
      function ListFocosRegion(const id: integer): TJsonArray;
      function ListFocosParent(const id: integer): TJsonArray;
      function ListMember(const id: integer): TJsonObject;

  end;

implementation

end.
