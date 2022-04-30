unit client.dao.http.connection.consts;

interface

uses
  System.Classes;

type
  TRequestConst = class
    const
      UTF8Encoding  = 'utf-8';
      Accept        ='application/json, text/plain; q=0.9, text/html;q=0.8,';
      AcceptCharset = 'utf-8, *;q=0.8';
      JsonContent   = 'application/json; charset=UTF-8';
  end;

implementation

end.
