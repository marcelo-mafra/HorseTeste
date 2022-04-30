unit client.dao.http.connection.regions.interfaces;

interface

uses
  System.Classes, System.JSON,
  client.dao.http.connection.interfaces;

type
  IHttpConnectRegions = interface(IHttpConnect)
    ['{1FD25CDA-133D-418F-8C6A-EB59B1CC5899}']

    function Connect: IHttpConnectRegions;
    function GetRegions: string;
    function ListParentRegions(const OwnerId: integer): TJsonArray;
  end;

implementation

end.
