unit nfe.localservice.dao.logs.consts;

interface

uses
  Winapi.Windows, System.Classes;

type
    //Constantes usadas na gera�� ode log cr�ticos
    TFileLogsConst = class
      const
        NewFile       = 'SERVICE_NFE_%d.xml';
        CriticalError = 'ERRO CR�TICO';
    end;

    //Campos dispon�veis referentes � cria��o de logs crpiticos (em arquivos)
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
