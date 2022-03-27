unit horse.controller.router.sample;

interface

uses
 System.Classes, System.SysUtils,
 Horse,
 horse.controller.router.consts;

type
 TSampleEndpoints = class

 public
   class procedure ExecuteSampleEndpoint(Request: THorseRequest; Response: THorseResponse;
       Next: TProc);
 end;

implementation

{ TSampleEndpoints }

class procedure TSampleEndpoints.ExecuteSampleEndpoint(Request: THorseRequest;
  Response: THorseResponse; Next: TProc);
begin
  Response.ContentType(TContentsTypes.Html).Send(string.Format(TCustomPages.Basic, [DateTimeToStr(Now)]));
end;

end.
