unit nfe.localservice.dao.datasets.ado;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, System.Variants, Data.DB,
  Data.Win.ADODB,
  //NFe units...
  nfe.localservice.dao.datasets.interfaces,
  nfe.localservice.dao.datasets.ado.consts,
  nfe.localservice.dao.exceptions;

type
  TADOIDataset = class(TInterfacedObject, IDataset)
    private
     FADODataset: TADODataset;
     function GetInnerDataset: TADODataset;
     procedure DoCreateObjects(Connection: TADOConnection); inline;
     procedure DoDestroyObjects; inline;

    protected
     constructor Create(Connection: TADOConnection);
     //IDataset
     function IsEmpty: boolean;
     function Open(const Command: string): IDataset;
     function Value(const FieldName: string): variant;

    public
     destructor Destroy; override;
     class function New(Connection: TCustomConnection): IDataset; overload;
     class function New: IDataset; overload;
     property InnerDataset: TADODataset read GetInnerDataset;
  end;

implementation

{ TADOIDataset }

constructor TADOIDataset.Create(Connection: TADOConnection);
begin
 inherited Create;
 DoCreateObjects(Connection);
end;

destructor TADOIDataset.Destroy;
begin
  DoDestroyObjects;
  inherited Destroy;
end;

class function TADOIDataset.New: IDataset;
begin
 //método factory usado apenas para escrever arquivos xml com ADO
 Result := self.Create(nil);
end;

class function TADOIDataset.New(Connection: TCustomConnection): IDataset;
begin
 if ((Connection = nil) or not (Connection is TADOConnection)) then
  raise EInvalidConnectionObject.Create(TADODatasetConsts.InvalidConnection);

 Result := self.Create(TADOConnection(Connection));
end;

procedure TADOIDataset.DoCreateObjects(Connection: TADOConnection);
begin
 if not Assigned(FADODataset) then
  begin
   FADODataset := TADODataset.Create(nil);
   FADODataset.Connection := Connection;
  end;
end;

procedure TADOIDataset.DoDestroyObjects;
begin
 if Assigned(FADODataset) then
  begin
   try
     if FADODataset.Active then FADODataset.Close;
     FADODataset.Connection := nil;
   finally
     FreeAndNil(FADODataset);
   end;
  end;
end;

function TADOIDataset.GetInnerDataset: TADODataset;
begin
 if (not Assigned(FADODataset) or not (FADODataset.Active)) then
  raise EInvalidDatasetState.Create(TADODatasetConsts.InvalidState);
 Result := FADODataset;
end;

function TADOIDataset.IsEmpty: boolean;
begin
 Result := InnerDataset.IsEmpty;
end;

function TADOIDataset.Open(const Command: string): IDataset;
begin
 try
   if FADODataset.Active then FADODataset.Close;
   self.InnerDataset.CommandText := Command;
   self.InnerDataset.Open;
 finally
   Result := self;
 end;
end;

function TADOIDataset.Value(const FieldName: string): variant;
begin
 Result := Unassigned;
 if InnerDataset.FindField(FieldName) <> nil then
  Result := InnerDataset.Fields.FieldByName(FieldName).Value; 
end;

end.
