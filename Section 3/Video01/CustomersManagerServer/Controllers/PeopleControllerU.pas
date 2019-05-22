unit PeopleControllerU;

interface

uses
  MVCFramework, PeopleModuleU;

type

  [MVCPath('/people')]
  TPeopleController = class(TMVCController)
  private
    FPeopleModule: TPeopleModule;
  protected
    procedure OnAfterAction(Context: TWebContext; const AActionNAme: string); override;
    procedure OnBeforeAction(Context: TWebContext; const AActionNAme: string; var Handled: Boolean); override;
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure GetPeople(CTX: TWebContext);

    [MVCPath('/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetPersonByID(CTX: TWebContext);

    [MVCPath]
    [MVCHTTPMethod([httpPOST])]
    [MVCConsumes('application/json')]
    procedure CreatePerson(CTX: TWebContext);

    [MVCPath('/($id)')]
    [MVCHTTPMethod([httpPUT])]
    [MVCConsumes('application/json')]
    procedure UpdatePerson(CTX: TWebContext);

    [MVCPath('/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeletePerson(CTX: TWebContext);

    [MVCPath('/searches')]
    [MVCHTTPMethod([httpPOST])]
    [MVCConsumes('application/json')]
    procedure SearchPeople(CTX: TWebContext);
  end;

implementation

uses
  PersonBO, SysUtils, Data.DBXJSON, ObjectsMappers, System.Math, System.JSON;

{ TPeopleController }

procedure TPeopleController.CreatePerson(CTX: TWebContext);
var
  Person: TPerson;
begin
  Person := CTX.Request.BodyAs<TPerson>;
  try
    FPeopleModule.CreatePerson(Person);
    CTX.Response.Location := '/people/' + Person.ID.ToString;
    Render(201, 'Person created');
  finally
    Person.Free;
  end;
end;

procedure TPeopleController.UpdatePerson(CTX: TWebContext);
var
  Person: TPerson;
begin
  Person := CTX.Request.BodyAs<TPerson>;
  try
    Person.ID := CTX.Request.ParamsAsInteger['id'];
    FPeopleModule.UpdatePerson(Person);
    Render(200, 'Person updated');
  finally
    Person.Free;
  end;
end;

procedure TPeopleController.DeletePerson(CTX: TWebContext);
begin
  FPeopleModule.DeletePerson(CTX.Request.ParamsAsInteger['id']);
  Render(204, 'Person deleted');
end;

procedure TPeopleController.GetPersonByID(CTX: TWebContext);
var
  Person: TPerson;
begin
  Person := FPeopleModule.GetPersonByID(CTX.Request.ParamsAsInteger['id']);
  if Assigned(Person) then
    Render(Person)
  else
    Render(404, 'Person not found');
end;

procedure TPeopleController.GetPeople(CTX: TWebContext);
begin
  Render<TPerson>(FPeopleModule.GetPeople);
end;

procedure TPeopleController.OnAfterAction(Context: TWebContext; const AActionNAme: string);
begin
  inherited;
  FPeopleModule.Free;
end;

procedure TPeopleController.OnBeforeAction(Context: TWebContext; const AActionNAme: string; var Handled: Boolean);
begin
  inherited;
  FPeopleModule := TPeopleModule.Create(nil);
end;

procedure TPeopleController.SearchPeople(CTX: TWebContext);
var
  Filters: TJSONObject;
  SearchText: string;
  CurrPage: Integer;
begin
  Filters := CTX.Request.BodyAsJSONObject;
  if not Assigned(Filters) then
    raise Exception.Create('Invalid search parameters');
  SearchText := Mapper.GetStringDef(Filters, 'TEXT');
  if (not TryStrToInt(CTX.Request.Params['page'], CurrPage)) or (CurrPage < 1) then
    CurrPage := 1;
  Render<TPerson>(FPeopleModule.FindPeople(SearchText, CurrPage));
  CTX.Response.CustomHeaders.Values['dmvc-next-people-page'] :=
    Format('/people/searches?page=%d', [CurrPage + 1]);
  if CurrPage > 1 then
    CTX.Response.CustomHeaders.Values['dmvc-prev-people-page'] :=
      Format('/people/searches?page=%d', [CurrPage - 1]);
end;

end.
