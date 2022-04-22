unit horse.dao.datasets.consts;

interface

uses
  System.Classes;

type
  //Define constantes usadas no contexto de tratamento de falhas no acesso a dados
  TDatasetConsts = class
    const
     InvalidConnection = 'N�o foi passado uma refer�ncia a um objeto de conex�o ou ' +
        'o objeto passado n�o � da classe TADOConnection.';
     InvalidState      = 'Falha ao tentar ler dados do dataset. O dataset n�o pode ' +
        'ser criado ou n�o est� ativo.';
  end;

implementation

end.
