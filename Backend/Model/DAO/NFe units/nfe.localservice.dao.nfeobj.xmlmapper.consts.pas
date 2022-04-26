unit nfe.localservice.dao.nfeobj.xmlmapper.consts;

interface

uses
  Winapi.Windows, System.Classes;

type
  //Nomes das tags existentes no conte�do xml das nfes
  TXmlTags = class //do not localize!
    const
     Root    = 'NFe';
     InfoNfe = 'infNFe';
     Ide     = 'ide';
     //tags da se��o destinat�rio e emitentes
     Dest    = 'dest';
     Emit    = 'emit';
     Cnpj    = 'CNPJ';
     EndEmit = 'enderEmit';
     EndDest = 'enderDest';
     Pais    = 'cPais';
     MunCode = 'cMun';
     //tags da se��o "transporte"
     Transp  = 'transp';
     Transporta = 'transporta';
     TranspCnpj = 'CNPJ';
     TranspNome = 'xNome';
     InfAdic    = 'infAdic';
     InfCpl     = 'infCpl';
     //Tags da se��o "produtos"
     ProdMk  = 'det';
     ProdId  = 'nItem';
     ProdTag = 'prod';
     ProdCod = 'cProd';
     ProdName= 'xProd';
     ProdNCM = 'NCM';
     ProdTot = 'vProd';
     ProdUnit= 'vUnCom';
     ProdQcom= 'qCom';
     ProdUCom= 'uCom';
     //tags da se��o "header da NFe"
     dEmi    = 'dEmi';
     dhEmi   = 'dhEmi';
     NumNF   = 'nNF';
     Serie   = 'serie';
     dSaida  = 'dSaiEnt';
     dhSaida = 'dhSaiEnt';
     hSaida  = 'hSaiEnt';
     //tags da se��o "Info do ve�culo"
     qtVol   = 'qVol';
     Volumes = 'vol';
     PesoLq  = 'pesoL';
     PesoBr  = 'pesoB';
     //tags da se��o Taxes
     Total   = 'total';
     ICMSTot = 'ICMSTot';
     BC      = 'vBC';
     pICMS   = 'pICMS';
     vICMS   = 'vICMS';
     vNF     = 'vNF';
     Cfop    = 'CFOP';

  end;
  //caracteres de formata��o de datas, n�meros etc de conte�dos XML
  TXmlFormatChars = class
    const
      DateFmt = 'yyyy-mm-dd';
      DateSep = '-';
      DecSep  = '.';
      ThouSep = ',';
  end;  

implementation

end.
