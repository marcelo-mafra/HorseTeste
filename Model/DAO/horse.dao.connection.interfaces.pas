unit horse.dao.connection.interfaces;

interface

uses
  Winapi.Windows, System.Classes, Data.DB,
  //horse units
  horse.dao.datasets.interfaces;

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
  IHorseADOConnection = interface(IAbstractConnection)
    ['{4C1E4FF1-6F0B-4806-90CD-142357013D95}']
    function GetIDataset: IDataset;
    property Dataset: IDataset read GetIDataset;
  end;


implementation

end.
