unit usenl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, MMatriz, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Box: TGroupBox;
    BPn: TGroupBox;
    FXP: TButton;
    PD: TGroupBox;
    ERD: TGroupBox;
    SD: TButton;
    DTF: TStringGrid;
    TE: TEdit;
    CNE: TLabel;
    SB: TStringGrid;
    DI: TStringGrid;
    TER: TLabel;
    Newton: TButton;
    ER: TEdit;
    Men: TPanel;
    procedure FXPClick(Sender: TObject);
    procedure NewtonClick(Sender: TObject);
    procedure SDClick(Sender: TObject);
    procedure ShoN();
    function Jacob(a: TMatriz; h: real): TMatriz;
    function FX(a: TMatriz): TMatriz;
    function Distance(a,b: TMatriz): real;
    procedure LoadMP();
  private

  public

  end;

type
  TSF = class
  public
    constructor Create();
    destructor Destroy(); override;
    function a(x: TMatriz): real;
    function b(x: TMatriz): real;
    function c(x: TMatriz): real;
    function d(x: TMatriz): real;
    function SF(f: integer; x: TMatriz): real;
    function STF(f: integer; x: TMatriz): real;
    function SFF(x: TMatriz): TMatriz;
    function SDP(f,v: integer; x: TMatriz; h: real): real;
  end;

var
  Form1: TForm1;
  MP: array of real;
  MATJ: TMatriz;

implementation

{$R *.lfm}

{ TForm1 }


function MtoV(a: TMatriz): vect;
var i: integer;
begin
     SetLength(Result,a.x);
     for i:=0 to a.x-1 do
       Result[i] := a.m[i,0];
end;

function VtoM(a: array of real): TMatriz;
var i: integer;
begin
     Result := TMatriz.Create(Length(a),1);
     for i:=0 to Length(a)-1 do
       Result.m[i,0] := a[i];
end;

constructor TSF.Create();
begin
end;

destructor TSF.Destroy();
begin
end;

procedure TForm1.ShoN();
begin
     SB.RowCount:=1;
     SB.ColCount:=4;
     SB.Cells[0,0]:= 'i';   SB.Cells[1,0]:= 'Ea';
     SB.Cells[2,0]:= 'Er';    SB.Cells[3,0]:= 'Er(%)';
end;

function TSF.a(x: TMatriz): real;
begin
     //Result := x[0]*x[1]*x[2] + 2*x[3];
     //Result := (5*x.m[0,0]*x.m[0,0]) + (3*x.m[0,0]*x.m[1,0]) - 2;
     Result :=  power(x.m[0,0],2) - (2*x.m[1,0]) + (3*x.m[2,0]) -17;
end;

function TSF.b(x: TMatriz): real;
begin
     //Result := x[1]*x[3] + x[0]*x[2];
     //Result := (x.m[0,0]*x.m[0,0]) + (7*x.m[1,0]*x.m[1,0]) + (3*x.m[0,0]*x.m[1,0])- 10;
     Result := x.m[0,0] - (x.m[0,0]*x.m[1,0]) - x.m[2,0] + 7;
end;

function TSF.c(x: TMatriz): real;
begin
     //Result := x.m[1,0]*x.m[1,0]*x.m[1,0] - x.m[0,0] + x.m[2,0]*x.m[3,0];
     Result := x.m[0,0] + x.m[1,0] + (4*x.m[2,0]) - 21;
end;

function TSF.d(x: TMatriz): real;
begin
     Result := x.m[1,0]*x.m[0,0] + x.m[3,0]*x.m[2,0]*x.m[2,0];
end;

function TSF.SF(f: integer; x: TMatriz): real;
begin
     case f of
          0: begin
             Result:= Self.a(x);
          end;
          1: begin
             Result:= Self.b(x);
          end;
          2: begin
             Result:= Self.c(x);
          end;
          3: begin
             Result:= Self.d(x);
          end;
     end;
end;

{trampa}
function TSF.STF(f: integer; x: TMatriz): real;
begin
     case f of
          0: begin
             Result:= sqrt(17+(2*x.m[1,0])-(3*x.m[2,0]));
          end;
          1: begin
             Result:= (-x.m[0,0]+x.m[2,0]-7)/(-x.m[0,0]);
          end;
          2: begin
             Result:= (21-x.m[0,0]-x.m[1,0])/4;
          end;
          3: begin
             Result:= Self.d(x);
          end;
     end;
end;


function TSF.SFF(x: TMatriz): TMatriz;
var i,n: integer;
begin
     n:= x.x;
     Result := TMatriz.Create(n,1);
     for i:=0 to n-1 do begin
        Result.m[i,0] := Self.SF(i,x);
     end;
end;

function TSF.SDP(f,v: integer; x: TMatriz; h: real): real;
var
  i: integer;
  xi, xj: TMatriz;
