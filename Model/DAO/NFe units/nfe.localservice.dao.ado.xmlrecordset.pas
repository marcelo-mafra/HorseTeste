unit nfe.localservice.dao.ado.xmlrecordset;

interface

uses
  System.Classes, System.SysUtils, Winapi.ADOInt, System.Win.ComObj,
  //nfe units
  nfe.localservice.dao.ado.xmlrecordset.interfaces;

type
  //Implementa IADOXmlRecordset para a conversão de objectos ADO Recordset para XML e vice-versa
  TADOXmlRecordset = class(TInterfacedObject, IADOXmlRecordset)
    private
      const
       OleObject = 'ADODB.Recordset'; //do not localize!

    protected
      constructor Create;
      function RecordsetToXML(const Recordset: _Recordset): string;
      function RecordsetFromXML(const XML: string): _Recordset;

    public
      destructor Destroy; override;
      class function New: IADOXmlRecordset;
  end;



implementation

constructor TADOXmlRecordset.Create;
begin
 inherited Create;
end;

destructor TADOXmlRecordset.Destroy;
begin
  inherited Destroy;
end;

class function TADOXmlRecordset.New: IADOXmlRecordset;
begin
 Result := self.Create;
end;

function TADOXmlRecordset.RecordsetToXML(const Recordset: _Recordset): string;
var
  RS: Variant;
  Stream: TStringStream;
begin
//Constrói conteúdo xml a partir de recordset ADO a partir de conteúdo xml recebido.
  if Recordset  = nil then Exit;
  Stream  :=  TStringStream.Create(EmptyStr);
  try
    RS  :=  CreateOleObject(OleObject);
    RS  :=  Recordset;
    RS.Save(TStreamAdapter.Create(stream) as IUnknown, adPersistXML);
    Stream.Position :=  0;
    Result  :=  Stream.DataString;
  finally
    Stream.Free;
  end;
end;

function TADOXmlRecordset.RecordsetFromXML(const XML: string): _Recordset;
var
  RS: Variant;
  Stream: TStringStream;
begin
//Constrói um recordset ADO a partir de conteúdo xml recebido
  Result  :=  nil;
  if XML  = EmptyStr then Exit;
  try
    Stream  :=  TStringStream.Create(XML);
    Stream.Position :=  0;
    RS  :=  CreateOleObject(OleObject);
    RS.Open(TStreamAdapter.Create(Stream) as IUnknown);
    Result  :=  IUnknown(RS) as _Recordset;
  finally
    if Assigned(Stream) then FreeAndNil(Stream);
  end;
end;

end.
