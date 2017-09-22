unit MMatriz;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  RD = record
    T: boolean;
    D: real;
  end;

type
    TMatriz = class
      public
        x,y: integer;
        m: array of array of real;
        constructor Create(x_, y_: integer);
        destructor Destroy(); override;
        function Trans(): TMatriz;
        function Det(): RD;
        function Cof(a: TMatriz; r,c: integer): real;
        function Inverse(a: real): TMatriz;
        function Adjunta(): TMatriz;
        function Esc(a: real): TMatriz;
    end;

Operator *(a,b: TMatriz): TMatriz;
Operator +(a,b: TMatriz): TMatriz;
Operator -(a,b: TMatriz): TMatriz;

implementation

constructor TMatriz.Create(x_,y_: integer);
var i,j: integer;
begin
     x:= x_;
     y:= y_;
     SetLength(m,x,y);
     for i:=0 to x-1 do
         for j:=0 to y-1 do
             m[i,j]:= 0;
end;

destructor TMatriz.Destroy();
begin
end;

function TMatriz.Trans(): TMatriz;
var i,j: integer;
begin
     Result:= TMatriz.Create(Self.y,Self.x);
     for i:=0 to Self.x-1 do
         for j:=0 to Self.y-1 do
             Result.m[j,i]:= Self.m[i,j];
end;

function TMatriz.Cof(a: TMatriz; r,c: integer): real;
var i,j,i1,j1: integer;
var MT: TMatriz;
begin
     MT:= TMatriz.Create(a.x-1,a.x-1);
     i1:=0; j1:=0;
     for i:=0 to a.x-1 do begin
         for j:=0 to a.x-1 do begin
             if (i<>r) and (j<>c) then begin
                 MT.m[i1,j1]:= a.m[i,j];
                 j1:= j1+1;
                 if (j1>=(a.x-1)) then begin
                     i1:=i1+1;
                     j1:=0;
                 end;
             end;
         end;
     end;
     Result:= (Power(-1,r+c))*(MT.Det().D);
     MT.Destroy();
end;

function TMatriz.Det(): RD;
var i: integer;
begin
     Result.T:= True;
     if Self.x <> Self.y then
        Result.T:= False
     else if Self.x = 1 then
        Result.D:= Self.m[0,0]
     else if Self.x = 2 then
        Result.D:= (Self.m[0,0]*Self.m[1,1])-(Self.m[0,1]*Self.m[1,0])
     else begin
        for i:=0 to Self.x-1 do
            Result.D:= Result.D+(Self.m[0,i]*Self.Cof(Self,0,i));
     end;
end;

function TMatriz.Inverse(a: real): TMatriz;
var i,j: integer;
begin
     Result:= TMatriz.Create(Self.x,Self.y);
     for i:=0 to Result.x-1 do
         for j:=0 to Result.y-1 do
             Result.m[i,j]:= Self.Cof(Self,i,j)/a;

     Result:= Result.Trans();
end;

function TMatriz.Esc(a: real): TMatriz;
var i,j: integer;
begin
     Result:= TMatriz.Create(Self.x,Self.y);
     for i:=0 to Result.x-1 do
         for j:=0 to Result.y-1 do
             Result.m[i,j]:= Self.m[i,j]*a;
end;

function TMatriz.Adjunta(): TMatriz;
var i,j: integer;
begin
     Result:= TMatriz.Create(Self.x,Self.y);
     for i:=0 to Result.x-1 do
         for j:=0 to Result.y-1 do
             Result.m[i,j]:= Self.Cof(Self,i,j);
end;

Operator +(a,b: TMatriz): TMatriz;
var i,j: integer;
begin
  if (a.x = b.x) and (a.y = b.y) then
  begin
    Result:= TMatriz.Create(a.x,a.y);
    for i:=0 to a.x-1 do
        for j:=0 to a.y-1 do
            Result.m[i,j]:= a.m[i,j] + b.m[i,j]
  end
  else
  begin
      Result:= TMatriz.Create(0,0);
  end;
end;

Operator -(a,b: TMatriz): TMatriz;
var i,j: integer;
begin
  if (a.x = b.x) and (a.y = b.y) then
  begin
    Result:= TMatriz.Create(a.x,a.y);
    for i:=0 to a.x-1 do
        for j:=0 to a.y-1 do
            Result.m[i,j]:= a.m[i,j] - b.m[i,j]
  end
  else
  begin
      WriteLn('Order of Matrix are Different');
      Result:= TMatriz.Create(0,0);
  end;
end;

Operator *(a,b: TMatriz): TMatriz;
var i,j,k: integer;
begin
  if a.y = b.x then
  begin
      Result:= TMatriz.Create(a.x,b.y);
      for i:=0 to Result.x-1 do
          for j:=0 to Result.y-1 do
              for k:=0 to a.y-1 do
                  Result.m[i,j]:= Result.m[i,j]+(a.m[i,k]*b.m[k,j]);
  end
  else
  begin
      WriteLn('Order of Matrix are Different');
      Result:= TMatriz.Create(0,0);
  end;
end;

end.

