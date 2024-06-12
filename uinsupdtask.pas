unit uInsUpdTask;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  PopupNotifier, Task;

type

  { TfrmInsUpdTask }

  TfrmInsUpdTask = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    chkIsDone: TCheckBox;
    Label1: TLabel;
    popup: TPopupNotifier;
    txtDescription: TMemo;
    txtTitle: TLabeledEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    _tmr: TTimer;
    procedure _onTimer(Sender: TObject);
  public
    task: TTask;
  end;

var
  frmInsUpdTask: TfrmInsUpdTask;

implementation

{$R *.lfm}

{ TfrmInsUpdTask }

procedure TfrmInsUpdTask.FormShow(Sender: TObject);
begin
  // insert
  if (task.id = -1) then
  begin
    self.Caption:='Nueva tarea';
  end
  else
  begin
    self.Caption:='Modificando tarea';
  end;
  txtTitle.Text:=task.title;
  txtDescription.Text:=task.description;
  chkIsDone.Checked:=task.isDone;
  chkIsDone.Enabled:=task.id > -1;
end;

procedure TfrmInsUpdTask._onTimer(Sender: TObject);
begin
  (Sender as TTimer).Enabled:=false;
  popup.Hide;
end;

procedure TfrmInsUpdTask.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmInsUpdTask.btnOkClick(Sender: TObject);
begin
  // validate
  if (txtTitle.Text = '') then
  begin
    popup.Text:='Titulo vacío';
    popup.ShowAtPos(self.Left, self.Top);
    _tmr.Enabled:=true;
    Exit;
  end;
  task.title:=txtTitle.Text;
  if (txtDescription.Text = '') then
  begin
    popup.Text:='Descripción vacía';
    popup.ShowAtPos(self.Left, self.Top);
    _tmr.Enabled:=true;
    Exit;
  end;
  task.description:=txtDescription.Text;
  task.isDone:=chkIsDone.Checked;
  if (task.id = -1) then
  begin
    task.idUser:=0;
    task.id:=TTask.insert(task);
  end
  else
    TTask.update(task);
  self.ModalResult:=mrOk;
end;

procedure TfrmInsUpdTask.FormCreate(Sender: TObject);
begin
  _tmr:=TTimer.Create(nil);
  _tmr.OnTimer:=_onTimer;
  _tmr.Enabled:=false;
  _tmr.Interval:=3000;
end;

end.

