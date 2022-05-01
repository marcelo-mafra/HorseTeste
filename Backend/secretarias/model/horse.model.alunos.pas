unit horse.model.alunos;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON,
  horse.dao.alunos.datasets, horse.service.params.types,
  horse.model.alunos.interfaces, horse.model.customobj ;

type
  TModelAlunos = class(TModelCustomObject, IModelAlunos)
    protected
      constructor Create(const Params: TBackendParams);
      function ListAll: TJsonArray;
      function ListByFoco(const id: integer): TJsonArray;
      function ListByGroup(const focoid: integer; const sigdis: string): TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function ListMemberMatricula(const matricula: string): TJsonObject;
    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IModelAlunos;
  end;


implementation

{ TModelAlunos }

constructor TModelAlunos.Create(const Params: TBackendParams);
begin
 inherited Create(Params);
end;

destructor TModelAlunos.Destroy;
begin
 inherited;
end;

function TModelAlunos.ListAll: TJsonArray;
begin
 Result := TDAOAlunos.New(Params).ListAll;
end;

function TModelAlunos.ListByFoco(const id: integer): TJsonArray;
begin
 Result := TDAOAlunos.New(Params).ListByFoco(id);
end;

function TModelAlunos.ListByGroup(const focoid: integer; const sigdis: string): TJsonArray;
begin
 Result := TDAOAlunos.New(Params).ListByGroup(focoid, sigdis);
end;

function TModelAlunos.ListMember(const id: integer): TJsonObject;
begin
 Result := TDAOAlunos.New(Params).ListMember(id);
end;

function TModelAlunos.ListMemberMatricula(const matricula: string): TJsonObject;
begin
 Result := TDAOAlunos.New(Params).ListMemberMatricula(matricula);
end;

class function TModelAlunos.New(const Params: TBackendParams): IModelAlunos;
begin
 result := self.Create(Params);
end;

end.
