unit horse.dao.connection.interfaces;

interface

uses
  Winapi.Windows, System.Classes, Data.DB;

type
  //Define o contrato de uma conexão abstrata para acesso a dados
  IAbstractConnection = interface
    ['{24A19252-8C2F-4BC4-875F-B6A644A94104}']
    function Connection : TCustomConnection;
    function CreateDataset(const Command: string): TDataset; overload;
    function CreateDataset(const Command: string; const Params: TParams): TDataset; overload;
    procedure ExecuteScript(var Script: TStringList);
    procedure ExecuteCommand(const Command: string); overload;
    procedure ExecuteCommand(const Command: string; var Executed: boolean); overload;
    procedure ExecuteCommand(const Command: string; const Params: TParams); overload;

  end;


implementation

end.
