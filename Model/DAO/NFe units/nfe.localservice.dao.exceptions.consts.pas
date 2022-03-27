unit nfe.localservice.dao.exceptions.consts;

interface

uses
 Winapi.Windows, System.Classes;

type
  TDAOErrorMessages = class
    const
      ErrorInfo
          = 'Ocorreu um erro em uma operação de acesso ou escrita de dados. Detalhes: ' +
            'Source: %s. Description: %s.';
      InvalidConnection
          = 'Não foi possível criar o objeto que realiza a conexão com o servidor ' +
          'de banco de dados';
      ExecCommandError
          = 'Ocorreu um erro fatal ao tentar executar um comando: mensagem: %s';
      ExecScriptError
          = 'Ocorreu um erro fatal ao tentar executar um script de comandos: mensagem: %s';
      UnexpectedDatasetError
          = 'Ocorreu um erro inesperado ao tentar executar a consulta: %s | Mensagem: %s';
      WillConnectError
          = 'Ocorreu um erro ao solicitar nova conexão ao driver OLEDB. UserId: %s';
      EmptyCnpjDest
          = 'A raíz do cnpj do destinatário não pode ser calculada a partir ' +
            'do CNPJ completo pois esse não foi informado (vazio).';
      InvalidCnpjDest
          = 'A raíz do cnpj do destinatário não pode ser calculada a partir ' +
            'do CNPJ completo. CNPJ usado como parâmetro da operação: %s';
      InvalidCnpjEmit
          = 'A raíz do cnpj do emitente não pode ser calculada a partir ' +
            'do CNPJ completo. CNPJ usado como parâmetro da operação: %s';
      InvalidCnpjFabr
          = 'A raíz do cnpj do fabricante não pode ser calculada a partir ' +
            'do CNPJ completo. CNPJ usado como parâmetro da operação: %s';
      UnknownCnpjDest
          = 'A raíz do cnpj do destinatário não foi encontrada no banco de dados do SIT. ' +
            'Verifique o CNPJ completo usado para a operação. CNPJ usado como parâmetro da operação: %s';
      UnknownCnpjEmit
          = 'A raíz do cnpj do emitente não foi encontrada no banco de dados do SIT. ' +
            'Verifique o CNPJ completo usado para a operação. CNPJ usado como parâmetro da operação: %s';
      UnknownCnpjFabr
          = 'A raíz do cnpj do fabricante não foi encontrada no banco de dados do SIT. ' +
            'Verifique o CNPJ completo usado para a operação. CNPJ usado como parâmetro da operação: %s';
      UnknownCnpjToraBranch
          = 'A raíz do cnpj da empresa do grupo Tora responsável pela NFe não foi encontrada ' +
            'no banco de dados do SIT. Verifique os CNPJs do destinatário e do Transportador. ' +
            'O processamento da NFe foi abortado';
      InvalidTransportInfo
          = 'O tipo do serviço não pode ser obtido no conteúdo xml da NFe. Como ' +
            'consequência, os dados da transportadora não puderam ser lidos';
      XmlParserError
          = 'O parser MSXML3.DLL retornou um erro DOM (EDOMParseError) ao tentar validar parte do XML recebido. ' +
            'Método que disparou o erro: %s . Mensagem recebida do parser: %s';
  end;

  //Mensagens relacionadas à validação do status de cada NFe
  TDAOStatusValidationNFe = class
    const
      Completed
          = 'A nfe foi identificada como "completa" e possui todos os dados do serviço prestado.';
      Summarized
          = 'A nfe foi identificada como "resumida", sem dados detalhados do serviço prestado. ' +
            'O processamento da nfe será abortado.';
  end;

  //Mensagens relacionadas à validação do resultado do mapeamento O.R. de cada NFe
  TDAOMappingValidationNFe = class
    const
      Normal
          = 'O mapeamento objeto-relacional do objeto TNFEObject corrente foi feito com sucesso.';
      InvalidDbMapping
          = 'O mapeamento do objeto TNFEObject corrente não pode ser completado a partir de dados do banco de dados do SIT. ' +
            'O processamento da nfe poderá ser cancelado se os dados faltantes forem exigidos.';
      InvalidSchema
          = 'O mapeamento do objeto TNFEObject corrente não pode ser completado. O conteúdo xml da nfe ' +
            'está com o schema quebrado ou incompleto. O processamento da nfe não pode prosseguir e foi cancelado.' ;
  end;

  //Mensagens relacionadas às validações envolvendo regras de negócio de cada NFe
  TDAOStatusNfeError = class
    const
      InvalidNfe
          = 'A nfe não possui informações do cnpj do emitente e/ou destinatário. ' +
            'Não é possível processar nfes sem dados centrais das empresas envolvidas.';
      UnknownDest
          = 'A NF-e %s contém destinatário com o CNPJ %s ainda não registrado na base do SIT. ' +
            'O processamento da NF-e foi abortado.';
      UnknownEmit
          = 'A NF-e %s contém emitente com o CNPJ %s ainda não registrado na base do SIT. ' +
            'O processamento da nfe foi abortado.';
      UnknownFabr
          = 'A NF-e %s contém fabricante com o CNPJ %s ainda não registrado na base do SIT. ' +
            'O processamento da nfe foi abortado.';
      UnknownMun
          = 'O código do IBGE para o município do emitente ou destinatário da NFe não foi ' +
            'encontrado no SIT. Códigos IBGE do destinatário: %s | emitente: %s. ' +
            'O processamento da nfe foi abortado.';
      UnknownPais
          = 'O código do país do emitente ou destinatário da NFe não é o esperado (1058). ' +
            'O processamento da nfe foi abortado.';
      UnknownProd
          = 'O produto com referência "%s" da NFe não foi encontrado no SIT. ' +
            'O novo produto será inserido no SIT.';
  end;


  TDAOInfoMessages = class
    const
      NewConnection  = 'Nova conexão estabelecida com sucesso!';
      ExecScriptInfo = 'Script de comandos executados com sucesso! Total de comandos executados: %d';
      NewNFe         = 'A NFe de chave %s não foi encontrada no SIT e será cadastrada';
  end;

implementation

end.
