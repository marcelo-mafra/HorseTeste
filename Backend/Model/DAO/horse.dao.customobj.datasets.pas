unit horse.dao.customobj.datasets;

interface

uses
 System.Classes, System.SysUtils,
 horse.service.params.types;

type
  TDAOCustomObj = class(TInterfacedObject)
    private
      FParams: TBackendParams;
      function GetConnectionStr: string; inline;

    public
      destructor Destroy; override;
      constructor Create(const Params: TBackendParams);

      property ConnectionStr: string read GetConnectionStr;
      property Params: TBackendParams read FParams;
  end;

implementation

{ TDAOCustomObj }

constructor TDAOCustomObj.Create(const Params: TBackendParams);
begin
 inherited Create;
 FParams := Params;
end;

destructor TDAOCustomObj.Destroy;
begin
  inherited Destroy;
end;

function TDAOCustomObj.GetConnectionStr: string;
begin
 Result := Params.ConnectionStr;
end;

end.
