unit nfe.localservice.dao.interfaces;

interface

uses
  Winapi.Windows, System.Classes, System.Contnrs,
  //NFe units...
  nfe.localservice.model.nfeobj,
  nfe.localservice.model.process.exceptions;

type
  //Define o contrato para listagem e processamento de objetos TNFEObject a n�vel da camada DAO
  INFEDAOProcess = interface
    ['{052CBCE7-CB5E-4B86-B3EA-943AC726BD81}']
    procedure CreateQueue(var List: TObjectList);
    procedure ProcessNFEObj(var Obj: TNFEObject);

  end;

  //Define o contrato para pend�ncias criadas para objetos TNFEObject
  INFEDAOPendencies = interface
    ['{4327102C-4C0D-4D43-80C6-B0FDD95CB6B4}']
    function CreatePendencie(var Obj: TNFEObject; E: EValidateNfeObject): INFEDAOPendencies;

  end;

implementation

end.
