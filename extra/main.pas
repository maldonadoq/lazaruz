unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, ColorBox, Grids, ParseMath,
  TAChartUtils, TATools, TACustomSeries, Math;

type
  ER = record
    sol: string;
    rs: real;
  end;

type

  { TfrmGraficadora }

  TfrmGraficadora = class(TForm)
    Eval: TButton;
    YT: TEdit;
    Lineal: TEdit;
    Exponencial: TEdit;
    Senoidal: TEdit;
    Logaritmo: TEdit;
    RL: TEdit;
    RE: TEdit;
    RLN: TEdit;
    RS: TEdit;
    XT: TEdit;
    PlotearS: TLineSeries;
    Run: TButton;
    Load: TButton;
    Graf: TButton;
    chrGrafica: TChart;
    Area: TAreaSeries;
    Txt: TEdit;
    Func: TEdit;
    Funcion: TFuncSeries;
    GroupBox1: TGroupBox;
    Plotear: TLineSeries;
    cboxColorFuncion: TColorBox;
    ediIntervalo: TEdit;
    EjeX: TConstantLine;
    EjeY: TConstantLine;
    Men: TPanel;
    Data: TStringGrid;
    procedure EvalClick(Sender: TObject);
    procedure GrafClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoadClick(Sender: TObject);
    procedure RunClick(Sender: TObject);
    procedure ShowSol();
    procedure TxtChange(Sender: TObject);

  private
    { private declarations }
    Parse: TparseMath;
    Xminimo, Xmaximo: string;
    Vapx: array[0..3] of ER;
    Xpr, Ypr: real;

    function f(x: double; sf: string): double;
    procedure DetectarIntervalo();
    procedure GraficarFuncion();
    procedure GraficarPoint();
    procedure ELineal();
    procedure EExponencial();
    procedure ELogaritmo();
    procedure ESenoidal();
    function R(s: string): real;
  public
    { public declarations }
  end;

var
  frmGraficadora: TfrmGraficadora;

implementation

{$R *.lfm}

{ TfrmGraficadora }

procedure TfrmGraficadora.DetectarIntervalo();
var
  PosCorcheteIni, PosCorcheteFin, PosSeparador: integer;
  PosicionValidad: boolean;
const
  CorcheteIni = '[';
  CorcheteFin = ']';
  Separador = ';';

begin

  PosCorcheteIni := Pos(CorcheteIni, ediIntervalo.Text);
  PosCorcheteFin := pos(CorcheteFin, ediIntervalo.Text);
  PosSeparador := Pos(Separador, ediIntervalo.Text);

  PosicionValidad := (PosCorcheteIni > 0);
  PosicionValidad := PosicionValidad and (PosSeparador > 2);
  PosicionValidad := PosicionValidad and (PosCorcheteFin > 3);

  if not PosicionValidad then
  begin
    ShowMessage('Error en el intervalo');
    exit;
  end;
  Xminimo := Copy(ediIntervalo.Text, PosCorcheteIni + 1,
    PosSeparador - 2);
  Xminimo := Trim(Xminimo);
  Xmaximo := Copy(ediIntervalo.Text, PosSeparador + 1,
    Length(ediIntervalo.Text) - PosSeparador - 1);

  Xmaximo := Trim(Xmaximo);
end;

function TfrmGraficadora.f(x: double; sf: string): double;
begin
  parse.Expression := sf;
  Parse.NewValue('x', x);
  Result := Parse.Evaluate();
end;

procedure TfrmGraficadora.GraficarFuncion();
var
  h, xmin, xmax: real;
begin
  Plotear.ShowPoints := False;
  Plotear.LinePen.Color := cboxColorFuncion.Colors[cboxColorFuncion.ItemIndex];
  h := 0.01;
  xmin := StrToFloat(Xminimo);
  xmax := StrToFloat(Xmaximo);
  while (xmin < xmax) do
  begin
    Plotear.AddXY(xmin, Self.f(xmin, Func.Text));
    xmin := xmin + h;
  end;
  Plotear.Active := True;