begin
     h:= h/10;
     xi:= TMatriz.Create(x.x,1);  xj:= TMatriz.Create(x.x,1);
     for i:=0 to x.x-1 do begin
         xi.m[i,0] := x.m[i,0];
         xj.m[i,0] := x.m[i,0];
     end;

     xi.m[v,0]:= xi.m[v,0]+h;  xj.m[v,0]:= xj.m[v,0]-h;
     case f of
          0: begin
             Result:= (Self.a(xi)-Self.a(xj))/(2*h);
          end;
          1: begin
             Result:= (Self.b(xi)-Self.b(xj))/(2*h);
          end;
          2: begin
             Result:= (Self.c(xi)-Self.c(xj))/(2*h);
          end;
          3: begin
             Result:= (Self.d(xi)-Self.d(xj))/(2*h);
          end;
     end;
end;

function TForm1.Jacob(a: TMatriz; h: real): TMatriz;
var
  i,j,s: integer;
  m: TSF;
begin
     s := a.x;
     m := TSF.Create;
     Result := TMatriz.Create(s,s);
     for i:=0 to s-1 do begin
       for j:=0 to s-1 do begin
           Result.m[i,j] := m.SDP(i,j,a,h);
       end;
     end;
     m.Destroy;
end;

function TForm1.FX(a: TMatriz): TMatriz;
var
  i: integer;
  m: TSF;
begin
     m := TSF.Create();
     Result := TMatriz.Create(a.x,1);
     for i:=0 to a.x-1 do begin
       Result.m[i,0] := m.STF(i,a);
     end;
     m.Destroy();
end;

procedure TForm1.LoadMP();
var i,n: integer;
begin
     n:= DI.ColCount;
     SetLength(MP,n);
     for i:=0 to n-1 do
       MP[i]:= StrToFloat(DI.Cells[i,0]);
end;

function TForm1.Distance(a,b: TMatriz): real;
var i: integer;
begin
     Result := 0;
     for i:=0 to a.x-1 do begin
         Result := Result+power(a.m[i,0]-b.m[i,0],2);
     end;
     Result := Sqrt(Result);
end;

procedure TForm1.NewtonClick(Sender: TObject);
var
  t: boolean;
  Ea, n: real;
  VM, PR, FT, TMP: TMatriz;
  m: TSF;
  det: RD;
  i,j: integer;
begin
     Self.LoadMP();
     Self.ShoN();
     n:= StrToFloat(ER.Text);
     m := TSF.Create();
     Ea:= n+1; j := 1;
     t := True;

     DTF.Clear;
     DTF.RowCount := 1; DTF.ColCount:= Length(MP);
     for i:=0 to Length(MP)-1 do
         DTF.Cells[i,0] := IntToStr(i+1);
     VM := VtoM(MP);
     while(n<Ea) and (t=True) do begin
       SB.RowCount := SB.RowCount+1;
       DTF.RowCount := DTF.RowCount+1;
       TMP := VM;
       MATJ := Self.Jacob(VM,0.0001);
       det := MATJ.Det();
       if(det.D <> 0) then begin
         PR := MATJ.Invers();
         FT := m.SFF(VM);
         VM := VM-(PR*FT);

         for i:=0 to VM.x-1 do begin
             DTF.Cells[i,j] := FloatToStr(VM.m[i][0]);
         end;

         Ea := Self.Distance(TMP,VM);
         SB.Cells[0,j]:= FloatToStr(j);
         SB.Cells[1,j]:= FloatToStr(Ea);
         SB.Cells[2,j]:= FloatToStr(0);
         SB.Cells[3,j]:= FloatToStr(0);
         j := j+1;
       end
       else
           t := False;
     end;
     m.Destroy();
end;

procedure TForm1.FXPClick(Sender: TObject);
var
  Ea, n: real;
  VM, TMP: TMatriz;
  m: TSF;
  i,j: integer;
begin
     Self.LoadMP();
     Self.ShoN();
     n:= StrToFloat(ER.Text);
     m := TSF.Create();
     Ea:= n+1; j := 1;

     DTF.Clear;
     DTF.RowCount := 1; DTF.ColCount:= Length(MP);
     for i:=0 to Length(MP)-1 do
         DTF.Cells[i,0] := IntToStr(i+1);
     VM := VtoM(MP);
     while(n<Ea) do begin
       SB.RowCount := SB.RowCount+1;
       DTF.RowCount := DTF.RowCount+1;
       TMP := VM;
       VM := Self.FX(VM);

       for i:=0 to VM.x-1 do begin
           DTF.Cells[i,j] := FloatToStr(VM.m[i][0]);
       end;

       Ea := Self.Distance(TMP,VM);
       SB.Cells[0,j]:= FloatToStr(j);
       SB.Cells[1,j]:= FloatToStr(Ea);
       SB.Cells[2,j]:= FloatToStr(0);
       SB.Cells[3,j]:= FloatToStr(0);
       j := j+1;
     end;
     m.Destroy();
end;

procedure TForm1.SDClick(Sender: TObject);
begin
     DI.RowCount:= 1;
     DI.ColCount:= StrToInt(TE.Text);
end;

end.

