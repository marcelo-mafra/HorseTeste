unit horse.dao.exceptions.consts;

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

  TDAOInfoMessages = class
    const
      NewConnection  = 'Nova conexão estabelecida com sucesso!';
      ExecScriptInfo = 'Script de comandos executados com sucesso! Total de comandos executados: %d';
      NewNFe         = 'A NFe de chave %s não foi encontrada no SIT e será cadastrada';
  end;

implementation

end.
