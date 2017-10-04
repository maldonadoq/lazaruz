unit se;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, MMatriz;

type

  { TForm1 }

  TForm1 = class(TForm)
    Ok: TButton;
    Cal: TButton;
    NE: TEdit;
    Pop: TGroupBox;
    BL: TGroupBox;
    BU: TGroupBox;
    SO: TGroupBox;
    Resu: TStringGrid;
    Sis: TStringGrid;
    SL: TStringGrid;
    Splitter1: TSplitter;
    SU: TStringGrid;
    procedure OkClick(Sender: TObject);
    procedure CalClick(Sender: TObject);
    procedure LoadMA();
    procedure LoadMO();
    procedure ShowL(a: TMatriz);
    procedure ShowU(a: TMatriz);
    procedure ShowS(a: array of real);
  private

  public

  end;

var
  Form1: TForm1;
  MATA: TMatriz;
  MATR: array of real;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.LoadMA();
var i,j,n: integer;
begin
     n:= Sis.RowCount;
     MATA:= TMatriz.Create(n,n);
     for i:=0 to n-1 do begin
       for j:=0 to n-1 do begin
         MATA.m[i,j]:= StrToFloat(Sis.Cells[j,i]);
       end;
     end;
end;

procedure TForm1.LoadMO();
var i,n: integer;
begin
     n:= Sis.RowCount;
     SetLength(MATR,n);
     for i:=0 to n-1 do
       MATR[i]:= StrToFloat(Sis.Cells[n,i]);
end;

procedure TForm1.ShowL(a: TMatriz);
var i,j: integer;
begin
     SL.RowCount:= a.x;
     SL.ColCount:= a.y;
     for i:=0 to a.x-1 do begin
       for j:=0 to a.y-1 do begin
           SL.Cells[j,i] := FloatToStr(a.m[i,j]);
       end;
     end;
end;

procedure TForm1.ShowU(a: TMatriz);
var i,j: integer;
begin
     SU.RowCount:= a.x;
     SU.ColCount:= a.y;
     for i:=0 to a.x-1 do begin
       for j:=0 to a.y-1 do begin
           SU.Cells[j,i] := FloatToStr(a.m[i,j]);
       end;
     end;
end;

procedure TForm1.ShowS(a: array of real);
var i: integer;
begin
     Resu.Clear;
     for i:=0 to Length(a)-1 do begin
         Resu.RowCount := Resu.RowCount+1;
         Resu.Cells[0,i] := FloatToStr(a[i]);
     end;
end;

procedure TForm1.OkClick(Sender: TObject);
begin
     Sis.RowCount:= StrToInt(NE.Text);
     Sis.ColCount:= StrToInt(NE.Text)+1;
end;

procedure TForm1.CalClick(Sender: TObject);
var L,U: TMatriz;
begin
     Self.LoadMA(); Self.LoadMO();
     //MATA.Re(0,MATR);
     L:= TMatriz.Create(MATA.x,MATA.y);
     U:= TMatriz.Create(MATA.x,MATA.y);
     //Descomposición LU
     MATA.Dlu(L,U);
     ShowL(L); ShowU(U);
     ShowS(MATA.Se(L,U,MATR));
     L.Destroy();  U.Destroy();
end;

end.

