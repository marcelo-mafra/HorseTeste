unit horse.service.params.consts;

interface

uses
 System.Classes;

type
  TServiceInfo = class
    const
     Service    = 'SERVICE';
     Module     = 'MODULE';
     ParamsFile = 'PARAMSFILE';
     Host       = 'HOST';
     Porta      = 'PORTA';
     Url        = 'URL';
     Data       = 'DATA';
  end;

  TServiceParamsFiles = class
    const
     Alunos      = 'alunos.ini';
     Focos       = 'focos.ini';
     Security    = 'cosmosec.ini';

  end;

implementation

end.
