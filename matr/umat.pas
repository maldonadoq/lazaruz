unit umat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, Menus, MMatriz;

type

  { TForm1 }

  TForm1 = class(TForm)
    AdA: TButton;
    Esc: TButton;
    TEs: TEdit;
    Pow: TButton;
    Pw: TEdit;
    MainMenu1: TMainMenu;
    Archivo: TMenuItem;
    Abrir: TMenuItem;
    Guardar: TMenuItem;
    MenuItem4: TMenuItem;
    Salir: TMenuItem;
    Info: TMenuItem;
    Autor: TMenuItem;
    PTB: TButton;
    InvB: TButton;
    DetB: TButton;
    Ran: TButton;
    TraB: TButton;
    Sum: TButton;
    Res: TButton;
    Pro: TButton;
    InvA: TButton;
    TraA: TButton;
    DetA: TButton;
    CMA: TButton;
    CMB: TButton;
    LRA: TLabel;
    LCA: TLabel;
    LRB: TLabel;
    LCB: TLabel;
    RA: TEdit;
    CA: TEdit;
    RB: TEdit;
    CB: TEdit;
    MA: TGroupBox;
    MB: TGroupBox;
    DMA: TPanel;
    DMB: TPanel;
    RS: TGroupBox;
    OMenu: TPanel;
    MMA: TStringGrid;
    MMB: TStringGrid;
    MMRS: TStringGrid;
    procedure AbrirClick(Sender: TObject);
    procedure AdAClick(Sender: TObject);
    procedure CMAClick(Sender: TObject);
    procedure CMBClick(Sender: TObject);
    procedure DetAClick(Sender: TObject);
    procedure DetBClick(Sender: TObject);
    procedure EscClick(Sender: TObject);
    procedure GuardarClick(Sender: TObject);
    procedure InvAClick(Sender: TObject);
    procedure InvBClick(Sender: TObject);
    procedure AutorClick(Sender: TObject);
    procedure PowClick(Sender: TObject);
    procedure ProClick(Sender: TObject);
    procedure PTBClick(Sender: TObject);
    procedure RanClick(Sender: TObject);
    procedure ResClick(Sender: TObject);
    procedure SalirClick(Sender: TObject);
    procedure SumClick(Sender: TObject);
    procedure TraAClick(Sender: TObject);
    procedure TraBClick(Sender: TObject);
    procedure ShowM(a: TMatriz);
    procedure LoadMA();
    procedure LoadMB();
  private

  public

  end;

var
  Form1: TForm1;
  MATA: TMatriz;
  MATB: TMatriz;
  MATR: TMatriz;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.LoadMA();
var i,j,ra1,ca1: integer;
begin
     ra1:= MMA.RowCount; ca1:= MMA.ColCount;
     MATA:= TMAtriz.Create(ra1,ca1);
     for i:=0 to ra1-1 do begin
       for j:=0 to ca1-1 do begin
         MATA.m[i,j]:= StrToFloat(MMA.Cells[j,i]);
       end;
     end;
end;

procedure TForm1.LoadMB();
var i,j,rb1,cb1: integer;
begin
     rb1:= MMB.RowCount; cb1:= MMB.ColCount;
     MATB:= TMAtriz.Create(rb1,cb1);
     for i:=0 to rb1-1 do begin
       for j:=0 to cb1-1  do begin
         MATB.m[i,j]:= StrToFloat(MMB.Cells[j,i]);
       end;
     end;
end;

procedure TForm1.ShowM(a: TMatriz);
var i,j: integer;
begin
     MMRS.RowCount:= a.x;
     MMRS.ColCount:= a.y;
     for i:=0 to a.x-1 do begin
       for j:=0 to a.y-1 do begin
           MMRS.Cells[j,i] := FloatToStr(a.m[i,j]);
       end;
     end;
end;

procedure TForm1.RanClick(Sender: TObject);
var i,j,ra1,ca1,rb1,cb1: integer;
begin
     rb1:= MMB.RowCount; cb1:= MMB.ColCount;
     for i:=0 to rb1-1 do begin
       for j:=0 to cb1-1  do begin
         MMB.Cells[j,i]:= IntToStr(random(10));
       end;
     end;

     ra1:= MMA.RowCount; ca1:= MMA.ColCount;
     for i:=0 to ra1-1 do begin
       for j:=0 to ca1-1 do begin
         MMA.Cells[j,i]:= IntToStr(random(10));
       end;
     end;
end;

procedure TForm1.CMAClick(Sender: TObject);
begin
     MMA.RowCount:= StrToInt(RA.Text);
     MMA.ColCount:= StrToInt(CA.Text);
end;

procedure TForm1.AbrirClick(Sender: TObject);
begin
  MMA.LoadFromFile('dataa.xml');
  MMB.LoadFromFile('datab.xml');
