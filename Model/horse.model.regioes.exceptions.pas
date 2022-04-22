unit horse.model.regioes.exceptions;

interface

uses
  System.Classes,
  horse.model.exceptions;

type
  EInvalidRegionName = class(ECosmosError)
   public
    constructor Create;
  end;

  EInvalidRegionParent = class(ECosmosError)
   public
    constructor Create(Info: string);
  end;

implementation

{ EInvalidRegionName }

constructor EInvalidRegionName.Create;
begin
 inherited Create;
 self.ErrorId := TFocosErrorId.InvalidRegionName;
 self.Message := 'O nome da região ou subregião administrativa não foi fornecido.';
end;

{ EInvalidRegionParent }

constructor EInvalidRegionParent.Create(Info: string);
begin
 inherited Create;
 self.ErrorId := TFocosErrorId.InvalidRegionParent;
 self.Message := 'A região ou subregião administrativa não está ligada a uma região-pai existente.';
end;

end.
