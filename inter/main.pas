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
    GR: TButton;
    TR: TLabel;
    TN: TLabel;
    ND: TEdit;
    TRA: TButton;
    RAR: TEdit;
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

    procedure GraficarFuncion();
    procedure GraficarFuncionConPloteo();
    procedure Grap();
    procedure GRClick(Sender: TObject);
    procedure INTClick(Sender: TObject);
    procedure LAGClick(Sender: TObject);
    procedure NEWTClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure Get();
    procedure Pull();
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
begin
  Parse := TparseMath.create;
  parse.AddVariable('x',0.0);
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
    lg := '('+FloatToStr(VP[i].y)+'*';
    c:= 0;
    rs:=1.0;
    for j:=0 to n-1 do begin
      if(i<>j) then begin
        c:= c+1;
        lg := lg+'(x';
        if(VP[j].x <0) then
            lg:= lg +'+'
        else
            lg:= lg +'-';
        lg:= lg + FloatToStr(Abs(VP[j].x))+')';
        rs:= rs*(VP[i].x-VP[j].x);
        if(c<>n-1) then
          lg:= lg+'*';
      end;
    end;
    lg := lg + '/'+FloatToStr(rs)+')';
    if(i<(n-1)) then
        lg := lg +'+';
    plg := plg + lg;
  end;
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
     n := StrToFloat(ND.Text); a := StrToFloat(AB.Text); b := StrToFloat(AA.Text);
     h := (b-a)/n;
     r := (Self.f(a)+Self.f(b))/2;
     a := a+h;

     while(a < b) do begin
       r := r + Self.f(a);
       a := a + h;
     end;
     RAR.Text := FloatToStr(h*r);
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

