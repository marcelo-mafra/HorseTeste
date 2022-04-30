unit horse.model.customobj;

interface

uses
  System.Classes, System.JSON, System.JSON.Converters,
  horse.service.params.types;

type
  TModelCustomObject = class(TInterfacedObject)
    private
      FParams: TBackendParams;

    public
      constructor Create(const Params: TBackendParams); overload;
      constructor Create(const Params: TBackendParams; obj: TJsonObject); overload;
      destructor Destroy; override;
      function AsJsonObject: TJsonObject; virtual; abstract;
      procedure ToObject(obj: TJsonObject); virtual; abstract;

      property Params: TBackendParams read FParams;

  end;

implementation

{ TModelCustomObject }

constructor TModelCustomObject.Create(const Params: TBackendParams);
begin
 inherited Create;
 FParams := Params;
end;

constructor TModelCustomObject.Create(const Params: TBackendParams; obj: TJsonObject);
begin
 self.Create(Params);
 self.ToObject(obj);
end;

destructor TModelCustomObject.Destroy;
begin

  inherited;
end;

end.
