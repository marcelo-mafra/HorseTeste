unit horse.dao.regioes.sqlconsts;

interface

uses
 System.Classes;

type
  TRegioesCommands = class
    const
      ListMember        = 'select codreg, nomreg, codpai from REGIOES where codreg = :codreg';
      ListRegions       = 'select codreg, nomreg, codpai from REGIOES where codpai is null ';
      ListRegionsParent = 'select codreg, nomreg, codpai from REGIOES where codpai = %d';
      NewSubregion      = 'insert into REGIOES (nomreg, codpai) values (:nomreg, :codpai)';
      AlterSubregion    = 'update REGIOES set nomreg = :nomreg, codpai = :codpai where codreg = :codreg';
      RegiaoEmUso
          = 'select distinct(REGIOES.codreg) from REGIOES where ' +
            'REGIOES.codreg = %d or REGIOES.codpai = %d union ' +
            'select distinct(FOCOS.codreg) from FOCOS where FOCOS.codreg = %d';
      DeleteRegion      = 'delete REGIOES where codreg = %d';
  end;

  {
   select distinct(REGIOES.codreg) from REGIOES
where REGIOES.codreg = 6999 or REGIOES.codpai = 1909
union
select distinct(FOCOS.codreg) from FOCOS where FOCOS.codreg = 6


  }

implementation

end.
