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

implementation

end.
