unit client.dao.http.connection.interfaces;

interface

uses
  System.Classes;

type
  IHttpConnect = interface
    ['{4182D830-BEF9-4673-9722-9C1A73A8DFBE}']
    procedure ConnectServer(const BaseUrl: string; const ConnectTimeout,
          ReadTimeout: integer);
  end;

implementation

end.
