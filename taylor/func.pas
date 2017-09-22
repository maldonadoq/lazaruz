unit Func;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  ER = record
    Valor: real;
    Ea: real;
    Er: real;
    Rp: real;
  end;

procedure Print(v: ER);
implementation

procedure Print(v: ER);
begin

  Write('Val: '); WriteLn(v.Valor);
  Write('EA:  '); WriteLn(v.Ea);
  Write('ER:  '); WriteLn(v.Er);
  Write('ERP: '); WriteLn(v.Er*100);
  WriteLn;
end;

end.

