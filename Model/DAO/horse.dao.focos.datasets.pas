unit horse.dao.focos.datasets;

interface

uses
 System.Classes, System.JSON, Data.DB, System.SysUtils,
 horse.dao.focos.sqlconsts, horse.service.params.types,
 horse.dao.focos.interfaces, horse.dao.connection.factory,
 horse.dao.regioes.interfaces;

type
  TDAOFocos = class(TInterfacedObject, IDAOFocos)
    private
      FParams: TBackendParams;

    protected
      constructor Create(const Params: TBackendParams);
      //IDAOFocos
      function ListAll: TJsonArray;
      function ListFocosParent(const id: integer): TJsonArray;
      function ListFocosRegion(const id: integer): TJsonArray;
      function ListMember(const id: integer): TJsonObject;
      function IRegioes: IDAORegioes;

    public
      destructor Destroy; override;
      class function New(const Params: TBackendParams): IDAOFocos;
  end;

implementation

{ TDAOFocos }

constructor TDAOFocos.Create(const Params: TBackendParams);
begin
 FParams := Params;
end;

destructor TDAOFocos.Destroy;
begin

end;

function TDAOFocos.IRegioes: IDAORegioes;
begin
 Result := self as IDAORegioes;
end;

class function TDAOFocos.New(const Params: TBackendParams): IDAOFocos;
begin
 Result := self.Create(Params);
end;

function TDAOFocos.ListAll: TJsonArray;
var
 Ds: TDataset;
 JsonObj: TJSonObject;
begin
 Ds := TConnectionFactory.New(FParams.ConnectionStr).CreateDataset(TFocosCommands.ListAll);
 Result := TJsonArray.Create;
 while not Ds.Eof do
  begin
   JsonObj := TJSonObject.Create;
   JsonObj.AddPair('codigo', Ds.Fields.FieldByName('codfoc').AsString);
   JsonObj.AddPair('nome', Ds.Fields.FieldByName('nomfoc').AsString);
   JsonObj.AddPair('sigla', Ds.Fields.FieldByName('sigfoc').AsString);
   Result.AddElement(JsonObj);
   Ds.Next;
  end;
end;

function TDAOFocos.ListFocosParent(const id: integer): TJsonArray;
var
 Command: string;
 Ds: TDataset;
 JsonObj: TJSonObject;
begin
 Command := string.Format(TFocosCommands.ListFocosParent, [id]);
 Ds := TConnectionFactory.New(FParams.ConnectionStr).CreateDataset(Command);
 Result := TJsonArray.Create;
 while not Ds.Eof do
  begin
   JsonObj := TJSonObject.Create;
   JsonObj.AddPair('codigo', Ds.Fields.FieldByName('codfoc').AsString);
   JsonObj.AddPair('nome', Ds.Fields.FieldByName('nomfoc').AsString);
   JsonObj.AddPair('sigla', Ds.Fields.FieldByName('sigfoc').AsString);
   JsonObj.AddPair('regiao', Ds.Fields.FieldByName('nomreg').AsString);
   JsonObj.AddPair('codParent', Ds.Fields.FieldByName('codpai').AsString);
   JsonObj.AddPair('parent', Ds.Fields.FieldByName('nompai').AsString);
   Result.AddElement(JsonObj);
   Ds.Next;
  end;
end;

function TDAOFocos.ListFocosRegion(const id: integer): TJsonArray;
var
 Command: string;
 Ds: TDataset;
 JsonObj: TJSonObject;
begin
 Command := string.Format(TFocosCommands.ListFocosRegion, [id]);
 Ds := TConnectionFactory.New(FParams.ConnectionStr).CreateDataset(Command);
 Result := TJsonArray.Create;
 while not Ds.Eof do
  begin
   JsonObj := TJSonObject.Create;
   JsonObj.AddPair('codigo', Ds.Fields.FieldByName('codfoc').AsString);
   JsonObj.AddPair('nome', Ds.Fields.FieldByName('nomfoc').AsString);
   JsonObj.AddPair('sigla', Ds.Fields.FieldByName('sigfoc').AsString);
   JsonObj.AddPair('regiao', Ds.Fields.FieldByName('nomreg').AsString);
   JsonObj.AddPair('parent', Ds.Fields.FieldByName('nompai').AsString);
   Result.AddElement(JsonObj);
   Ds.Next;
  end;
end;

function TDAOFocos.ListMember(const id: integer): TJsonObject;
var
 sCommand: string;
 Ds: TDataset;
begin
 sCommand := string.Format(TFocosCommands.ListMember, [id]);
 Ds := TConnectionFactory.New(FParams.ConnectionStr).CreateDataset(sCommand);
 Result := TJSonObject.Create;
 Result.AddPair('codigo', Ds.Fields.FieldByName('codfoc').AsString);
 Result.AddPair('nome', Ds.Fields.FieldByName('nomfoc').AsString);
 Result.AddPair('matricula', Ds.Fields.FieldByName('sigfoc').AsString);
end;

end.
