unit horse.dao.connection.factory;

interface

uses
  System.Classes,
  //horse units
  horse.dao.connection.interfaces,
  horse.dao.connection.types,
  horse.dao.connection.firedac,
  horse.model.params.types;

type
    {Classe factory para criação de objetos DAO que implementam IAbstractConnection.
    Essa classe deve*** ser usada para todo acesso a banco de dados feito pelo
    service. Nunca*** se deve usar qualquer*** componente descendente de TCustomConnection }
    TConnectionFactory = class
      public
       class function New(const DataParams: TModelDataParams; const TimeoutsParams: TModelTimeouts): IAbstractConnection; overload;
       class function New(const DataParams: TModelDataParams; const TimeoutsParams: TModelTimeouts;
          OnError: TOnDBErrorEvent; OnExecuteCommand: TOnExecuteCommandEvent): IAbstractConnection; overload;
       class function New(const ConnectionStr: string): IAbstractConnection; overload;
    end;

implementation

{ TConnectionFactory }

class function TConnectionFactory.New(const DataParams: TModelDataParams;
  const TimeoutsParams: TModelTimeouts; OnError: TOnDBErrorEvent;
  OnExecuteCommand: TOnExecuteCommandEvent): IAbstractConnection;
begin
  {Acessa a interface IAbstractConnection usando ADO e alguns ponteiros de eventos.
  Esses ponteiros permitem que as classes que fazem uso de IAbstractConnection
  manipulem, conforme suas necessidades, ocorrências específicas detectadas em
  operações envolvendo o database}
  Result := TFiredacHorseConnection.New(DataParams.ConnectionString, TimeoutsParams.ConnectionTimeout,
      TimeoutsParams.CommandTimeout, OnError, OnExecuteCommand);
end;

class function TConnectionFactory.New(const DataParams: TModelDataParams;
  const TimeoutsParams: TModelTimeouts): IAbstractConnection;
begin
  {Acessa a interface IAbstractConnection usando ADO e alguns ponteiros de eventos.
  Esses ponteiros permitem que as classes que fazem uso de IAbstractConnection
  manipulem, conforme suas necessidades, ocorrências específicas detectadas em
  operações envolvendo o database}
  Result := TFiredacHorseConnection.New(DataParams.ConnectionString, TimeoutsParams.ConnectionTimeout,
      TimeoutsParams.CommandTimeout, nil, nil);
end;

class function TConnectionFactory.New(
  const ConnectionStr: string): IAbstractConnection;
begin
  Result := TFiredacHorseConnection.New(ConnectionStr, 0, 0, nil, nil);
end;

end.
