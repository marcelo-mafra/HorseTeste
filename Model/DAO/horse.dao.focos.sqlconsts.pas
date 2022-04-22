unit horse.dao.focos.sqlconsts;

interface

uses
 System.Classes;

type
  TFocosCommands = class
    const
      ListAll      = 'select codfoc, nomfoc, sigfoc from FOCOS';
      ListFocosRegion   = 'select codfoc, nomfoc, sigfoc, nomreg, nompai from VIW_FOCOS where codreg = %d';
      ListFocosParent   = 'select codfoc, nomfoc, sigfoc, nomreg, codpai, nompai from VIW_FOCOS where codpai = %d';
      ListMember   = 'select codfoc, nomfoc, sigfoc from FOCOS where codfoc = %d';
  end;

implementation

end.
