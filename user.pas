unit user;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils,
  Generics.Collections,
  uSqlite;

type

  { TUser }

  TUser = class
    private
    public
      id: integer;
      name: String;
      pass: String;
      isAdmin: boolean;
      constructor Create(
        id: integer;
        name: String;
        pass: String;
        isAdmin: boolean
      ); overload; // two constructors

      // statics
      class function getAll: TList<TUser>; static;
  end;

implementation

{ TUser }

constructor TUser.Create(
  id: integer;
  name: String;
  pass: String;
  isAdmin: boolean);
begin
  self.id:=id;
  self.name:=name;
  self.pass:=pass;
  self.isAdmin:=isAdmin;
end;

class function TUser.getAll: TList<TUser>;
const
  SQL='SELECT id, name, pass, isAdmin FROM users ORDER BY name';
var
  row: TDictionary<String, variant>;
  rows: TList<TDictionary<String, variant>>;
  user: TUser;
begin
  Result:=TList<TUser>.Create; // empty
  rows:=TSQLite.query(SQL);
  for row in rows do
  begin
    user:=TUser.Create(
      row['id'],
      row['name'],
      row['pass'],
      row['isAdmin']
    );
    Result.Add(user);
  end;
end;

end.

