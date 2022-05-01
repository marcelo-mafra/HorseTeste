unit horse.controller.router.consts;

interface

uses
 System.Classes;

type
 TContentsTypes = class
   const
    Json = 'application/json';
    Html = 'text/html';
 end;

 TBackendInfo = class
   const
    SvcAlunos      = 'Cosmos Alunos';
    SvcFocos       = 'Cosmos Focos';
    Starting       = 'Inicializando o service %s...';
    HorseVersion   = 'Versao corrente do módulo web "Horse": %s';
    ParamsInfo     = 'Service: %s - ParamsFile: %s';
    Listenning     = 'O service %s está atendendo as requisicoes em %s';
 end;

 TClientsParams = class
   const
    id     = 'id';
    nome   = 'nome';
    time   = 'time';
    bool   = 'verdadeiro';
    number = 'number';
 end;

implementation

end.
