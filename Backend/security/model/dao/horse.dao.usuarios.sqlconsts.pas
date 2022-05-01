unit horse.dao.usuarios.sqlconsts;

interface

uses
 System.Classes;

type
  TUsuariosCommands = class
    const
      ListAll      = 'select codcad, codusu, logusu, nomcad, apecad, matcad, ' +
          'sigfoc, sigdis, datnas, indati, indblo, indadm from VIW_USUARIOS';
      ListUser     = 'select codcad, codusu, logusu, nomcad, apecad, matcad, ' +
          'sigfoc, sigdis, datnas, indati, indblo, indadm from VIW_USUARIOS ' +
          'where codusu = :codusu';

  end;

implementation

end.
