unit nfe.localservice.dao.datasets.interfaces;

interface

uses
  System.Classes;

type
  //Define o contrato de funções relacionadas a acesso e leitura de dados
  IDataset = interface
    ['{9D2CA4DC-65E1-4BF5-84A5-4FB087E4742C}']
    function IsEmpty: boolean;
    function Open(const Command: string): IDataset;
    function Value(const FieldName: string): variant;

  end;

implementation

end.
