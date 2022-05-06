unit horse.controller.router.usuarios.consts;

interface

uses
 System.Classes;

type
 TUsuariosURI = class
   const
     Usuarios      = '/usuarios';
     Usuario       = '/usuarios/:id';
     Autenticar    = '/usuarios/autenticar';
 end;

implementation

end.
