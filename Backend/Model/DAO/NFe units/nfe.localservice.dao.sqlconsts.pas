unit nfe.localservice.dao.sqlconsts;

interface

uses
 Winapi.Windows, System.Classes;

type
  //Caracteres especiais usados nos comandos SQL
  TSQLChars = class //do not localize!
    const
      //sql syntax
      CmdTerminator  = ';';
      NullChar       = 'null';
      //NFe consts
      InvalidNFeMark = 'i';
      ProcessedMark  = 'x';
      //datetime consts
      DateFmt        = 'yyyy/mm/dd';
      DateTimeFmt    = 'yyyy/mm/dd hh:nn:ss';
      DateSep        = '/'; //separador de datas
      //number consts
      DecSep         = '.'; //separador de decimal
      ThousandSep    = '*'; //separador de milhar
  end;

  //Comandos referentes à escrita de LOGS
  TLogsCommands = class  //do not localize!
    const
     MaxLength = 1024; //comprimento máximo da mensagem de log
     MaxCmdLength = 3072; //comprimento máximo dos comandos envolvidos no log
     NewLog    = 'insert into LOGS (id, text, data, tipo, sistema, className, threadId, command, source, chavenfe) ' +
        'values (logs_seq.NEXTVAL, %s, LOCALTIMESTAMP, %s, %s, %s, %d, %s, %s, %s)';
  end;

  //Status da NFe
  TNFEIStatus = class
    const
     Completed      = 0;
     Summarized     = 1;
     Indetermined   = 4;
     Pending        = 5; //nfe  pendente (possui pendências a serem sanadas)
  end;

  //Id de pendências que impedem o processamento da NFe
  TNFEIPendencieMark = class //do not localize!
    const
     IncompletedMapping   = '0';
     InvalidXml           = '1';
     TipoServico          = '2';
     InvalidDoc           = '3';
     InvalidNFeObject     = '4';
     EmptyCompanies       = '5';
     SitUnknownCompanies  = '6';
     SitUnknownToraBranch = '7';
     EndedFatalFailure    = '8';
     ReadMemoryProcess    = '9';
  end;

  {Valores "default" usados em alguns métodos. TOdos esses valores são
  hardcodded definidos pelo time Tora}
  TNFeDefValues = class //do not localize!
    const
     PaisCode  = '1058';
     ProdTipo  = 'M';
     NewNFEObs = 'BAIXADO VIA XML POR SERVICO';
  end;

  //Fields do table NFE_IMAGEM
  TNFEIFields = class //do not localize!
    const
     ID         = 'NFEI_SEQ';
     Chave      = 'NFEI_CHAVE';
     CodFab     = 'CG_COD';
     CodProd    = 'COD_PROD';
     FilCod     = 'FIL_COD';
     LocFab     = 'LOC_COD';
     LocProd    = 'LOC_PROD';
     OrgCod     = 'ORG_COD';
     PcaCod     = 'PCA_COD';
     ToraBranch = 'CE_USUARIO';
     Xml        = 'NFEI_XML';
  end;

  //Comandos relacionados a TNFEObject
  TSQLNFEI = class //do not localize!
   const
    FilaNFEI //Monta a lista de nfe's ainda não processadas
      = 'select nfei_seq, nfei_chave, nfei_xml from USU_CENTRAL.NFE_IMAGEM ' +
        'where NFEI_PROCESSADO is null and NFEI_PENDENTE is null and  ROWNUM <= 10'; //10 registros por vez
    EmpresasTora
      = 'select ce_usuario, ce_cnpj_raiz from USU_CENTRAL.CNPJ_EMPRESA where ' +
        'ce_cnpj_raiz = %s';
    DetalhesNFEI //Busca dados adicionais de uma nfe
      = 'select nfei_seq, nfei_chave, nfei_xml from USU_CENTRAL.NFE_IMAGEM ' +
        'where nfei_seq = %f';
    NfeiProcessada //Marca algumas colunas do table NFE_IMAGEM para sinalizar que houve processamento
      = 'UPDATE USU_CENTRAL.NFE_IMAGEM SET NFEI_PROCESSADO = %s, NFEI_DATA_PROC = SYSTIMESTAMP, ' +
        'NFEI_STATUS = %d, NFEI_PENDENTE = null WHERE NFEI_SEQ = %s';// %f'; (pedido do jonathan em função da config do oracle dele)
    NfeiPendente //Marca algumas colunas do table NFE_IMAGEM para sinalizar que houve processamento com pendências
      = 'UPDATE USU_CENTRAL.NFE_IMAGEM SET NFEI_PROCESSADO = %s, NFEI_DATA_PROC = SYSTIMESTAMP, ' +
        'NFEI_STATUS = %d, NFEI_PENDENTE = %s WHERE NFEI_SEQ = %s';// %f'; (pedido do jonathan em função da config do oracle dele)
    DestExiste
      = 'SELECT PCA.FIL_COD, Pca.ORG_COD, PCa.PCA_COD, Org.ORG_RAZAO_SOCIAL FROM ' +
        '%s.PRACA Pca, %s.ORGANIZACAO Org WHERE Pca.ORG_COD = Org.ORG_COD AND Pca.FIL_COD = ' +
        'Org.FIL_COD AND PCA_DOC_FEDERAL = %s';
    DestInfo
      = 'SELECT FIL_COD,ORG_COD,PCA_COD FROM %s.PRACA WHERE PCA_DOC_FEDERAL = %s';
    EmitExiste
      = 'SELECT PCA.FIL_COD, Pca.ORG_COD, PCa.PCA_COD, Org.ORG_RAZAO_SOCIAL FROM ' +
        '%s.PRACA Pca, %s.ORGANIZACAO Org WHERE Pca.ORG_COD = Org.ORG_COD AND Pca.FIL_COD = ' +
        'Org.FIL_COD AND PCA_DOC_FEDERAL = %s';
    EmitInfo
      = 'SELECT FIL_COD,ORG_COD,PCA_COD FROM %s.PRACA WHERE PCA_DOC_FEDERAL = %s';
    FabrExiste
      = 'SELECT DISTINCT A.LOC_COD, A.CG_COD, B.CG_NOME FROM CG_IDENTIFICACAO A, CADASTRO_GERAL B   ' +
        'WHERE A.LOC_COD = B.LOC_COD  AND A.CG_COD = B.CG_COD AND B.CG_TIPO_PESSOA = ''J'' AND SUBSTR(A.CGI_NUM,1,8) = %s';
    FabrInfo
      = 'SELECT DISTINCT A.LOC_COD, A.CG_COD, B.CG_NOME FROM CG_IDENTIFICACAO A, ' +
        'CADASTRO_GERAL B WHERE A.LOC_COD = B.LOC_COD AND A.CG_COD = B.CG_COD ' +
        'AND B.CG_TIPO_PESSOA = ''J'' AND SUBSTR(A.CGI_NUM,1,8) = %s';

    MunicipioExiste
      = 'SELECT CID.CID_COD, CID.CID_NOM, CID.COD_IBGE, EST.UF_SIGLA, PAI.PAI_COD, ' +
        'PAI.PAI_SIGLA FROM CIDADE CID, ESTADO EST, PAIS PAI WHERE CID.UF_COD = EST.UF_COD ' +
        'AND CID.PAI_COD = PAI.PAI_COD AND CID.COD_IBGE = %s' ;
    ProdExiste
      = 'SELECT cod_prod, prod_ref, loc_prod FROM USU_CENTRAL.PRODUTO WHERE PROD_REF = %s AND COD_FAB = %s';
    ProdInsert
      = 'INSERT into USU_CENTRAL.PRODUTO (COD_PROD, PROD_REF, DSC_PROD, LOC_PROD, LOC_USR, ' +
        'COD_USR, UND_COD, STF_COD, PROD_TIPO, TP_DESP_COD, PROD_DT_CADASTRO, ' +
        'PROD_NCM, LOC_FAB, COD_FAB) ' +
        'values (%s, %s, %s, 0, 1, 1001, 1, 19, %s, 200, SYSTIMESTAMP, %s, %s, %s)';
    ProdNewId
      = 'SELECT USU_CENTRAL.PRODUTO_SEQ.NEXTVAL AS NEWID FROM DUAL';
    NFeExiste
      = 'SELECT NF_CHAVE FROM %s.NOTA_FISCAL WHERE NF_CHAVE = %s';
    NFeInsert
      = 'INSERT INTO %s.NOTA_FISCAL ' +
        '(NF_CHAVE, MDA_COD, NF_M3, USR_COD, NF_ULT_TT, NF_DISTRIBUICAO, MDF_COD, ' +
        'NF_DT_EMISSAO, NF_DT_SAIDA, NF_OBS, NF_SERIE, NF_QTD, NF_PES_LIQ, NF_PES_BRUTO, ' +
        'NF_CFOP, NF_BASE_CALC, NF_VLR_ICMS, NF_NUM_NF, ' +
        'NF_DT_MAXIMA, NF_ALIQ, FIL_COD, ORG_COD, PCA_COD, PRA_FIL_COD, PRA_ORG_COD, ' +
        'PRA_PCA_COD, NF_IDENTIFICADOR, NF_VLR_TOTAL) ' +
        'VALUES (%s, 0, 0, 101010, 1, 2, 31, %s, %s, %s, %s, %u, %n, %n, %s, %n, ' +
        '%s, %s, %s, %s, %u, %u, %u, %u, %u, %u, %s, %n)';
    ItemNFeInsert
      = 'INSERT INTO %s.ITEM_NF ' +
        '(FIL_COD, ORG_COD, PCA_COD, NF_NUM_NF, USR_COD, INF_EMBALAGEM, INF_INDIVIDUALIZAR, ' + 
        'UND_COD, INF_VLR_UNI, INF_TOT_ITEM, INF_VLR_IMP, INF_BASE_CALC, INF_PES_LIQUIDO, ' +
        'INF_PES_BRUTO, INF_QUANTIDADE, INF_NUM, FIL_PROD, COD_PROD) ' +
        'VALUES ' +
        '(%u, %u, %u, %s, 101010, ''P'', ''N'', %u, %s, %s,  %s, %n, %n, %n, %n, %u, %n, %s)';
    TransitTimeInsert
      = 'INSERT INTO %s.TRANSIT_TIME ' +
        '(FIL_COD, ORG_COD, PCA_COD, NF_NUM_NF, TT_COD, ETT_COD, USR_COD, ' +
        'TT_DT_HR_INICIO, TT_DT_HR_OPER) ' +
        'VALUES (%d, %u, %u, %s, 1, 5, 101010, %s, SYSTIMESTAMP)';

  end;



implementation

end.
