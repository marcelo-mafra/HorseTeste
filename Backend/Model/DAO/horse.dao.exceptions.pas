unit horse.dao.exceptions;
{
Esta unit define objetos do tipo "exception" mapeados exclusivamente para
processos de escrita ou leitura de dados, a n�vel DAO apenas. Essas classes s�o
usadas na escrita ou leitura de dados a partir de qualquer fonte (Xml ou Db), sempre
em mais baixo n�vel de abstra��o. Tamb�m s�o definidas classes espec�ficas para
exceptions durante os mapeamentos O.R.
}
interface

uses
 Winapi.Windows, System.Classes, System.SysUtils;

type
  //Objeto ou interface de connection com db inv�lido ou inexistente
  EInvalidConnectionObject = class(Exception);

  //Objeto ou interface de leitura de dados (datasets) com status inv�lido
  EInvalidDatasetState  = class(Exception);

  //classe ancestral de exceptions relacionados ao mapeamento de objetos TNFeObject
  EMappingError = class(Exception);

  //Abstrai um exception durante o mapeamento TNFeObject a partir do conte�do do XML da NFe
  ENFeObjectXmlMapping = class(EMappingError);

  //Abstrai um exception durante o mapeamento TNFeObject a partir do banco de dados do sit
  ENFeObjectDbMapping = class(EMappingError);

  //Abstrai um exception de acesso � mem�ria durante o mapeamento TNFeObject
  ENFeObjectMemoryRead = class(EMappingError);

  //Abstrai um exception gen�rico durante o mapeamento TNFeObject
  ENFeObjectFailureMapping = class(EMappingError);


implementation

end.
