unit horse.model.customobj;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.JSON.Converters,
  horse.service.params.types;

type
  TModelCustomObject = class(TInterfacedObject)
    private
      FParams: TBackendParams;

    public
      constructor Create(const Params: TBackendParams); overload;
      destructor Destroy; override;

      property Params: TBackendParams read FParams;
  end;

implementation

{ TModelCustomObject }

constructor TModelCustomObject.Create(const Params: TBackendParams);
begin
 inherited Create;
 FParams := Params;
end;

destructor TModelCustomObject.Destroy;
begin

  inherited;
end;

end.
