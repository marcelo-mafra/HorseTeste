unit nfe.localservice.dao.nfeobj.xmlmapper.consts;

interface

uses
  Winapi.Windows, System.Classes;

type
  //Nomes das tags existentes no conteúdo xml das nfes
  TXmlTags = class //do not localize!
    const
     Root    = 'NFe';
     InfoNfe = 'infNFe';
     Ide     = 'ide';
     //tags da seção destinatário e emitentes
     Dest    = 'dest';
     Emit    = 'emit';
     Cnpj    = 'CNPJ';
     EndEmit = 'enderEmit';
     EndDest = 'enderDest';
     Pais    = 'cPais';
     MunCode = 'cMun';
     //tags da seção "transporte"
     Transp  = 'transp';
     Transporta = 'transporta';
     TranspCnpj = 'CNPJ';
     TranspNome = 'xNome';
     InfAdic    = 'infAdic';
     InfCpl     = 'infCpl';
     //Tags da seção "produtos"
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
     //tags da seção "header da NFe"
     dEmi    = 'dEmi';
     dhEmi   = 'dhEmi';
     NumNF   = 'nNF';
     Serie   = 'serie';
     dSaida  = 'dSaiEnt';
     dhSaida = 'dhSaiEnt';
     hSaida  = 'hSaiEnt';
     //tags da seção "Info do veículo"
     qtVol   = 'qVol';
     Volumes = 'vol';
     PesoLq  = 'pesoL';
     PesoBr  = 'pesoB';
     //tags da seção Taxes
     Total   = 'total';
     ICMSTot = 'ICMSTot';
     BC      = 'vBC';
     pICMS   = 'pICMS';
     vICMS   = 'vICMS';
     vNF     = 'vNF';
     Cfop    = 'CFOP';

  end;
  //caracteres de formatação de datas, números etc de conteúdos XML
  TXmlFormatChars = class
    const
      DateFmt = 'yyyy-mm-dd';
      DateSep = '-';
      DecSep  = '.';
      ThouSep = ',';
  end;  

implementation

end.
