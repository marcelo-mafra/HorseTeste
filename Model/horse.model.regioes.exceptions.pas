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

  EDeleteRegion = class(ECosmosError)
   public
    constructor Create;
  end;

implementation

{ EInvalidRegionName }

constructor EInvalidRegionName.Create;
begin
 inherited Create;
 self.ErrorId := TFocosErrorId.InvalidRegionName;
 self.Message := 'O nome da regi�o ou subregi�o administrativa n�o foi fornecido.';
end;

{ EInvalidRegionParent }

constructor EInvalidRegionParent.Create(Info: string);
begin
 inherited Create;
 self.ErrorId := TFocosErrorId.InvalidRegionParent;
 self.Message := 'A regi�o ou subregi�o administrativa n�o est� ligada a uma regi�o-pai existente.';
end;

{ EDeleteRegion }

constructor EDeleteRegion.Create;
begin
 inherited Create;
 self.ErrorId := TFocosErrorId.DeleteRegion;
 self.Message := 'A regi�o ou subregi�o administrativa n�o pode ser exclu�da. ' +
                 'A subregi�o ou regi�o est� vinculada a um ou mais focos.';
end;

end.
