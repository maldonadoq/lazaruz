unit usenl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, MMatriz, Math, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    BP: TGroupBox;
    BPn: TGroupBox;
    BxP: TGroupBox;
    FXP: TButton;
    AB: TGroupBox;
    PD: TGroupBox;
    SD: TButton;
    DTF: TStringGrid;
    SECNL: TStringGrid;
    TE: TEdit;
    CNE: TLabel;
    DI: TStringGrid;
    TER: TLabel;
    Newton: TButton;
    ER: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FXPClick(Sender: TObject);
    procedure NewtonClick(Sender: TObject);
    procedure SDClick(Sender: TObject);
    function Jacob(a: TMatriz; h: real): TMatriz;
    function FX(a: TMatriz): TMatriz;
    function Distance(a,b: TMatriz): real;
    procedure LoadMP();
    procedure LoadS();
  private

  public

  end;

type
  TSF = class
  public
    constructor Create();
    destructor Destroy(); override;
    function SF(ec: string; x: TMatriz): real;
    //function STF(f: integer; x: TMatriz): real;
    function SFF(x: TMatriz): TMatriz;
    function SDP(f,v: integer; x: TMatriz; h: real): real;
  end;

var
  Form1: TForm1;
  MP: array of real;
  MATJ: TMatriz;
  MParse: TParseMath;
  VX: array of string;
  ECNL: array of string;

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

procedure TForm1.FormCreate(Sender: TObject);
var n: integer;
begin
  n:= 12;
  SetLength(VX,n);
  VX[0]:= 'a';  VX[1]:= 'b';  VX[2]:= 'c';
  VX[3]:= 'd';  VX[4]:= 'e';  VX[5]:= 'f';
  VX[6]:= 'g';  VX[7]:= 'h';  VX[8]:= 'i';
  VX[9]:= 'j';  VX[10]:= 'k';  VX[11]:= 'l';
end;

function TSF.SF(ec: string; x: TMatriz): real;
var i: integer;
begin
     for i:=0 to x.x-1 do
       MParse.NewValue(VX[i],x.m[i,0]);
     MParse.Expression:= ec;
     Result := MParse.Evaluate();
end;

function TSF.SFF(x: TMatriz): TMatriz;
var i,n: integer;
begin
     n:= x.x;
     Result := TMatriz.Create(n,1);
     for i:=0 to n-1 do begin
        Result.m[i,0] := Self.SF(ECNL[i],x);
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
     Result:= (Self.SF(ECNL[f],xi)-Self.SF(ECNL[f],xj))/(2*h);
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
       Result.m[i,0] := m.SF(ECNL[i],a);
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

procedure TForm1.LoadS();
var i,n: integer;
begin
     n:= SECNL.RowCount;
     SetLength(ECNL,n);
     for i:=0 to n-1 do
       ECNL[i]:= SECNL.Cells[0,i];
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
     Self.LoadS();
     Self.LoadMP();
     n:= StrToFloat(ER.Text);
     m := TSF.Create();
     Ea:= n+1; j := 1;
     t := True;

     DTF.Clear;
     DTF.RowCount := 1; DTF.ColCount:= Length(MP)+2;
     DTF.Cells[0,0] := 'i';  DTF.Cells[Length(MP)+1,0] := 'Ea';
     for i:=1 to Length(MP) do
         DTF.Cells[i,0] := IntToStr(i);
     VM := VtoM(MP);
     while(n<Ea) and (t=True) do begin
       DTF.RowCount := DTF.RowCount+1;
       TMP := VM;
       MATJ := Self.Jacob(VM,0.0001);
       det := MATJ.Det();
       if(det.D <> 0) then begin
         PR := MATJ.Inverse(det.D);
         FT := m.SFF(VM);
         VM := VM-(PR*FT);

         for i:=1 to VM.x do begin
             DTF.Cells[i,j] := FloatToStr(VM.m[i-1][0]);
         end;
         Ea := Self.Distance(TMP,VM);
         DTF.Cells[0,j] := IntToStr(j);
         DTF.Cells[VM.x+1,j] := FloatToStr(Ea);
         j := j+1;
       end
       else begin
           t := False;
           ShowMessage('Determinante en la iteración '+IntToStr(j-1)+' es 0');
       end;
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
     Self.LoadS();
     n:= StrToFloat(ER.Text);
     m := TSF.Create();
     Ea:= n+1; j := 1;

     DTF.RowCount := 1; DTF.ColCount:= Length(MP)+2;
     DTF.Cells[0,0] := 'i';  DTF.Cells[Length(MP)+1,0] := 'Ea';
     for i:=1 to Length(MP) do
         DTF.Cells[i,0] := IntToStr(i);
     VM := VtoM(MP);
     while(n<Ea) do begin
       DTF.RowCount := DTF.RowCount+1;
       TMP := VM;
       VM := Self.FX(VM);

       for i:=1 to VM.x do begin
             DTF.Cells[i,j] := FloatToStr(VM.m[i-1][0]);
       end;

       Ea := Self.Distance(TMP,VM);
       DTF.Cells[0,j] := IntToStr(j);
       DTF.Cells[VM.x+1,j] := FloatToStr(Ea);
       j := j+1;
     end;
     m.Destroy();
end;

procedure TForm1.SDClick(Sender: TObject);
var
  i,n: integer;
begin
    n := StrToInt(TE.Text);
    MParse:= TParseMath.create();
    DI.RowCount:= 1;  DI.ColCount:= n;
    SECNL.RowCount:= n; SECNL.ColCount:= 1;
    for i:= 0 to n-1 do begin
        MParse.AddVariable(VX[i],0.0);
    end;
end;

end.

