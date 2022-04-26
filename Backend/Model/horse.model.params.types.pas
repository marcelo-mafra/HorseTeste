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

  //Abstrai os parâmetros de acesso a dados do serviço local "Service NFe"
  TModelDataParams = record
    ConnectionString: string;
    ConnectionTimeout: integer;
    CommandTimeout: integer;
  end;

  //Abstrai os parâmetros de timeouts de acesso a dados do serviço local "Service NFe"
  TModelTimeouts = record
    ConnectionTimeout: integer;
    CommandTimeout: integer;
  end;

  //Abstrai os parâmetros configuráveis (via arquivo ini) do serviço local "Service NFe"
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
