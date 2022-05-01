unit horse.dao.focos.sqlconsts;

interface

uses
 System.Classes;

type
  TFocosCommands = class
    const
      ListAll      = 'select codfoc, nomfoc, sigfoc, tipfoc, indati from FOCOS';
      ListFocosRegion   = 'select codfoc, nomfoc, sigfoc, tipfoc, indati, nomreg, nompai from VIW_FOCOS where codreg = :codreg';
      ListFocosParent   = 'select codfoc, nomfoc, sigfoc, tipfoc, indati, nomreg, codpai, nompai from VIW_FOCOS where codpai = :codpai';
      ListMember   = 'select codfoc, nomfoc, sigfoc, tipfoc, indati from FOCOS where codfoc = :codfoc';
      ListFocosStatus   = 'select codfoc, nomfoc, sigfoc, tipfoc, indati, nomreg, nompai from VIW_FOCOS where indati = :indati';
      ListFocosTipo   = 'select codfoc, nomfoc, sigfoc, tipfoc, indati, nomreg, nompai, tipfoc from VIW_FOCOS where codreg = :codreg and tipfoc = :tipfoc';
      DesativarFoco   = 'update FOCOS set indati = :indati where codfoc = :codfoc';
  end;

implementation

end.
