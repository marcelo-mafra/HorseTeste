unit nfe.localservice.dao.process.events;

interface

uses
  Winapi.Windows, System.Classes,
  //NFe units...
  nfe.localservice.model.nfeobj,
  nfe.localservice.model.process.types;

type
  //Abstrai o evento de resultado do processamento de um objeto TNFEObject específico
  TOnValidationNfeEvent = procedure(Sender: TObject; const Obj: TNFEObject) of object;

  //Abstrai um evento de sinalização de execução de um "checker" feita
  TOnCheckerExecuteEvent = procedure(Sender: TObject; const Obj: TNFEObject;
    var Validated: boolean) of object;

  //Abstrai um evento de sinalização de dado essencial ausente na base de dados
  TOnUnknownDataEvent = procedure(Sender: TObject; const Obj: TNFEObject;
    const UnknownData: TProcessDataInfo; const RefProduto: string) of object;

implementation

end.
