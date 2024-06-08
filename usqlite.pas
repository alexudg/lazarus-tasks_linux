unit uSqlite;

{$mode Delphi}

interface

uses
  Classes, SysUtils,
  Generics.Collections,
  Dialogs,
  SQLite3Conn,
  SQLDBLib,
  SQLDB;

type

  { TSQLite }

  TSQLite = class
    private
      class var
        _lib: TSQLDBLibraryLoader;
        _con: TSQLite3Connection;
        _qry: TSQLQuery;
        _tra: TSQLTransaction;
    public
      class function scalar(sql: String; params: TArray<variant> = nil): variant; static;
      class function query(sql: String; params: TArray<variant> = nil): TList<TDictionary<String, variant>>; static;
      class procedure execute(sql: String; params: TArray<variant> = nil); static;
  end;

//var
  //name: String;
  //rows: TList<TDictionary<String, variant>>;

implementation

{ TSQLite }

class function TSQLite.scalar(sql: String; params: TArray<variant> = nil): variant;
var
  i: byte;
begin
  Result:=Null;

  // params before of SQL.Text
  _qry.Params.Clear;

  _qry.SQL.Text:=sql;
  if (Assigned(params)) then
  begin
    for i:=0 to Length(params) - 1 do
      _qry.Params[i].Value:=params[i];
  end;
  try
    try
      _qry.Open;
      if (_qry.RecordCount > 0) then
        Result:=_qry.Fields[0].Value;
    except
      on e: Exception do
        Writeln('Error: ' + e.Message);
    end;
  finally
    _con.Close(true);
  end;
end;

class function TSQLite.query(
  sql: String;
  params: TArray<variant>
): TList<TDictionary<String, variant>>;
type
  TDictionaryStrVar = TDictionary<String, variant>;
var
  i: byte;
  dic: TDictionaryStrVar;
begin
  Result:=TList<TDictionaryStrVar>.Create; // empty

  // params before of SQL.Text
  _qry.Params.Clear;

  _qry.SQL.Text:=sql;
  if (Assigned(params)) then
  begin
    for i:=0 to Length(params) - 1 do
      _qry.Params[i].Value:=params[i];
  end;
  try
    try
      _qry.Open;
      while (not _qry.EOF) do
      begin
        dic:=TDictionaryStrVar.Create;
        for i:=0 to _qry.Fields.Count - 1 do
          dic.Add(_qry.Fields[i].FieldName, _qry.Fields[i].Value);
        Result.Add(dic);
        _qry.Next;
      end;
    except
      on e: Exception do
        Writeln('Error: ' + e.Message);
    end;
  finally
    _con.Close(true);
  end;
end;

class procedure TSQLite.execute(sql: String; params: TArray<variant>);
var
  i: byte;
begin
  // params before of SQL.Text
  _qry.Params.Clear;

  _qry.SQL.Text:=sql;
  if (Assigned(params)) then
  begin
    for i:=0 to Length(params) - 1 do
      _qry.Params[i].Value:=params[i];
  end;
  try
    try
      _qry.ExecSQL;
    except
      on e: Exception do
        Writeln('Error: ' + e.Message);
    end;
  finally
    _con.Close(true);
  end;
end;

initialization
  TSQLite._lib:=TSQLDBLibraryLoader.Create(nil);
  TSQLite._lib.ConnectionType:='SQLite3';
  TSQLite._lib.LibraryName:='./libsqlite3.so';
  TSQLite._lib.Enabled:=true;

  TSQLite._con:=TSQLite3Connection.Create(nil);
  TSQLite._con.DatabaseName:='./database.db';
  TSQLite._con.Params.Add('foreign_keys=on'); // important! for work foreign keys

  TSQLite._tra:=TSQLTransaction.Create(nil);
  TSQLite._tra.SQLConnection:=TSQLite._con;

  TSQLite._qry:=TSQLQuery.Create(nil);
  TSQLite._qry.SQLConnection:=TSQLite._con;
  TSQLite._qry.Transaction:=TSQLite._tra;
  TSQLite._qry.Options:=[sqoAutoCommit];

  // test connection
  {
  TSQLite._qry.SQL.Text:='SELECT * FROM users';
  TSQLite._qry.Open;
  writeln(TSQLite._qry.Fields[1].AsString);
  TSQLite._con.Close(true);
  }

  // scalar: variant
  {
  name := TSQLite.executeScalar('SELECT name FROM users WHERE id = :id', [0]);
  Writeln(name);
  }

  // query: TList<TDictionary<String, variant>>
  {
  rows:=TSQLite.query('SELECT * FROM users');
  Writeln(rows[0]['name']);
  Writeln(rows[1]['name']);
  }

  // execute: void
  //TSQLite.execute('INSERT INTO users(name, pass) VALUES(:name, :pass)', ['user2', '2']);
end.

