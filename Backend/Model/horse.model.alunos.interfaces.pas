unit horse.model.alunos.interfaces;

interface

uses
  System.Classes, System.JSON;

type
  IModelAlunos = interface
    ['{24BA8A58-53E6-4230-8FD1-A363AAE171D5}']
      function ListAll: TJsonArray;
      function ListByFoco(const id: integer): TJsonArray;
      function ListByGroup(const focoid, groupid: integer): TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function ListMemberMatricula(const matricula: string): TJsonObject;
  end;


implementation

end.
