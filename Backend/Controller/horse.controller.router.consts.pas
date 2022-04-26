unit horse.controller.router.consts;

interface

uses
 System.Classes;

type
 TEndPoints = class
   const
     Aluno          = '/alunos/:id';
     Alunos         = '/alunos';
     AlunosFoco     = '/alunos/focos/:id';
     AlunosFocoGroup = '/alunos/group/:focoid/:groupid';
 end;

 TEndPointsFocos = class
   const
     Foco         = '/focos/:id';
     Focos        = '/focos';
     FocosParent  = '/focos/parent/:id';
     FocosRegions  = '/focos/regions/:id';
     FocoDesativar = '/focos/:id/desativar';
     FocoReativar  = '/focos/:id/reativar';

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

 TCoreBackendInfo = class
   const
    HorseVersion = 'Versao corrente do módulo web "Horse": %s';
    Listenning   = 'Horse backend atendendo as requisicoes em %s';
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
