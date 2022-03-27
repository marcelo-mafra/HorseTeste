unit horse.dao.exceptions;
{
Esta unit define objetos do tipo "exception" mapeados exclusivamente para
processos de escrita ou leitura de dados, a nível DAO apenas. Essas classes são
usadas na escrita ou leitura de dados a partir de qualquer fonte (Xml ou Db), sempre
em mais baixo nível de abstração. Também são definidas classes específicas para
exceptions durante os mapeamentos O.R.
}
interface

uses
 Winapi.Windows, System.Classes, System.SysUtils;

type
  //Objeto ou interface de connection com db inválido ou inexistente
  EInvalidConnectionObject = class(Exception);

  //Objeto ou interface de leitura de dados (datasets) com status inválido
  EInvalidDatasetState  = class(Exception);

  //classe ancestral de exceptions relacionados ao mapeamento de objetos TNFeObject
  EMappingError = class(Exception);

  //Abstrai um exception durante o mapeamento TNFeObject a partir do conteúdo do XML da NFe
  ENFeObjectXmlMapping = class(EMappingError);

  //Abstrai um exception durante o mapeamento TNFeObject a partir do banco de dados do sit
  ENFeObjectDbMapping = class(EMappingError);

  //Abstrai um exception de acesso à memória durante o mapeamento TNFeObject
  ENFeObjectMemoryRead = class(EMappingError);

  //Abstrai um exception genérico durante o mapeamento TNFeObject
  ENFeObjectFailureMapping = class(EMappingError);


implementation

end.
