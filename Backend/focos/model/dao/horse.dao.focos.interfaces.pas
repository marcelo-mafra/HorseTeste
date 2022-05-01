unit horse.dao.focos.interfaces;

interface

uses
  System.Classes, System.JSON, horse.dao.regioes.interfaces;

type
  IDAOFocos = interface
    ['{CF283377-ECB2-4296-8DA2-4518008ACAA0}']
    function ListAll: TJsonArray;
    function ListFocosParent(const id: integer): TJsonArray;
    function ListFocosRegion(const id: integer): TJsonArray;
    function ListMember(const id: integer): TJsonObject;
    function ListFocosStatus(const status: boolean): TJsonArray;
    function ListFocosTipo(const id: integer; const tipo: string): TJsonArray;
    function DesativarFoco(const id: integer): TJsonObject;
    function ReativarFoco(const id: integer): TJsonObject;
    function IRegioes: IDAORegioes;
  end;

implementation

end.
