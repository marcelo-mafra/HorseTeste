unit horse.model.customobj;

interface

uses
  System.Classes, System.JSON, System.JSON.Converters;

type
  TModelCustomObject = class(TInterfacedObject)
    public
      function AsJson(const Data: string): TJsonObject; virtual; abstract;
      //function AsObject: TModelCustomObject; virtual; abstract;
  end;

implementation

end.
