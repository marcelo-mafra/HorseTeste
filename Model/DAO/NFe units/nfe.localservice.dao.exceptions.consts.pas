unit nfe.localservice.dao.exceptions.consts;

interface

uses
 Winapi.Windows, System.Classes;

type
  TDAOErrorMessages = class
    const
      ErrorInfo
          = 'Ocorreu um erro em uma opera��o de acesso ou escrita de dados. Detalhes: ' +
            'Source: %s. Description: %s.';
      InvalidConnection
          = 'N�o foi poss�vel criar o objeto que realiza a conex�o com o servidor ' +
          'de banco de dados';
      ExecCommandError
          = 'Ocorreu um erro fatal ao tentar executar um comando: mensagem: %s';
      ExecScriptError
          = 'Ocorreu um erro fatal ao tentar executar um script de comandos: mensagem: %s';
      UnexpectedDatasetError
          = 'Ocorreu um erro inesperado ao tentar executar a consulta: %s | Mensagem: %s';
      WillConnectError
          = 'Ocorreu um erro ao solicitar nova conex�o ao driver OLEDB. UserId: %s';
      EmptyCnpjDest
          = 'A ra�z do cnpj do destinat�rio n�o pode ser calculada a partir ' +
            'do CNPJ completo pois esse n�o foi informado (vazio).';
      InvalidCnpjDest
          = 'A ra�z do cnpj do destinat�rio n�o pode ser calculada a partir ' +
            'do CNPJ completo. CNPJ usado como par�metro da opera��o: %s';
      InvalidCnpjEmit
          = 'A ra�z do cnpj do emitente n�o pode ser calculada a partir ' +
            'do CNPJ completo. CNPJ usado como par�metro da opera��o: %s';
      InvalidCnpjFabr
          = 'A ra�z do cnpj do fabricante n�o pode ser calculada a partir ' +
            'do CNPJ completo. CNPJ usado como par�metro da opera��o: %s';
      UnknownCnpjDest
          = 'A ra�z do cnpj do destinat�rio n�o foi encontrada no banco de dados do SIT. ' +
            'Verifique o CNPJ completo usado para a opera��o. CNPJ usado como par�metro da opera��o: %s';
      UnknownCnpjEmit
          = 'A ra�z do cnpj do emitente n�o foi encontrada no banco de dados do SIT. ' +
            'Verifique o CNPJ completo usado para a opera��o. CNPJ usado como par�metro da opera��o: %s';
      UnknownCnpjFabr
          = 'A ra�z do cnpj do fabricante n�o foi encontrada no banco de dados do SIT. ' +
            'Verifique o CNPJ completo usado para a opera��o. CNPJ usado como par�metro da opera��o: %s';
      UnknownCnpjToraBranch
          = 'A ra�z do cnpj da empresa do grupo Tora respons�vel pela NFe n�o foi encontrada ' +
            'no banco de dados do SIT. Verifique os CNPJs do destinat�rio e do Transportador. ' +
            'O processamento da NFe foi abortado';
      InvalidTransportInfo
          = 'O tipo do servi�o n�o pode ser obtido no conte�do xml da NFe. Como ' +
            'consequ�ncia, os dados da transportadora n�o puderam ser lidos';
      XmlParserError
          = 'O parser MSXML3.DLL retornou um erro DOM (EDOMParseError) ao tentar validar parte do XML recebido. ' +
            'M�todo que disparou o erro: %s . Mensagem recebida do parser: %s';
  end;

  //Mensagens relacionadas � valida��o do status de cada NFe
  TDAOStatusValidationNFe = class
    const
      Completed
          = 'A nfe foi identificada como "completa" e possui todos os dados do servi�o prestado.';
      Summarized
          = 'A nfe foi identificada como "resumida", sem dados detalhados do servi�o prestado. ' +
            'O processamento da nfe ser� abortado.';
  end;

  //Mensagens relacionadas � valida��o do resultado do mapeamento O.R. de cada NFe
  TDAOMappingValidationNFe = class
    const
      Normal
          = 'O mapeamento objeto-relacional do objeto TNFEObject corrente foi feito com sucesso.';
      InvalidDbMapping
          = 'O mapeamento do objeto TNFEObject corrente n�o pode ser completado a partir de dados do banco de dados do SIT. ' +
            'O processamento da nfe poder� ser cancelado se os dados faltantes forem exigidos.';
      InvalidSchema
          = 'O mapeamento do objeto TNFEObject corrente n�o pode ser completado. O conte�do xml da nfe ' +
            'est� com o schema quebrado ou incompleto. O processamento da nfe n�o pode prosseguir e foi cancelado.' ;
  end;

  //Mensagens relacionadas �s valida��es envolvendo regras de neg�cio de cada NFe
  TDAOStatusNfeError = class
    const
      InvalidNfe
          = 'A nfe n�o possui informa��es do cnpj do emitente e/ou destinat�rio. ' +
            'N�o � poss�vel processar nfes sem dados centrais das empresas envolvidas.';
      UnknownDest
          = 'A NF-e %s cont�m destinat�rio com o CNPJ %s ainda n�o registrado na base do SIT. ' +
            'O processamento da NF-e foi abortado.';
      UnknownEmit
          = 'A NF-e %s cont�m emitente com o CNPJ %s ainda n�o registrado na base do SIT. ' +
            'O processamento da nfe foi abortado.';
      UnknownFabr
          = 'A NF-e %s cont�m fabricante com o CNPJ %s ainda n�o registrado na base do SIT. ' +
            'O processamento da nfe foi abortado.';
      UnknownMun
          = 'O c�digo do IBGE para o munic�pio do emitente ou destinat�rio da NFe n�o foi ' +
            'encontrado no SIT. C�digos IBGE do destinat�rio: %s | emitente: %s. ' +
            'O processamento da nfe foi abortado.';
      UnknownPais
          = 'O c�digo do pa�s do emitente ou destinat�rio da NFe n�o � o esperado (1058). ' +
            'O processamento da nfe foi abortado.';
      UnknownProd
          = 'O produto com refer�ncia "%s" da NFe n�o foi encontrado no SIT. ' +
            'O novo produto ser� inserido no SIT.';
  end;


  TDAOInfoMessages = class
    const
      NewConnection  = 'Nova conex�o estabelecida com sucesso!';
      ExecScriptInfo = 'Script de comandos executados com sucesso! Total de comandos executados: %d';
      NewNFe         = 'A NFe de chave %s n�o foi encontrada no SIT e ser� cadastrada';
  end;

implementation

end.