end;

procedure TfrmGraficadora.GraficarPoint();
var
  i: integer;
begin
  PlotearS.ShowPoints := True;
  PlotearS.LinePen.Color := cboxColorFuncion.Colors[15];

  for i := 1 to Data.RowCount - 1 do
  begin
    PlotearS.AddXY(StrToFloat(Data.Cells[0, i]), StrToFloat(Data.Cells[1, i]));
  end;
  PlotearS.Active := True;
end;

procedure TfrmGraficadora.GrafClick(Sender: TObject);
begin
  Plotear.Clear;
  PlotearS.Clear;
  if Trim(Func.Text) = '' then
    exit;

  DetectarIntervalo();
  GraficarFuncion();
  GraficarPoint();
end;

procedure TfrmGraficadora.FormDestroy(Sender: TObject);
begin
  Parse.Destroy;
end;

procedure TfrmGraficadora.ShowSol();
begin
  Lineal.Text      := Vapx[0].sol; RL.Text  := FloatToStr(Vapx[0].rs);
  Exponencial.Text := Vapx[1].sol; RE.Text  := FloatToStr(Vapx[1].rs);
  Logaritmo.Text   := Vapx[2].sol; RLN.Text := FloatToStr(Vapx[2].rs);
  Senoidal.Text    := Vapx[3].sol; RS.Text  := FloatToStr(Vapx[3].rs);
end;

procedure TfrmGraficadora.TxtChange(Sender: TObject);
begin

end;

procedure TfrmGraficadora.FormCreate(Sender: TObject);
begin
  Parse := TparseMath.Create;
  parse.AddVariable('x', 0.0);
  Data.Cells[0, 0] := 'x';
  Data.Cells[1, 0] := 'y';
  //Parse.AddVariable('y',0.0);
end;

procedure TfrmGraficadora.LoadClick(Sender: TObject);
var
  nam: string;
  i: integer;
begin
  nam := Txt.Text;
  Data.LoadFromCSVFile(nam);
  Xpr := 0;
  Ypr := 0;
  for i := 1 to Data.RowCount - 1 do
  begin
    Xpr := Xpr + StrToFloat(Data.Cells[0, i]);
    Ypr := Ypr + StrToFloat(Data.Cells[1, i]);
  end;
  Xpr := Xpr / (Data.RowCount-1);
  Ypr := Ypr / (Data.RowCount-1);
end;

procedure TfrmGraficadora.RunClick(Sender: TObject);
begin
  Self.ELineal();
  Self.EExponencial();
  Self.ELogaritmo();
  //Self.ESenoidal();
  Self.ShowSol();
end;

function TfrmGraficadora.R(s: string): real;
var
  i: integer;
  fs, ss: real;
begin
  fs := 0; ss := 0;
  for i:=1 to Data.RowCount-1 do begin
    fs:= fs+power(Self.f(StrToFloat(Data.Cells[0,i]), s)-Ypr,2);
    ss:= ss+power(StrToFloat(Data.Cells[1,i])-Ypr,2);
  end;
  Result := sqrt(fs/ss);
end;

procedure TfrmGraficadora.ELineal();
var
  i: integer;
  fs, ss: real;
  solc: string;
begin
  fs := 0;
  ss := 0;
  for i := 1 to Data.RowCount - 1 do
  begin
    fs := fs + ((StrToFloat(Data.Cells[1, i]) - Ypr) * (StrToFloat(Data.Cells[0, i]) - Xpr));
    ss := ss + power(Xpr - StrToFloat(Data.Cells[0, i]), 2);
  end;
  solc := '(' + FloatToStr(fs / ss) + '*x)+' + FloatToStr(Ypr - ((fs / ss) * Xpr));

  Vapx[0].sol := solc;
  Vapx[0].rs := Self.R(solc);
end;


procedure TfrmGraficadora.EExponencial();
var
  i: integer;
  Ytpr, c, A, fs, ss: real;
  solc: string;
  tmp: array of real;
