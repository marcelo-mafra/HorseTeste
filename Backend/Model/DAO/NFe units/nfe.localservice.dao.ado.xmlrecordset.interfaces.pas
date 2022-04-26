unit nfe.localservice.dao.ado.xmlrecordset.interfaces;

interface

uses
  System.Classes, Winapi.ADOInt;

type
  //Abstrai métodos de conversão de objectos ADO Recordset para XML e vice-versa
  IADOXmlRecordset = interface
    ['{5E1365B0-65E6-44BE-9BBB-F28839E1DFD4}']
    function RecordsetToXML(const Recordset: _Recordset): string;
    function RecordsetFromXML(const XML: string): _Recordset;
  end;

implementation

end.
