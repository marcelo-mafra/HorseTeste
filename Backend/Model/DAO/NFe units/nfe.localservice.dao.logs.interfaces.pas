unit nfe.localservice.dao.logs.interfaces;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils,
  //NFe units...
  nfe.localservice.model.logs.types,
  nfe.localservice.dao.connection.interfaces;

type
  //Abstrai a escrita de logs a nível da camada DAO.
  INFEDAOLogs = interface
   ['{1328FC77-412F-4F47-9332-067BC8206A64}']
   procedure RegisterLog(Data: TLogData); overload;
   procedure RegisterLog(Data: TLogData; E: Exception); overload;  
   procedure RegisterLog(Data: TLogData; iConnection: IAbstractConnection); overload;

  end;

  //Abstrai a escrita de logs em arquivos a nível da camada DAO.
  INFEDAOFileLogs = interface
   ['{DDE36B4A-B836-4D44-9EB2-47776A3EF027}']
   procedure RegisterLog(Data: TLogData); overload;
  end;


implementation

end.