begin
  SetLength(tmp, Data.RowCount - 1);
  Ytpr := 0;
  for i := 1 to Data.RowCount - 1 do
  begin
    if(StrToFloat(Data.Cells[1,i])<= 0) then begin
      Vapx[1].sol := '';
      Vapx[1].rs := 0;
      exit;
    end;
    tmp[i - 1] := Ln(StrToFloat(Data.Cells[1,i]));
    Ytpr := Ytpr + tmp[i - 1];
  end;
  Ytpr := Ytpr / Length(tmp);
  fs := 0;
  ss := 0;
  for i := 1 to Data.RowCount - 1 do
  begin
    fs := fs + ((tmp[i - 1] - Ytpr) * (StrToFloat(Data.Cells[0, i]) - Xpr));
    ss := ss + power(Xpr - StrToFloat(Data.Cells[0, i]), 2);
  end;
  c := fs/ss;
  A := exp(Ytpr-(c*Xpr));
  solc := FloatToStr(A)+'*exp(x*'+FloatToStr(c)+')';

  Vapx[1].sol := solc;
  Vapx[1].rs := Self.R(solc);
end;

procedure TfrmGraficadora.ELogaritmo();
var
  i,t: integer;
  xtm,ytm,slny,sln,slnp,m,b: real;
  solc: string;
begin
  t:= Data.RowCount-1;
  slny:=0; sln:=0; slnp:=0;
  for i:=1 to t do begin
    xtm:= StrTofloat(Data.Cells[0,i]);
    ytm:= StrTofloat(Data.Cells[1,i]);
    if(xtm<= 0) then begin
      Vapx[2].sol := '';
      Vapx[2].rs := 0;
      exit;
    end;
    slny:= slny+(Ln(xtm)*ytm);
    sln:= sln+Ln(xtm);
    slnp:= slnp+power(Ln(xtm),2);
  end;
  WriteLn();

  m:= (slny-(Ypr*sln))/(slnp-((sln/t)*sln));
  b:= Ypr-(m*(sln/t));

  if(b<0) then
    solc:= '('+floatToStr(m)+'*ln(x))-'+FloatToStr(Abs(b))
  else
    solc:= '('+floatToStr(m)+'*ln(x))+'+FloatToStr(b);

  Vapx[2].sol := solc;
  Vapx[2].rs := Self.R(solc);
end;

procedure TfrmGraficadora.ESenoidal();
var
  i,j,p: integer;
  xma,xmi,a,k,d,c: real;
  solc: string;
begin
  xma:= StrToFloat(Data.Cells[1,1]);
  xmi:= xma; j:= 1;
  for i:=2 to Data.RowCount-1 do begin
    if(StrToFloat(Data.Cells[1,i])<xmi) then
      xmi:= StrToFloat(Data.Cells[1,i]);
    if(StrToFloat(Data.Cells[1,i])>xma) then begin
      xma:= StrToFloat(Data.Cells[1,i]);
      j:= i;
    end;
  end;
  a:= (xma-xmi)/2;
  // periodo = 12 (por meses, es variable!)
  p:= 12;
  k:= (2*3.14159261)/p;
  d:= j-(p/4);
  c:= xma-a;

  if(d<0) then
    solc:= FloatToStr(c)+'+('+FloatToStr(a)+'*sin('+FloatTostr(k)+'*(x+'+FloatToStr(Abs(d))+')))'
  else
    solc:= FloatToStr(c)+'+('+FloatToStr(a)+'*sin('+FloatTostr(k)+'*(x-'+FloatToStr(d)+')))';

  WriteLn(solc);
  Vapx[3].sol := solc;
  //Vapx[3].rs := Self.R(solc);
end;

procedure TfrmGraficadora.EvalClick(Sender: TObject);
begin
  YT.Text:= FloatToStr(Self.f(StrToFloat(XT.Text),Func.Text));
end;

end.
