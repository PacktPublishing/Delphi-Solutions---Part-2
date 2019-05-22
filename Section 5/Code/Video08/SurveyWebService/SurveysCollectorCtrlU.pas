unit SurveysCollectorCtrlU;

interface

uses
  MVCFramework;

type
  [MVCPath('/surveys')]
  TSurveyCollector = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateSurveyResponse(ctx: TWebContext);
  end;

implementation

uses
  System.SysUtils, System.IOUtils, System.JSON, MVCFramework.Commons,
  MVCFramework.Logger;

procedure TSurveyCollector.CreateSurveyResponse(ctx: TWebContext);
begin
  Log('Request data: ' + ctx.Request.Body);
  Log('Wait a bit...');
  Sleep(5000);
  if ctx.Request.ThereIsRequestBody then
    Render(HTTP_STATUS.OK, TJSONObject.Create(TJSONPair.Create('result', 'ok')))
  else
    Render(HTTP_STATUS.BadRequest,
      TJSONObject.Create(TJSONPair.Create('result', 'ko')));
  Log('Response sent');
end;

end.
