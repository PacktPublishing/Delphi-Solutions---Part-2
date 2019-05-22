unit SampleControllerU;

interface

uses
  MVCFramework;

type
  [MVCPath('/')]
  [MVCDoc('Just a sample controller')]
  TSampleController = class(TMVCController)
  public
    [MVCPath('/users')]
    [MVCHTTPMethods([httpGET])]
    [MVCDoc('Returns the users list')]
    procedure GetUsers(CTX: TWebContext);

    [MVCPath('/users')]
    [MVCHTTPMethods([httpPOST])]
    [MVCConsumes('application/json')]
    [MVCDoc('Creates a new user')]
    procedure CreateUser(CTX: TWebContext);
  end;

implementation

uses System.JSON, MVCFramework.Commons;

{ TSampleController }

procedure TSampleController.CreateUser(CTX: TWebContext);
begin
  // just a fake, we don't create any user.
  // simply echo the body request as body response
  if CTX.Request.ThereIsRequestBody then
  begin
    CTX.Response.StatusCode := HTTP_STATUS.Created;
    Render(CTX.Request.BodyAsJSONObject, False)
  end
  else
    raise EMVCException.Create(HTTP_STATUS.BadRequest, 'Expected JSON body');
end;

procedure TSampleController.GetUsers(CTX: TWebContext);
var
  LJObj: TJSONObject;
  LJArray: TJSONArray;
begin
  LJArray := TJSONArray.Create;

  LJObj := TJSONObject.Create;
  LJObj.AddPair('first_name', 'Daniele').AddPair('last_name', 'Teti')
    .AddPair('email', 'd.teti@bittime.it');
  LJArray.AddElement(LJObj);

  LJObj := TJSONObject.Create;
  LJObj.AddPair('first_name', 'Peter').AddPair('last_name', 'Parker')
    .AddPair('email', 'pparker@dailybugle.com');
  LJArray.AddElement(LJObj);

  LJObj := TJSONObject.Create;
  LJObj.AddPair('first_name', 'Bruce').AddPair('last_name', 'Banner')
    .AddPair('email', 'bbanner@angermanagement.com');
  LJArray.AddElement(LJObj);

  Render(LJArray);
end;

end.
