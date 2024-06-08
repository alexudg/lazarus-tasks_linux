unit task;

{$mode Delphi}

interface

uses
  Classes, SysUtils,
  Generics.Collections,
  uSQLite;

type

  { TTask }

  TTask = class
    private

    public
      id: integer;
      idUser: integer;
      title: String;
      description: String;
      isDone: boolean;

      constructor Create(
        id: integer;
        idUser: integer;
        title: String;
        description: String;
        isDone: boolean
      ); overload; // two constructors
      function ToString: String; override;

      // static
      class function getAll(idUser: integer): TList<TTask>; static;
  end;

implementation

{ TTask }

constructor TTask.Create(
  id: integer;
  idUser: integer;
  title: String;
  description: String;
  isDone: boolean);
begin
  self.id:=id;
  self.idUser:=idUser;
  self.title:=title;
  self.description:=description;
  self.isDone:=isDone;
end;

function TTask.ToString: String;
begin
  //Result:=inherited ToString;
  Result:=Format('TTask: {id: %d, idUser: %d, title: %s, description: %s, isDone: %s}', [
    self.id,
    self.idUser,
    self.title,
    self.description,
    BoolToStr(self.isDone, true)
  ]);
end;

class function TTask.getAll(idUser: integer): TList<TTask>;
const
  SQL = 'SELECT id, idUser, title, description, isDone FROM tasks WHERE idUser = :idUser';
var
  row:  TDictionary<String, variant>;
  rows: TList<TDictionary<String, variant>>;
  task: TTask;
begin
  Result:=TList<TTask>.Create; // empty
  rows:=TSQLite.query(SQL, [idUser]);
  for row in rows do
  begin
    task:=TTask.Create(
      row['id'],
      row['idUser'],
      row['title'],
      row['description'],
      row['isDone']
    );
    Result.Add(task);
  end;
end;

end.

