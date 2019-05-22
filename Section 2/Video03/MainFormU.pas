unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TMainForm = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Panel1: TPanel;
    Button1: TButton;
    Splitter1: TSplitter;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    DBNavigator1: TDBNavigator;
    Button5: TButton;
    Panel2: TPanel;
    Memo1: TMemo;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    procedure SetLog(const Value: String);
    function GetLog: String;
  public
    property Log: String read GetLog write SetLog;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}


uses MainDMU, ObjectsMappers;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Log := dm.qryPeople.AsJSONObjectString;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  Log := dm.qryPeople.AsJSONArrayString;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  dm.qryPeople.Append;
  dm.qryPeople.LoadFromJSONObjectString(Log, TArray<String>.Create('id'));
  dm.qryPeople.Post;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  dm.qryPeople.AppendFromJSONArrayString(Log, TArray<String>.Create('id'));
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  dm.qryPeople.Edit;
  dm.qryPeople.LoadFromJSONObjectString(Log, TArray<String>.Create('id'));
  dm.qryPeople.Post;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  dm.qryPeople.Open();
end;

function TMainForm.GetLog: String;
begin
  Result := Memo1.Lines.Text;
end;

procedure TMainForm.SetLog(const Value: String);
begin
  Memo1.Lines.Text := Value;
end;

end.
