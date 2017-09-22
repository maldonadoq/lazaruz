unit ST;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, MMath, Func, Crt;

type
  TTaylor = class
    public
      n: integer;
      pi: real;
      pr: real;
      constructor Create();
      destructor Destroy(); override;
      procedure Menu();
      function Exp(a: integer): ER;
      function Sin(a: real): ER;
      function Cos(a: real): ER;
      function Ln(a: real): ER;
      function Arctg(a: real): ER;
      function Sinh(a: real): ER;
      function Cosh(a: real): ER;
  end;

implementation

constructor TTaylor.Create();
begin
     pi:= 3.141592654;
     pr:= 0.000001;
end;

destructor TTaylor.Destroy();
begin
end;

procedure TTaylor.Menu();
var t: boolean = true;
var s: integer;
var x: real;
begin
     while(t) do
     begin
       WriteLn('[1]: Exp(x)    [2]: Ln(x)');
       WriteLn('[3]: Sin(x)    [4]: Cos(x)');
       WriteLn('[5]: Arctg(x)  [6]: Sinh(x)');
       WriteLn('[7]: Cosh(x)   [0]: Exit');
       Write('[s]:   '); ReadLn(s);
       Case s of
            1: begin
              WriteLn('[    Exp Dom: R      ]');
              Write('x: '); ReadLn(x);
              Print(Self.Exp(Trunc(x)));
            end;
            2: begin
              WriteLn('[    Ln Dom: ]0,2]   ]');
              Write('x: '); ReadLn(x);
              Print(Self.Ln(x));
            end;
            3: begin
              WriteLn('[    Sin Dom: R      ]');
              Write('x: '); ReadLn(x);
              Print(Self.Sin(x));
            end;
            4: begin
              WriteLn('[    Cos Dom: R      ]');
              Write('x: '); ReadLn(x);
              Print(Self.Cos(x));
            end;
            5: begin
              WriteLn('[  Arctg Dom: [-57,57] ]');
              Write('x: '); ReadLn(x);
              Print(Self.Arctg(x));
            end;
            6: begin
              WriteLn('[    Sinh Dom: R     ]');
              Write('x: '); ReadLn(x);
              Print(Self.Sinh(x));
            end;
            7: begin
              WriteLn('[    Cosh Dom: R     ]');
              Write('x: '); ReadLn(x);
              Print(Self.Cosh(x));
            end;
            0: begin
                t:= false;
	        Halt;
            end;
       end;
     end;
end;

function TTaylor.Exp(a: integer): ER;
var i: integer = 1;
var Rt: real;
begin
     Result.Valor:= 1;
     Result.Ea:= (Self.pr+1);
     while (Self.pr < Result.Ea) do
     begin
         Rt:= Result.Valor;
         Result.Valor:= Result.Valor + (Pow(a,i)/Factorial(i));
         Result.Ea:=Abs(Result.Valor-Rt);
         i:=i+1;
     end;
     Result.Er:=Abs(Result.Ea/Result.Valor);
end;

function TTaylor.Ln(a: real): ER;
var i: integer = 1;
var Rt: real;
begin
     if(a=1) then begin
       Result.Valor:=0.0
     end
     else if(a>0) and (a<=2) then begin
       Result.Valor:= 0;
       Result.Ea:= (Self.pr+1);
       while (Self.pr < Result.Ea) do
       begin
           Rt:= Result.Valor;
           if (i mod 2) = 0 then
               Result.Valor:= Result.Valor - (Pow(a-1,i)/(i))
           else
               Result.Valor:= Result.Valor + (Pow(a-1,i)/(i));
           Result.Ea:=Abs(Result.Valor-Rt);
           i:=i+1;
       end;
       Result.Er:=Abs(Result.Ea/Result.Valor);
     end
     else
         WriteLn('Fuera del Radio de convergencia');
end;

function TTaylor.Sin(a: real): ER;
var i: integer = 1;
var j: integer;
var Rt: real;
begin
     a:= (a*Self.pi)/180;
     Result.Valor:= a;
     Result.Ea:= (Self.pr+1);
     while (Self.pr < Result.Ea) do
     begin
         Rt:= Result.Valor;
         j:= ((2*i)+1);
         if (i mod 2) = 0 then
              Result.Valor:= Result.Valor + (Pow(a,j)/Factorial(j))
         else
              Result.Valor:= Result.Valor - (Pow(a,j)/Factorial(j));
         Result.Ea:=Abs(Result.Valor-Rt);
         i:=i+1;
     end;
     Result.Er:=Abs(Result.Ea/Result.Valor);
end;

function TTaylor.Cos(a: real): ER;
var i: integer = 1;
var Rt: real;
begin
     a:= (a*Self.pi)/180;
     Result.Valor:= 1;
     Result.Ea:= (Self.pr+1);
     while (Self.pr < Result.Ea) do
     begin
         Rt:= Result.Valor;
         if (i mod 2) = 0 then
             Result.Valor:= Result.Valor + (Pow(a,2*i)/Factorial(2*i))
         else
             Result.Valor:= Result.Valor - (Pow(a,2*i)/Factorial(2*i));
         Result.Ea:=Abs(Result.Valor-Rt);
         i:=i+1;
     end;
     Result.Er:=Abs(Result.Ea/Result.Valor);
end;

function TTaylor.Arctg(a: real): ER;
var i: integer = 1;
var Rt: real;
begin
     if(a>=-57) and (a<=57) then begin
       a:= (a*Self.pi)/180;
       Result.Valor:= a;
       Result.Ea:= (Self.pr+1);
       while (Self.pr < Result.Ea) do
       begin
         Rt:= Result.Valor;
         if (i mod 2) = 0 then
             Result.Valor := Result.Valor + (Pow(a,(2*i)+1)/((2*i)+1))
         else
             Result.Valor := Result.Valor - (Pow(a,(2*i)+1)/((2*i)+1));
         Result.Ea:=Abs(Result.Valor-Rt);
         i:=i+1;
       end;
       Result.Er:=Abs(Result.Ea/Result.Valor);
     end
     else
         WriteLn('Fuera del radio de convergencia');
end;

function TTaylor.Sinh(a: real): ER;
var i: integer = 1;
var Rt: real;
begin
     a:= (a*Self.pi)/180;
     Result.Valor:= a;
     Result.Ea:= (Self.pr+1);
     while (Self.pr < Result.Ea) do
     begin
         Rt:= Result.Valor;
         Result.Valor:= Result.Valor + (Pow(a,(2*i)+1)/Factorial((2*i)+1));
         Result.Ea:=Abs(Result.Valor-Rt);
         WriteLn(Result.Ea);
         i:= i+1;
     end;
     Result.Er:=Abs(Result.Ea/Result.Valor);
end;

function TTaylor.Cosh(a: real): ER;
var i: integer = 1;
var Rt: real;
begin
     a:= (a*Self.pi)/180;
     Result.Valor:= 1;
     Result.Ea:= (Self.pr+1);
     while (Self.pr < Result.Ea) do
     begin
         Rt:= Result.Valor;
         Result.Valor:= Result.Valor + (Pow(a,2*i)/Factorial(2*i));
         Result.Ea:=Abs(Result.Valor-Rt);
         i:=i+1;
     end;
     Result.Er:=Abs(Result.Ea/Result.Valor);
end;

end.

