unit horse.dao.usuarios.interfaces;

interface

uses
  System.Classes, System.JSON;

type
  IDAOUsuarios = interface
    ['{21AEB9B2-FDD2-4709-958B-489BA6D2958E}']
    function ListAll: TJsonArray;
    function ListMember(const id: integer): TJsonObject;
  end;

implementation

end.
