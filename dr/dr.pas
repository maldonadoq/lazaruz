unit DR;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TDR = class
    constructor Create();
    destructor Destroy(); override;
    function DOR(a,h: real): real;
    function DPA(var x: array of real; h: real; n: integer): real;
  end;

implementation

function f(var v: array of real): real;
begin
     Result:= (2*v[0])+(v[0]*v[1])+v[2];
end;

function g(a: real): real;
begin
     Result:= a*a*a;
end;

constructor TDR.Create();
begin
end;

destructor TDR.Destroy();
begin
end;

function TDR.DOR(a,h: real): real;
begin
     Result:= (g(a+h)-g(a-h))/(2*h);
end;

function TDR.DPA(var x: array of real; h: real; n: integer): real;
begin
     h:= h/10;
     x[n-1]:= x[n-1]+h;
     Result:= f(x);
     x[n-1]:= x[n-1]-h;
     h:= 2*h;
     Result:= (Result-f(x))/h;
end;

end.
