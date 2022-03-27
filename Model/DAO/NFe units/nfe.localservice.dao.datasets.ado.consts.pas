unit nfe.localservice.dao.datasets.ado.consts;

interface

uses
  System.Classes;

type
  //Define constantes usadas no contexto de tratamento de falhas no acesso a dados
  TADODatasetConsts = class
    const
     InvalidConnection = 'Não foi passado uma referência a um objeto de conexão ou ' +
        'o objeto passado não é da classe TADOConnection.';
     InvalidState      = 'Falha ao tentar ler dados do dataset. O dataset não pode ' +
        'ser criado ou não está ativo.';
  end;

implementation

end.
