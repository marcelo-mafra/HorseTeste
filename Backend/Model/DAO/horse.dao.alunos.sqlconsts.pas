unit horse.dao.alunos.sqlconsts;

interface

uses
 System.Classes;

type
  TAlunosCommands = class
    const
      ListAll      = 'select codcad, nomcad, matcad from CADASTRADOS';
      ListByFoco   = 'select codcad, nomcad, matcad from CADASTRADOS where codfoc = :codfoc';
      ListByGroup  = 'select codcad, nomcad, matcad from CADASTRADOS where codfoc = %d and coddis = %d';
      ListMember   = 'select codcad, nomcad, matcad from CADASTRADOS where codcad = :codcad';
      ListMemberMatricula = 'select codcad, nomcad, matcad from CADASTRADOS where matcad = :matcad';
  end;

implementation

end.
