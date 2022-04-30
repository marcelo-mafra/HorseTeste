unit client.model.customobj;

interface

uses
  System.Classes, client.dao.http.connection.interfaces,
  client.dao.http.connection;

type
  TModelCustomObject = class(TInterfacedObject)
    public
     constructor Create;
     destructor Destroy; override;
     function HttpServer: IHttpConnect; virtual; abstract;
  end;

implementation

{ TModelCustomObject }

constructor TModelCustomObject.Create;
begin
 inherited Create;
end;

destructor TModelCustomObject.Destroy;
begin

  inherited Destroy;
end;

end.
