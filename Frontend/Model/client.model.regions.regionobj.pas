unit client.model.regions.regionobj;

interface

uses
  System.Classes, System.Generics.Collections, REST.Json.Types,
  System.Variants, FMX.Types;

{$M+}

type

  TRegion = class(TFmxObject)
  private
    FCodigo: Integer;
    FParent: variant;
    FRegiao: string;

  public
    constructor Create;
    destructor Destroy; override;
    property Codigo: Integer read FCodigo write FCodigo;
    property Parent: variant read FParent write FParent;
    property Regiao: string read FRegiao write FRegiao;
  end;

implementation

{ TRegion }

constructor TRegion.Create;
begin
 inherited Create(nil);
 FParent := null;
end;

destructor TRegion.Destroy;
begin

  inherited;
end;

end.
