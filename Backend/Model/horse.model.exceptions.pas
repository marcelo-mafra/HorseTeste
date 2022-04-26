unit horse.model.exceptions;

interface

uses
  System.Classes, System.SysUtils, System.JSON;

type
  TInvalidContent = class
    const
      EmptyParams = 2;
      Json      = 3;
  end;

  TAlunosErrorId = class
    const
      InvalidPupilName   = 1;
  end;

  TFocosErrorId = class
    const
      InvalidRegionName     = 1;
      InvalidRegionParent   = 2;
      DeleteRegion          = 3;
  end;

  ECosmosError = class(Exception)
    private
     FErrorId: integer;
    public
     property ErrorId: integer read FErrorId write FErrorId;
     constructor Create;

  end;

  TExceptionFormatter = class helper for ECosmosError
    public
      function AsJson: TJsonObject;
  end;

  EInvalidRequestData = class(ECosmosError)
   public
    constructor Create;
  end;

  EInvalidParams = class(ECosmosError)
   public
    constructor Create;
  end;

implementation

{ TExceptionFormatter }

function TExceptionFormatter.AsJson: TJsonObject;
begin
 Result := TJsonObject.Create
    .AddPair('Id', self.FErrorId.ToString)
    .AddPair('Message', self.Message)
    .AddPair('ClassName', self.ClassName);
 if Assigned(self.InnerException) then
    Result.AddPair('ContextInfo', self.InnerException.Message);
end;

{ ECosmosError }

constructor ECosmosError.Create;
begin
 inherited Create('');
end;

{ EInvalidRequestData }

constructor EInvalidRequestData.Create;
begin
 inherited Create;
 self.ErrorId := TInvalidContent.Json;
 self.Message := 'O conteúdo json recebido na requisição é inválido, está ' +
                 'incompleto ou possui um ou mais valores de tipos incorretos.';
end;

{ EInvalidParams }

constructor EInvalidParams.Create;
begin
 inherited Create;
 self.ErrorId := TInvalidContent.EmptyParams;
 self.Message := 'Não foi possível ler os parâmetros de busca de dados a partir ' +
                 'do json recebido na requisição.';
end;

end.
