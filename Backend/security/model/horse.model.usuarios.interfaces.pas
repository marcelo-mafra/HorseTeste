unit horse.model.usuarios.interfaces;

interface

uses
  System.Classes, System.Json;

type
  IModelUsuarios = interface
    ['{2B2F1DE5-26B3-4AE9-A7C8-D7BAC1E5F596}']
    function ListMembers: TJsonArray;
    function ListMember(const id: integer): TJsonObject;
  end;

implementation

end.
