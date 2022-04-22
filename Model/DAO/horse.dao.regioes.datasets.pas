unit horse.dao.regioes.datasets;

interface

uses
 System.Classes, System.JSON, Data.DB, System.SysUtils,
 horse.dao.regioes.sqlconsts, horse.service.params.types,
 horse.dao.regioes.interfaces, horse.dao.connection.factory,
  horse.model.regioes.exceptions;

type
  TDAORegioes = class(TInterfacedObject, IDAORegioes)
    private
      FParams: TBackendParams;

    protected
      constructor Create(const Params: TBackendParams);
      //IDAORegioes
      function ListRegions: TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function ListRegionsParent(const id: integer): TJsonArray;
      function NewRegion(obj: TJsonObject): IDAORegioes;
      function UpdateRegion(obj: TJsonObject): TJsonObject;

    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IDAORegioes;
  end;

implementation

{ TDAORegioes }

constructor TDAORegioes.Create(const Params: TBackendParams);
begin
 FParams := Params;
end;

destructor TDAORegioes.Destroy;
begin

end;

class function TDAORegioes.New(const Params: TBackendParams): IDAORegioes;
begin
 Result := self.Create(Params);
end;

function TDAORegioes.NewRegion(obj: TJsonObject): IDAORegioes;
var
 sCommand: string;
 sRegiao, sParent: string;
 ParentId: integer;
begin
 Result := self;
 if Result <> nil then
  begin
   sRegiao := obj.GetValue<string>('regiao');
   sParent := obj.GetValue<string>('parent');
   if sRegiao.Trim = string.Empty then
     raise EInvalidRegionName.Create;

   if (sParent.Trim <> string.Empty) and (tryStrToInt(sParent, ParentId)) then
    begin
     sCommand := string.Format(TRegioesCommands.NewSubregion, [sRegiao.QuotedString, ParentId]);
     TConnectionFactory.New(FParams.ConnectionStr).ExecuteCommand(sCommand);
    end;

   if (sParent.Trim = string.Empty) then
    begin
     sCommand := string.Format(TRegioesCommands.NewRegion, [sRegiao.QuotedString]);
     TConnectionFactory.New(FParams.ConnectionStr).ExecuteCommand(sCommand);
    end;
  end;
end;

function TDAORegioes.UpdateRegion(obj: TJsonObject): TJsonObject;
var
 sCommand: string;
 sRegiao, sParent: string;
 id: integer;
begin
 Result := obj;
 if Result <> nil then
  begin
   id      := obj.GetValue<integer>('codigo');
   sRegiao := obj.GetValue<string>('regiao');
   sParent := obj.GetValue<string>('parent');
   if sRegiao.Trim = string.Empty then
     raise EInvalidRegionName.Create;

   if sParent.IsEmpty then sParent := 'null'
   else sParent := sParent.QuotedString;

   sCommand := string.Format(TRegioesCommands.AlterSubregion, [sRegiao.QuotedString, sParent, id]);
   TConnectionFactory.New(FParams.ConnectionStr).ExecuteCommand(sCommand);
  end;

end;

function TDAORegioes.ListMember(const id: integer): TJsonObject;
var
 sCommand: string;
 Ds: TDataset;
begin
 sCommand := string.Format(TRegioesCommands.ListMember, [id]);
 Ds := TConnectionFactory.New(FParams.ConnectionStr).CreateDataset(sCommand);
 Result := TJSonObject.Create;
 Result.AddPair('codigo', Ds.Fields.FieldByName('codreg').AsString);
 Result.AddPair('regiao', Ds.Fields.FieldByName('nomreg').AsString);
 Result.AddPair('parent', Ds.Fields.FieldByName('codpai').AsString);
end;

function TDAORegioes.ListRegions: TJsonArray;
var
 Command: string;
 Ds: TDataset;
 JsonObj: TJSonObject;
begin
 Command := TRegioesCommands.ListRegions;
 Ds := TConnectionFactory.New(FParams.ConnectionStr).CreateDataset(Command);
 Result := TJsonArray.Create;
 while not Ds.Eof do
  begin
   JsonObj := TJSonObject.Create;
   JsonObj.AddPair('codigo', Ds.Fields.FieldByName('codreg').AsString);
   JsonObj.AddPair('regiao', Ds.Fields.FieldByName('nomreg').AsString);
   JsonObj.AddPair('parent', Ds.Fields.FieldByName('codpai').AsString);
   Result.AddElement(JsonObj);
   Ds.Next;
  end;

end;

function TDAORegioes.ListRegionsParent(const id: integer): TJsonArray;
var
 Command: string;
 Ds: TDataset;
 JsonObj: TJSonObject;
begin
 Command := string.Format(TRegioesCommands.ListRegionsParent, [id]);
 Ds := TConnectionFactory.New(FParams.ConnectionStr).CreateDataset(Command);
 Result := TJsonArray.Create;
 while not Ds.Eof do
  begin
   JsonObj := TJSonObject.Create;
   JsonObj.AddPair('codigo', Ds.Fields.FieldByName('codreg').AsString);
   JsonObj.AddPair('regiao', Ds.Fields.FieldByName('nomreg').AsString);
   JsonObj.AddPair('parent', Ds.Fields.FieldByName('codpai').AsString);
   Result.AddElement(JsonObj);
   Ds.Next;
  end;

end;

end.
