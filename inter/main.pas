unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, ColorBox, Grids, ParseMath,
  TAChartUtils, TASources, TATools, TACustomSeries;

type

  { TfrmGraficadora }

  TfrmGraficadora = class(TForm)
    btnGraficar: TButton;
    AR: TButton;
    F1: TEdit;
    F2: TEdit;
    GEN: TButton;
    RARG: TEdit;
    RARO: TEdit;
    Gauss: TButton;
    OP: TButton;
    SimpsonI: TButton;
    SimpsonII: TButton;
    RARS: TEdit;
    RARSI: TEdit;
    GR: TButton;
    TN: TLabel;
    ND: TEdit;
    TRA: TButton;
    RART: TEdit;
    OK: TButton;
    LAG: TButton;
    NEWT: TButton;
    NP: TEdit;
    INT: TButton;
    chkUsarPloteo: TCheckBox;
    chrGrafica: TChart;
    FUN: TComboBox;
    Area: TAreaSeries;
    AA: TEdit;
    AB: TEdit;
    INX: TEdit;
    INY: TEdit;
    Funcion: TFuncSeries;
    GRA: TGroupBox;
    DPOS: TStringGrid;
    TX: TLabel;
    TY: TLabel;
    TA: TLabel;
    TB: TLabel;
    PAN: TGroupBox;
    ST: TGroupBox;
    MN: TGroupBox;
    DPO: TGroupBox;
    MEN: TGroupBox;
    Plotear: TLineSeries;
    cboxColorFuncion: TColorBox;
    ediIntervalo: TEdit;
    EjeX: TConstantLine;
    EjeY: TConstantLine;
    procedure ARClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncionCalculate(const AX: Double; out AY: Double);
    procedure GaussClick(Sender: TObject);
    procedure GENClick(Sender: TObject);

    procedure GraficarFuncion();
    procedure GraficarFuncionConPloteo();
    procedure Grap();
    procedure GRClick(Sender: TObject);
    procedure INTClick(Sender: TObject);
    procedure LAGClick(Sender: TObject);
    procedure NEWTClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure Get();
    procedure OPClick(Sender: TObject);
    procedure Pull();
    procedure SimpsonIClick(Sender: TObject);
    procedure SimpsonIIClick(Sender: TObject);
    procedure TRAClick(Sender: TObject);

  private
    { private declarations }
    Parse  : TparseMath;
    Xminimo,
    Xmaximo: String;

    function f( x: Double ): Double;
    Procedure DetectarIntervalo();

  public
    { public declarations }
  end;

type
  TPoint = class
    public
      x,y: real;
      constructor Create(x_, y_: real);
      destructor Destroy(); override;
end;

type
  TPoint3 = class
    public
      xl,xr,f: real;
      constructor Create(f_, xl_, xr_: real);
      destructor Destroy(); override;
end;

var
  frmGraficadora: TfrmGraficadora;
  VP: array of TPoint;
  VP3: array of TPoint3;
  LG: array of real;
  WL: array of real;

implementation

{$R *.lfm}

{ TfrmGraficadora }

constructor TPoint.Create(x_,y_: real);
begin
  x:= x_;
  y:= y_;
end;

constructor TPoint3.Create(f_, xl_, xr_: real);
begin
  f:= f_;
  xl:= xl_;
  xr:= xr_;
end;

destructor TPoint.Destroy();
begin
end;

destructor TPoint3.Destroy();
begin
end;

procedure TfrmGraficadora.Get();
var i, n: integer;
begin
  n:= DPOS.ColCount;
  SetLength(VP,n);
  for i:=0 to n-1 do
    VP[i] := TPoint.Create(StrToFloat(DPOS.Cells[i,0]),StrToFloat(DPOS.Cells[i,1]));
end;

procedure TfrmGraficadora.Pull();
var n,i: integer;
begin
  n:= DPOS.ColCount;
  SetLength(VP3,n);
  for i:=0 to n-1 do
    VP3[i] := TPoint3.Create(StrToFloat(DPOS.Cells[i,1]),StrToFloat(DPOS.Cells[i,0]),StrToFloat(DPOS.Cells[i,0]));
end;

Procedure TfrmGraficadora.DetectarIntervalo();
var
    PosCorcheteIni, PosCorcheteFin, PosSeparador: Integer;
    PosicionValidad: Boolean;
    i: Integer;
    x: Double;
const
   CorcheteIni = '[';
   CorcheteFin = ']';
   Separador = ';';

begin

 PosCorcheteIni:= Pos( CorcheteIni, ediIntervalo.Text );
 PosCorcheteFin:= pos( CorcheteFin, ediIntervalo.Text );
 PosSeparador:= Pos( Separador, ediIntervalo.Text  );

 PosicionValidad:= ( PosCorcheteIni > 0);
 PosicionValidad:= PosicionValidad and ( PosSeparador > 2);
 PosicionValidad:= PosicionValidad and ( PosCorcheteFin > 3);

 if not PosicionValidad then begin
        ShowMessage( 'Error en el intervalo');
        exit;

 end;

  Xminimo:= Copy( ediIntervalo.Text,
                      PosCorcheteIni + 1,
                      PosSeparador - 2 );

  Xminimo:= Trim( Xminimo );
  Xmaximo:= Copy( ediIntervalo.Text,
                      PosSeparador + 1,
                      Length( ediIntervalo.Text ) - PosSeparador -1  );

 Xmaximo:= Trim( Xmaximo );

