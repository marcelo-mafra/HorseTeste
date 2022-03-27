unit nfe.localservice.dao.connection.interfaces;

interface

uses
  Winapi.Windows, System.Classes, Data.DB,
  //nfe units
  nfe.localservice.dao.datasets.interfaces;

type
  //Define o contrato de uma conexão abstrata para acesso a dados
  IAbstractConnection = interface
    ['{24A19252-8C2F-4BC4-875F-B6A644A94104}']
    function Connection : TCustomConnection;
    function CreateDataset(const Command: string): TDataset;
    procedure ExecuteScript(var Script: TStringList);
    procedure ExecuteCommand(const Command: string);
  end;

  //Define o contrato de uma conexão para acesso a dados usando ADO.
  INFEADOConnection = interface(IAbstractConnection)
    ['{4C1E4FF1-6F0B-4806-90CD-142357013D95}']
    function GetIDataset: IDataset;
    property Dataset: IDataset read GetIDataset;
  end;

  //Define o contrato de uma conexão para acesso a dados usando dbExpress
  INFEDBXConnection = interface(IAbstractConnection)
    ['{21BA58B4-CAE7-42EA-AE23-81A0E440E7FC}']
  end;

  //Define o contrato de uma conexão para acesso a dados usando Firedac
  INFEFiredacConnection = interface(IAbstractConnection)
    ['{C301A896-C54E-4278-8DD1-312E871A9564}']
  end;


implementation

end.
