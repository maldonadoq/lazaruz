unit MMath;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Func;

const pi = 3.14159261;

function Abs(a: real): real;
function Factorial(a: integer): real;
function Pow(a: real; b: integer): real;
function Bisecc(a, b: real; n: integer): ER;
function FalPos(a, b: real; n: integer): ER;

implementation

function f(a: real): real;
begin
     Result:= (pi*Pow(a,2)*(9-a) - 90);
end;

function Bisecc(a, b: real; n: integer): ER;
var Rt: real;
var i: integer;
var s: real;
begin
     for i:=0 to n-1 do
     begin
       Rt:= Result.Valor;
       Result.Valor:= (a+b)/2;
       Result.Ea:= Abs(Rt-Result.Valor);
       Result.Er:= Abs(Result.Ea/Result.Valor);

       WriteLn(IntToStr(i)+'  '+FloatToStr(a)+'  '+FloatToStr(b)+'  '+
       FloatToStr(Result.Valor)+'  '+FloatToStr(Result.Ea)+'  '+
       FloatToStr(Result.Er)+'  '+FloatToStr(Result.Er*100)+'(%)');
       s:= f(a)*f(Result.Valor);
       if(s<0) then
           b:= Result.Valor
       else
           a:= Result.Valor;
     end;
     Result.Ea:= Abs(Rt-Result.Valor);
     Result.Er:= Abs(Result.Ea/Result.Valor);
end;

function FalPos(a, b: real; n: integer): ER;
var Rt: real;
var i: integer;
var s: real;
begin
     for i:=0 to n-1 do
     begin
       Rt:= Result.Valor;
       Result.Valor:= (b-((f(b)*(a-b))/(f(a)-f(b))));
       Result.Ea:= Abs(Rt-Result.Valor);
       Result.Er:= Abs(Result.Ea/Result.Valor);

       WriteLn(IntToStr(i)+'  '+FloatToStr(a)+'  '+FloatToStr(b)+'  '+
       FloatToStr(Result.Valor)+'  '+FloatToStr(Result.Ea)+'  '+
       FloatToStr(Result.Er)+'  '+FloatToStr(Result.Er*100)+'(%)');
       s:= f(a)*f(Result.Valor);
       if(s<0) then
           b:= Result.Valor
       else
           a:= Result.Valor;
     end;
     Result.Ea:= Abs(Rt-Result.Valor);
     Result.Er:= Abs(Result.Ea/Result.Valor);
end;

function Abs(a: real): real;
begin
     Result:= a;
     if a<0 then
         Result:= 0-a;
end;

function Factorial(a: integer): real;
var i: integer;
begin
  Result:=1;
  for i:=1 to a do
      Result:= Result*i;
end;

function Pow(a: real; b: integer): real;
var i: integer;
begin
     Result:= 1;
     for i:=1 to b do
         Result:= Result*a;
end;

end.

