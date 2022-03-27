unit nfe.localservice.dao.connection.factory;

interface

uses
  System.Classes,
  //nfe units
  nfe.localservice.dao.connection.interfaces,
  nfe.localservice.dao.connection.ado.types,
  nfe.localservice.dao.connection.ado,
  nfe.localservice.model.params.types;

type
    {Classe factory para criação de objetos DAO que implementam IAbstractConnection.
    Essa classe deve*** ser usada para todo acesso a banco de dados feito pelo
    service. Nunca*** se deve usar qualquer*** componente descendente de TCustomConnection }
    TConnectionFactory = class
      public
       class function New(const DataParams: TModelDatabaseParams; const TimeoutsParams: TModelTimeouts): IAbstractConnection; overload;
       class function New(const DataParams: TModelDatabaseParams; const TimeoutsParams: TModelTimeouts;
          OnError: TOnADOErrorEvent; OnExecuteCommand: TOnExecuteCommandEvent): IAbstractConnection; overload;
    end;

implementation

{ TConnectionFactory }

class function TConnectionFactory.New(const DataParams: TModelDatabaseParams;
  const TimeoutsParams: TModelTimeouts; OnError: TOnADOErrorEvent;
  OnExecuteCommand: TOnExecuteCommandEvent): IAbstractConnection;
begin
  {Acessa a interface IAbstractConnection usando ADO e alguns ponteiros de eventos.
  Esses ponteiros permitem que as classes que fazem uso de IAbstractConnection
  manipulem, conforme suas necessidades, ocorrências específicas detectadas em
  operações envolvendo o database}
  Result := TNFEADOConnection.New(DataParams.ConnectionString, TimeoutsParams.ConnectionTimeout,
      TimeoutsParams.CommandTimeout, OnError, OnExecuteCommand);
end;

class function TConnectionFactory.New(const DataParams: TModelDatabaseParams;
  const TimeoutsParams: TModelTimeouts): IAbstractConnection;
begin
  {Acessa a interface IAbstractConnection usando ADO e alguns ponteiros de eventos.
  Esses ponteiros permitem que as classes que fazem uso de IAbstractConnection
  manipulem, conforme suas necessidades, ocorrências específicas detectadas em
  operações envolvendo o database}
  Result := TNFEADOConnection.New(DataParams.ConnectionString, TimeoutsParams.ConnectionTimeout,
      TimeoutsParams.CommandTimeout, nil, nil);
end;

end.
