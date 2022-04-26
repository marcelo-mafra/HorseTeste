unit horse.dao.focos.sqlconsts;

interface

uses
 System.Classes;

type
  TFocosCommands = class
    const
      ListAll      = 'select codfoc, nomfoc, sigfoc, tipfoc, indati from FOCOS';
      ListFocosRegion   = 'select codfoc, nomfoc, sigfoc, tipfoc, indati, nomreg, nompai from VIW_FOCOS where codreg = %d';
      ListFocosParent   = 'select codfoc, nomfoc, sigfoc, tipfoc, indati, nomreg, codpai, nompai from VIW_FOCOS where codpai = %d';
      ListMember   = 'select codfoc, nomfoc, sigfoc, tipfoc, indati from FOCOS where codfoc = %d';
      DesativarFoco   = 'update FOCOS set indati = :indati where codfoc = :codfoc';
  end;

implementation

end.
