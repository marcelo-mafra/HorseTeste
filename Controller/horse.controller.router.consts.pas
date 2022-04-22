unit horse.controller.router.consts;

interface

uses
 System.Classes;

type
 TEndPoints = class
   const
     Sample   = '/sample';
     Cliente  = '/clientes/:id';
     Clientes = '/clientes';
     Aluno    = '/alunos/:id';
     Alunos   = '/alunos';
     AlunosFoco    = '/alunos/focos/:id';
     AlunosFocoGroup    = '/alunos/group/:focoid/:groupid';
 end;

 TEndPointsFocos = class
   const
     Foco         = '/focos/:id';
     Focos        = '/focos';
     FocosParent  = '/focos/parent/:id';
     FocosRegions  = '/focos/regions/:id';

 end;

 TEndPointsRegions = class
   const
     Regions        = '/regions';
     RegionsParent  = '/regions/:id';
     RegionsMember  = '/regions/:id';
 end;

 TContentsTypes = class
   const
    Json = 'application/json';
    Html = 'text/html';
 end;

 TCustomPages = class
   const
     Basic = '<!DOCTYPE html><html><body><h1>backend horse inicializado com sucesso!</h1>' +
             '<p><h4>No Horse a data corrente é: %s.</h4></p></body></html>';
     Cliente = '<!DOCTYPE html><html><body><h1>Dados do cliente de Id: %d</h1>' +
             '<p></p></body></html>';
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
