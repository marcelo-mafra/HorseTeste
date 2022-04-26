unit horse.dao.alunos.sqlconsts;

interface

uses
 System.Classes;

type
  TAlunosCommands = class
    const
      ListAll      = 'select codcad, nomcad, matcad from CADASTRADOS';
      ListByFoco   = 'select codcad, nomcad, matcad from CADASTRADOS where codfoc = %d';
      ListByGroup  = 'select codcad, nomcad, matcad from CADASTRADOS where codfoc = %d and coddis = %d';
      ListMember   = 'select codcad, nomcad, matcad from CADASTRADOS where codcad = %d';
  end;

implementation

end.
