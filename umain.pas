{
  * author: Alejandro Ramirez Macias
  * mail: alexudg@gmail.com
  * created at: 2024 june
  * ide: lazarus 3.2
  * dependencies:
    - libsqlite3.so
}

unit umain;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Grids, Generics.Collections, Task;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Panel1: TPanel;
    bar: TStatusBar;
    grid: TStringGrid;
    procedure FormShow(Sender: TObject);
  private
    _tasks: TList<TTask>;
    procedure _loadTasks(idSelect: integer = -1);
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormShow(Sender: TObject);
begin
  _loadTasks();
end;

procedure TfrmMain._loadTasks(idSelect: integer);
var
  i: integer;
  task: TTask;
begin
  _tasks:=TTask.getAll(0);

  with (grid) do
  begin
    RowCount:=_tasks.Count + 1;
    for i:=0 to _tasks.Count - 1 do
    begin
      task:=_tasks[i];
      Cells[0, i + 1]:=task.title;
      Cells[1, i + 1]:=task.description;
      Cells[2, i + 1]:=BoolToStr(task.isDone, true);
    end;
    AutoSizeColumns;
  end;

  // show count
  with (bar.Panels[1]) do
  begin
    Text:=_tasks.Count.ToString + ' tarea';
    if (_tasks.Count <> 1) then
      Text:=Text + 's';
  end;
end;

end.