end;

function TfrmGraficadora.f( x: Double ): Double;
begin
     parse.Expression:= FUN.Text;
     Parse.NewValue('x' , x );
     Result:= Parse.Evaluate();
end;


Procedure TfrmGraficadora.GraficarFuncion();
begin
    Plotear.Clear;
    with Funcion do begin
      Active:= False;


      Extent.XMax:= StrToFloat( Xmaximo );
      Extent.XMin:= StrToFloat( Xminimo );

      Extent.UseXMax:= true;
      Extent.UseXMin:= true;
      Funcion.Pen.Color:=  cboxColorFuncion.Colors[ cboxColorFuncion.ItemIndex ];

      Active:= True;

  end;
end;

Procedure TfrmGraficadora.GraficarFuncionConPloteo();
var i: Integer;
    Max, Min, h, NewX, NewY: Real;
    IsInIntervalArea: Boolean;
begin
    Funcion.Active:= False;
    Area.Active:= False;

    Max:=  StrToFloat( Xmaximo );
    Min:=  StrToFloat( Xminimo ) ;

    h:= abs( ( Max - Min )/( 100 * Max ) );
    Plotear.Marks.Style:= smsNone;

    NewX:= StrToFloat( Xminimo );
    Plotear.LinePen.Color:= cboxColorFuncion.Colors[ cboxColorFuncion.ItemIndex ];  ;

    while NewX < Max do begin
       NewY:= f( NewX );
       Plotear.AddXY( NewX, NewY );
       IsInIntervalArea:= ( NewX >= StrToFloat( AA.Text ) ) and (  NewX <= StrToFloat( AB.Text )) ;
       if IsInIntervalArea then
          Area.AddXY( NewX, NewY );
       NewX:= NewX + h;

    end;

    Plotear.Active:= true;

end;

procedure TfrmGraficadora.Grap();
begin
 Area.Clear;
 Plotear.Clear;

 if Trim( FUN.Text ) = '' then
    exit;

 DetectarIntervalo();

 if chkUsarPloteo.Checked then
    GraficarFuncionConPloteo()

 else
    GraficarFuncion();

end;

procedure TfrmGraficadora.GRClick(Sender: TObject);
begin
  Self.Grap();
end;

procedure TfrmGraficadora.ARClick(Sender: TObject);
begin
 Area.Active:= true;
end;


procedure TfrmGraficadora.FormCreate(Sender: TObject);
var n: integer;
begin
  Parse := TparseMath.create;
  parse.AddVariable('x',0.0);
  n:= 5;
  SetLength(LG,n); SetLength(WL,n);
  LG[0]:= 0; WL[0]:= 0.568888888888889;
  LG[1]:= -0.538469310105683; WL[1]:= 0.478628670499366;
  LG[2]:= 0.538469310105683; WL[2]:= 0.478628670499366;
  LG[3]:= -0.906179845938664; WL[3]:= 0.236926885056189;
  LG[4]:= 0.906179845938664; WL[4]:= 0.236926885056189;
end;

procedure TfrmGraficadora.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
end;

procedure TfrmGraficadora.FuncionCalculate(const AX: Double; out AY: Double);
begin
  AY := f( AX ) ;
end;

procedure TfrmGraficadora.LAGClick(Sender: TObject);
var
  i,j,c,n: integer;
  rs: real;
  plg, lg: string;
begin
  plg:= '';
  Self.Get();
  n:= DPOS.ColCount;

  for i:=0 to n-1 do begin
    if(VP[i].y <> 0) then begin
      lg := '('+FloatToStr(VP[i].y)+'*';
      rs:=1.0;
      for j:=0 to n-1 do begin
        if(i<>j) then begin
          lg := lg+'(x';
          if(VP[j].x <0) then
              lg:= lg +'+'
          else
              lg:= lg +'-';
          lg:= lg + FloatToStr(Abs(VP[j].x))+')*';
          rs:= rs*(VP[i].x-VP[j].x);
        end;
      end;
      SetLength(lg,Length(lg)-1);
      lg := lg + '/'+FloatToStr(rs)+')+';
      plg := plg + lg;
    end;
  end;
  SetLength(plg,Length(plg)-1);
  FUN.Text := plg;
  Self.Grap();
end;

procedure TfrmGraficadora.NEWTClick(Sender: TObject);
var
  n,i,j: integer;
  pt, tm: array of TPoint3;
  cn: array of real;
  xt: real;
  pn, sn: string;
