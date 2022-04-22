unit horse.model.alunos;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON,
  horse.dao.alunos.datasets, horse.service.params.types,
  horse.model.alunos.interfaces ;

type
  TModelAlunos = class(TInterfacedObject, IModelAlunos)
    private
      FParams: TBackendParams;
    protected
      constructor Create(const Params: TBackendParams);
      function ListAll: TJsonArray;
      function ListByFoco(const id: integer): TJsonArray;
      function ListByGroup(const focoid, groupid: integer): TJsonArray;
      function ListMember(const id: integer): TJsonObject;
    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IModelAlunos;
  end;


implementation

{ TModelAlunos }

constructor TModelAlunos.Create(const Params: TBackendParams);
begin
 inherited Create;
 self.FParams := Params;
end;

destructor TModelAlunos.Destroy;
begin
 inherited;
end;

function TModelAlunos.ListAll: TJsonArray;
begin
 Result := TDAOAlunos.New(FParams).ListAll;
end;

function TModelAlunos.ListByFoco(const id: integer): TJsonArray;
begin
 Result := TDAOAlunos.New(FParams).ListByFoco(id);
end;

function TModelAlunos.ListByGroup(const focoid, groupid: integer): TJsonArray;
begin
 Result := TDAOAlunos.New(FParams).ListByGroup(focoid, groupid);
end;

function TModelAlunos.ListMember(const id: integer): TJsonObject;
begin
 Result := TDAOAlunos.New(FParams).ListMember(id);
end;

class function TModelAlunos.New(const Params: TBackendParams): IModelAlunos;
begin
 result := self.Create(Params);
end;

end.
