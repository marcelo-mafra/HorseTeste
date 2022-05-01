unit horse.controller.router.exceptions;

interface

uses
  System.Classes, System.SysUtils, System.JSON,
  horse.model.exceptions;

type
  EInvalidJsonContentType = class(ECosmosError)
   public
    constructor Create;
  end;

implementation

{ EInvalidJsonContentType }

constructor EInvalidJsonContentType.Create;
begin
 inherited Create;
 self.ErrorId := TInvalidContent.Json;
 self.Message := 'O contentType do request não é informado como Json.'
end;

end.
