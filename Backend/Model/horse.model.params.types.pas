unit horse.model.params.types;

interface

uses
 System.Classes;

 type
  //Abstrai um set de dados referente a cada task executada
  TModelTaskParams = record
    ThreadId: THandle;
    StartTime: TDateTime;
    EndTime: TDateTime;
  end;

  //Abstrai os par�metros de acesso a dados do servi�o local "Service NFe"
  TModelDataParams = record
    ConnectionString: string;
    ConnectionTimeout: integer;
    CommandTimeout: integer;
  end;

  //Abstrai os par�metros de timeouts de acesso a dados do servi�o local "Service NFe"
  TModelTimeouts = record
    ConnectionTimeout: integer;
    CommandTimeout: integer;
  end;

  //Abstrai os par�metros configur�veis (via arquivo ini) do servi�o local "Service NFe"
  TModelServiceParams = record
    ServiceName: string;
    CriticalLogs: string;
    ModelLogsFile: string;
    Data: TModelDataParams;
    Task: TModelTaskParams;
    Timeouts: TModelTimeouts;
  end;
  



implementation

end.
