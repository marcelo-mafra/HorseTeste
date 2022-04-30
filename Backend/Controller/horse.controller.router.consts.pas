unit horse.controller.router.consts;

interface

uses
 System.Classes;

type
 TEndPoints = class
   const
     Aluno          = '/alunos/:id';
     AlunoMatricula = '/alunos/matricula/:matricula';
     Alunos         = '/alunos';
     AlunosFoco     = '/alunos/focos/:id';
     AlunosFocoGroup = '/alunos/group/:focoid/:groupid';
 end;

 TEndPointsFocos = class
   const
     Foco          = '/focos/:id';
     Focos         = '/focos';
     FocosParent   = '/focos/parent/:id';
     FocosRegions  = '/focos/regions/:id';
     FocoDesativar = '/focos/:id/desativar';
     FocoReativar  = '/focos/:id/reativar';
     FocosStatus   = '/focos/status/:status';
     FocosTipo     = '/focos/tipos/:idregiao/:tipo';

 end;

 TEndPointsRegions = class
   const
     Regions        = '/regions';
     Region         = '/regions/:id';
     RegionsMember  = '/regions/members/:id';
 end;

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
    HorseVersion = 'Versao corrente do módulo web "Horse": %s';
    Listenning   = 'O service %s está atendendo as requisicoes em %s';
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