end;


procedure TForm1.CMBClick(Sender: TObject);
begin
     MMB.RowCount:= StrToInt(RB.Text);
     MMB.ColCount:= StrToInt(CB.Text);
end;

procedure TForm1.DetAClick(Sender: TObject);
var Z: RD;
begin
     Self.LoadMA();
     Z:= MATA.Det();
     if (Z.T = False) then
         ShowMessage('No es Matriz Cuadrada')
     else begin
         ShowMessage('Determinante de A: '+FloatToStr(Z.D));
     end;
end;

procedure TForm1.DetBClick(Sender: TObject);
var Z: RD;
begin
     Self.LoadMB();
     Z:= MATB.Det();
     if (Z.T = False) then
         ShowMessage('No es Matriz Cuadrada')
     else begin
         ShowMessage('Determinante de B: '+FloatToStr(Z.D));
     end;
end;

procedure TForm1.EscClick(Sender: TObject);
var n: real;
begin
     n:= StrToFloat(TEs.Text);
     Self.LoadMA();
     MATR:= MATA.Esc(n);
     ShowM(MATR);
end;

procedure TForm1.GuardarClick(Sender: TObject);
begin
    MMA.SaveToFile('dataa.xml');
    MMB.SaveToFile('datab.xml');
end;

procedure TForm1.InvAClick(Sender: TObject);
var Z: RD;
begin
    Self.LoadMA();
    Z:= MATA.Det();
    if (Z.T = False) or (Z.D = 0) then
       ShowMessage('No tiene Inversa')
    else begin
       MATR:= MATA.Inverse(Z.D);
       ShowM(MATR);
    end;
end;

procedure TForm1.InvBClick(Sender: TObject);
var Z: RD;
begin
    Self.LoadMB();
    Z:= MATB.Det();
    if (Z.T = False) or (Z.D = 0) then
       ShowMessage('No tiene Inversa')
    else begin
       MATR:= MATB.Inverse(Z.D);
       ShowM(MATR);
    end;
end;

procedure TForm1.AdAClick(Sender: TObject);
begin
    Self.LoadMA();
    if(MATA.x <> MATA.y) then
       ShowMessage('No tiene Adjunta')
    else begin
       MATR:= MATA.Adjunta();
       ShowM(MATR);
    end;
end;

procedure TForm1.AutorClick(Sender: TObject);
begin
  ShowMessage('Percy Maldonado Quispe'+LineEnding+'UCSP-PERÚ');
end;

procedure TForm1.ProClick(Sender: TObject);
begin
     Self.LoadMA(); Self.LoadMB();
     MATR := MATA*MATB;
     if (MATR.x=0) and (MATR.y=0) then
        ShowMessage('No se Puede Multiplicar'+LineEnding+'Matrices de Orden Diferente')
     else
        ShowM(MATR);
end;

procedure TForm1.PowClick(Sender: TObject);
var n: integer;
begin
     Self.LoadMA();
     n:= StrToInt(Pw.Text);
     if (MATA.x <> MATA.y) then
        ShowMessage('No es una Matriz Cuadrada')
     else begin
        MATR:= MATA;
        While(n>1) do begin
            MATR:= MATR*MATA;
            n:=n-1;
        end;
        ShowM(MATR);
     end;
end;

procedure TForm1.PTBClick(Sender: TObject);
var i,j: integer;
begin
     MMB.RowCount := MMRS.RowCount;
     MMB.ColCount := MMRS.ColCount;
     for i:=0 to MMB.RowCount-1 do begin
       for j:=0 to MMB.ColCount-1  do begin
         MMB.Cells[j,i]:= MMRS.Cells[j,i];
       end;
     end;
end;

procedure TForm1.ResClick(Sender: TObject);
begin
     Self.LoadMA(); Self.LoadMB();
     MATR := MATA-MATB;
     if (MATR.x=0) and (MATR.y=0) then
        ShowMessage('   No se Puede Restar'+LineEnding+'Matrices de Orden Diferente')
     else
        ShowM(MATR);
end;

procedure TForm1.SalirClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.SumClick(Sender: TObject);
begin
     Self.LoadMA(); Self.LoadMB();
     MATR := MATA+MATB;
     if (MATR.x=0) and (MATR.y=0) then
         ShowMessage('   No se Puede Sumar'+LineEnding+'Matrices de Orden Diferente')
     else
        ShowM(MATR);
end;

procedure TForm1.TraAClick(Sender: TObject);
begin
     Self.LoadMA();
     MATR:= MATA.Trans();
     ShowM(MATR);
end;

procedure TForm1.TraBClick(Sender: TObject);
begin
     Self.LoadMB();
     MATR:= MATB.Trans();
     ShowM(MATR);
end;

end.

