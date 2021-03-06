unit horse.dao.connection.types;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils;

type
  //Define a assinatura do evento de tratamento de erro usando ADO
  TOnDBErrorEvent = procedure(ErrorInfo: string; ErrorSource: string;
    Command: string) of object;

  //Define a assinatura do evento de tratamento de erro de conectividade usando ADO
  TOnConnectErrorEvent = procedure(E: Exception; ErrorInfo: string; ErrorSource: string) of object;

  //Define a assinatura do evento de execu??o de um script usando ADO
  TOnExecuteCommandEvent = procedure(Command: string; Script: TStringList; E: Exception) of object;

implementation

end.
