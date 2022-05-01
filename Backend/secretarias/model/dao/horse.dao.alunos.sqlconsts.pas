unit horse.dao.alunos.sqlconsts;

interface

uses
 System.Classes;

type
  TAlunosCommands = class
    const
      ListAll      = 'select codcad, nomcad, matcad, sigdis from VIW_CADASTRADOS';
      ListByFoco   = 'select codcad, nomcad, matcad, sigdis from VIW_CADASTRADOS where codfoc = :codfoc';
      ListByGroup  = 'select codcad, nomcad, matcad, sigdis from VIW_CADASTRADOS where codfoc = :codfoc and sigdis = :sigdis';
      ListMember   = 'select codcad, nomcad, matcad, sigdis from VIW_CADASTRADOS where codcad = :codcad';
      ListMemberMatricula = 'select codcad, nomcad, matcad, sigdis from VIW_CADASTRADOS where matcad = :matcad';
  end;

implementation

end.
