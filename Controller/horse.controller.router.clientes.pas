unit horse.controller.router.clientes;

interface

uses
 System.Classes, System.SysUtils, System.JSON,
 Horse,
 horse.controller.router.consts, horse.model.params.builder,
 horse.model.params.builder.json;

type
 TClientesEndpoints = class

 public
   class procedure ExecuteClienteEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
   class procedure ExecuteClientesEndpoint(Request: THorseRequest; Response: THorseResponse;
      Next: TProc);
 end;

implementation

{ TClientesEndpoints }

class procedure TClientesEndpoints.ExecuteClienteEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
var
 Id: integer;
begin
 if Request.Params.ContainsKey(TClientsParams.id) then
   begin
     Id := Request.Params.Items[TClientsParams.id].ToInteger;
     Response.Send(Format(TCustomPages.Cliente, [Id]))
   end;
end;

class procedure TClientesEndpoints.ExecuteClientesEndpoint(
  Request: THorseRequest; Response: THorseResponse; Next: TProc);
var
 JsonObj: TJSONObject;
begin
{
  JsonObj := TModelParamsBuilder.New
        .BeginObject
        .Add('id', 23)
        .Add('nome', 'marcelo')
        .Add('time', Now)
        .Add('Verdadeiro', True)
        .Add('Number', Double(456/34.978))
        .ParamsObj.ToJson;
  try
    Response.ContentType(TContentsTypes.Json).Send<TJSONObject>(JsonObj);
  finally
    //if Assigned(JsonObj) then FreeAndNil(JsonObj);
  end;
 }
  Response.ContentType(TContentsTypes.Json).Send
  (
      TModelParamsBuilder.New
      .BeginObject
      .Add(TClientsParams.id, random(1000))
      .Add(TClientsParams.nome, 'marcelo')
      .Add(TClientsParams.time, Now)
      .Add(TClientsParams.bool, True)
      .Add(TClientsParams.number, Double(random(1000)/34.978))
      .ParamsObj.ToJsonString
  );
end;

end.
