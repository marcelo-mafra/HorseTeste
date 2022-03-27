unit nfe.localservice.dao.logs.consts;

interface

uses
  Winapi.Windows, System.Classes;

type
    //Constantes usadas na geraçã ode log críticos
    TFileLogsConst = class
      const
        NewFile       = 'SERVICE_NFE_%d.xml';
        CriticalError = 'ERRO CRÍTICO';
    end;

    //Campos disponíveis referentes à criação de logs crpiticos (em arquivos)
    TFileLogsFields = class //do not localize!
      const
        LOG       = 'LOG';
        DATA      = 'DATA';
        TIPO      = 'TIPO';
        CLASSNAME = 'CLASSNAME';
        INNERMSG  = 'INNERMSG';
    end;

implementation

end.
