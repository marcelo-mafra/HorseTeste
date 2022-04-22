unit horse.dao.regioes.sqlconsts;

interface

uses
 System.Classes;

type
  TRegioesCommands = class
    const
      ListMember        = 'select codreg, nomreg, codpai from REGIOES where codreg = %d';
      ListRegions       = 'select codreg, nomreg, codpai from REGIOES where codpai is null ';
      ListRegionsParent = 'select codreg, nomreg, codpai from REGIOES where codpai = %d';
      NewRegion         = 'insert into REGIOES (nomreg, codpai) values (%s, null)';
      NewSubregion      = 'insert into REGIOES (nomreg, codpai) values (%s, %d)';
      AlterSubregion    = 'update REGIOES set nomreg = %s, codpai = %s where codreg = %d';
  end;

implementation

end.