begin
  Self.Get();
  Self.Pull();
  pt:= VP3;
  pn:= '';

  n:= DPOS.ColCount;
  SetLength(cn,n);
  cn[0]:= VP[0].y;

  for i:=0 to n-2 do begin
    SetLength(tm,n-i-1);
    for j:=0 to Length(pt)-2 do begin
      xt:= (pt[j+1].f-pt[j].f)/(pt[j+1].xr-pt[j].xl);
      tm[j]:= TPoint3.Create(xt,pt[j].xl,pt[j+1].xr);
    end;
    cn[i+1]:= tm[0].f;
    pt:= tm;
  end;

  for i:=0 to n-1 do begin
    if(cn[i]<>0) then begin
      sn:='('+FloatToStr(cn[i])+'*';
      for j:=0 to i-1 do begin
        sn:= sn+'(x';
        if(VP[j].x = 0) then begin
          SetLength(sn,Length(sn)-2);
          sn:= sn+'x*'
        end
        else begin
          if(VP[j].x<0) then
              sn:= sn + '+'
          else
              sn:= sn + '-';
          sn:= sn+FloatToStr(Abs(VP[j].x))+')*';
        end;
      end;
      SetLength(sn,Length(sn)-1);
      sn:= sn+')';
      pn:= pn+sn+'+';
    end;
  end;
  SetLength(pn,Length(pn)-1);
  FUN.Text := pn;
  Self.Grap();
end;

procedure TfrmGraficadora.TRAClick(Sender: TObject);
var n,a,b,h,r: real;
begin
     n := StrToFloat(ND.Text); a := StrToFloat(AA.Text); b := StrToFloat(AB.Text);
     h := (b-a)/n;
     r := (Self.f(a)+Self.f(b))/2;
     a := a+h;

     while(a < b) do begin
       r := r + Self.f(a);
       a := a + h;
     end;
     RART.Text := FloatToStr(h*r);
end;

procedure TfrmGraficadora.SimpsonIClick(Sender: TObject);
var
  s,a,b,h,r: real;
  n,nt,i: integer;
  xim: array of real;
begin
     n:= StrToInt(ND.Text); a:= StrToFloat(AA.Text); b:= StrToFloat(AB.Text);
     h:= (b-a)/(2*n);
     r:= Self.f(a) + Self.f(b);
     nt:= (2*n)+1; s:=0;
     SetLength(xim,nt);
     for i:=0 to nt-1 do begin
       xim[i]:= Self.f(a);
       a:= a+h;
     end;

     for i:=1 to n-1 do   s:= s+xim[2*i];
     r:= r+(2*s); s:= 0;
     for i:=0 to n-1 do   s:= s+xim[(2*i)+1];
     r:= r+(4*s);
     RARS.Text := FloatToStr((r*h)/3);
end;

procedure TfrmGraficadora.SimpsonIIClick(Sender: TObject);
var
  n,nt,i: integer;
  r,s,a,b,h: real;
  xim: array of real;
begin
     n:= StrToInt(ND.Text); a:= StrToFloat(AA.Text); b:= StrToFloat(AB.Text);
     h:= (b-a)/(3*n);
     r:= 0; s:=0;
     nt:= (3*n)+1;
     SetLength(xim,nt);
     for i:=0 to nt-1 do begin
       xim[i]:= Self.f(a);
       a:= a+h;
     end;

     for i:=1 to n do  r:= r+xim[3*(i-1)]+xim[3*i];
     for i:=1 to n do  s:= s+xim[(3*i)-2]+xim[(3*i)-1];
     r:= r+(3*s);
     RARSI.Text:= FloatToStr((3*h*r)/8);
end;

procedure TfrmGraficadora.OPClick(Sender: TObject);
var
  i,n: integer;
  r,h,a,b: real;
begin
     n:= StrToInt(ND.Text); a:= StrToFloat(AA.Text); b:= StrToFloat(AB.Text);
     h:= (b-a)/n;
     r:= 0;
     for i:=0 to n-2 do begin
       r:= r+Self.f((a+a+h)/2);
       a:= a+h;
     end;
     RARO.Text:= FloatToStr(h*r);
end;

procedure TfrmGraficadora.GaussClick(Sender: TObject);
var
  i,n: integer;
  r,a,b,tm: real;
  pl: array of real;
begin
     a:= StrToFloat(AA.Text); b:= StrToFloat(AB.Text);
     n:= 5; tm:= b-a;
     r:=0;
     for i:=0 to n-1 do
       r:= r+(WL[i]*Self.f(((LG[i]*tm)+b+a)/2));
     RARG.Text:= FloatToStr((tm*r)/2);
end;

procedure TfrmGraficadora.GENClick(Sender: TObject);
begin
     FUN.Text:= 'abs(('+F1.Text+')-('+F2.Text+'))';
end;

procedure TfrmGraficadora.INTClick(Sender: TObject);
var x: real;
begin
  x := StrToFloat(INX.Text);
  INY.Text:= FloatToStr(Self.f(x));
end;

procedure TfrmGraficadora.OKClick(Sender: TObject);
var n: integer;
begin
 n:= StrToInt(NP.Text);
 DPOS.ColCount:= n;
end;

end.

