library mod_peoplemanager;

uses
  Winapi.ActiveX,
  System.Win.ComObj,
  Web.WebBroker,
  Web.ApacheApp,
  Web.HTTPD24Impl,
  WebModuleU in 'WebModuleU.pas' {wmMain: TWebModule},
  SampleControllerU in 'SampleControllerU.pas';

{$R *.res}

// httpd.conf entries:
//
(*
 LoadModule peoplemanager_module modules/mod_peoplemanager.dll

 <Location /xyz>
    SetHandler mod_peoplemanager-handler
 </Location>
*)
//
// These entries assume that the output directory for this project is the apache/modules directory.
//
// httpd.conf entries should be different if the project is changed in these ways:
//   1. The TApacheModuleData variable name is changed
//   2. The project is renamed.
//   3. The output directory is not the apache/modules directory
//

// Declare exported variable so that Apache can access this module.
var
  GModuleData: TApacheModuleData;
exports
  GModuleData name 'peoplemanager_module';

begin
  CoInitFlags := COINIT_MULTITHREADED;
  Web.ApacheApp.InitApplication(@GModuleData);
  Application.Initialize;
  Application.WebModuleClass := WebModuleClass;
  Application.Run;
end.
