unit horse.model.exceptions;

interface

uses
  System.Classes, System.SysUtils, System.JSON;

type
  TInvalidContent = class
    const
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

implementation

{ TExceptionFormatter }

function TExceptionFormatter.AsJson: TJsonObject;
begin
 Result := TJsonObject.Create
    .AddPair('Id', self.FErrorId.ToString)
    .AddPair('Message', self.Message)
    .AddPair('ClassName', self.ClassName)
    .AddPair('Context', self.GetStackTrace);
end;

{ ECosmosError }

constructor ECosmosError.Create;
begin
 inherited Create('');
end;

end.
