unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, ColorBox, Grids, ParseMath,
  TAChartUtils, TATools, TACustomSeries, TADrawUtils;

type

  { TfrmGraficadora }

  TfrmGraficadora = class(TForm)
    PlotearS: TLineSeries;
    DY: TEdit;
    DX: TEdit;
    SOL: TEdit;
    GRA: TButton;
    EU: TButton;
    chrGrafica: TChart;
    Area: TAreaSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    N: TEdit;
    EDO: TEdit;
    Funcion: TFuncSeries;
    GroupBox1: TGroupBox;
    STRR: TStringGrid;
    TN: TLabel;
    TEDO: TLabel;
    Panel1: TPanel;
    Plotear: TLineSeries;
    cboxColorFuncion: TColorBox;
    ediIntervalo: TEdit;
    EjeX: TConstantLine;
    EjeY: TConstantLine;
    procedure EUClick(Sender: TObject);
    procedure GRAClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncionCalculate(const AX, AY: Double; s: string; out AF: Double);
    Procedure GraficarFuncionConPloteo();

  private
    { private declarations }
    Parse  : TparseMath;
    Xminimo, Xmaximo: String;

    function f(x,y: Double; s: string): Double;
    Procedure DetectarIntervalo();

  public
    { public declarations }
  end;

var
  frmGraficadora: TfrmGraficadora;

implementation

{$R *.lfm}

{ TfrmGraficadora }

Procedure TfrmGraficadora.DetectarIntervalo();
var
    PosCorcheteIni, PosCorcheteFin, PosSeparador: Integer;
    PosicionValidad: Boolean;
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

function TfrmGraficadora.f(x,y: Double; s: string): Double;
begin
     parse.Expression:= s;
     Parse.NewValue('x', x);
     Parse.NewValue('y', y);
     Result:= Parse.Evaluate();
end;

Procedure TfrmGraficadora.GraficarFuncionConPloteo();
var
    i: Integer;
begin
    Funcion.Active:= False;
    //Plotear.Marks.Style:= smsValue;
    Plotear.ShowPoints:= false; PlotearS.ShowPoints:= false;

    Plotear.LinePen.Color:= cboxColorFuncion.Colors[cboxColorFuncion.ItemIndex];
    PlotearS.LinePen.Color:= cboxColorFuncion.Colors[1];

    if(SOL.Text <> '') then begin
      for i:=1 to STRR.RowCount-1 do begin
         PlotearS.AddXY(StrToFloat(STRR.Cells[1,i]), StrToFloat(STRR.Cells[4,i]));
      end;
    end;

    for i:=1 to STRR.RowCount-1 do begin
       Plotear.AddXY(StrToFloat(STRR.Cells[1,i]), StrToFloat(STRR.Cells[3,i]));
    end;
    Plotear.Active:= true;
    PlotearS.Active:= true;
end;

procedure TfrmGraficadora.GRAClick(Sender: TObject);
begin
 Plotear.Clear;
 PlotearS.Clear;
 if STRR.RowCount<2 then
    exit;

 DetectarIntervalo();
 Self.GraficarFuncionConPloteo();
end;

procedure TfrmGraficadora.Button1Click(Sender: TObject);
begin
 Area.Active:= true;
end;

procedure TfrmGraficadora.FormCreate(Sender: TObject);
begin
  Parse := TparseMath.create;
  parse.AddVariable('x',0.0);
  Parse.AddVariable('y',0.0);
end;

procedure TfrmGraficadora.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
end;

procedure TfrmGraficadora.FuncionCalculate(const AX, AY: Double; s: string; out AF: Double);
begin
  AF := Self.f(AX,AY,s);
end;

procedure TfrmGraficadora.EUClick(Sender: TObject);
var
    h,xi,xf, xti, yti, yt, myti, myt, tmp: real;
    nt, i: integer;
begin
    nt:= StrToInt(N.Text);
    Self.DetectarIntervalo();
    xi:= StrToFloat(Self.Xminimo); xf:= StrToFloat(Self.Xmaximo);
    h:= (xf-xi)/nt;
    if(DX.Text = Self.Xminimo) then
      h:= h
    else if(DX.Text = Self.Xmaximo) then
      h:= 0-h
    else begin
        ShowMessage('Punto Inicial Mal');
        exit;
    end;

    STRR.Clear();
    STRR.RowCount:= 2;
    STRR.Cells[0,0]:= 'n';  STRR.Cells[1,0]:= 'x_n';  STRR.Cells[2,0]:= 'euler';    STRR.Cells[3,0]:= 'euler m.';  STRR.Cells[4,0]:= 'real';
    STRR.Cells[0,1]:= '0';  STRR.Cells[1,1]:= DX.Text;  STRR.Cells[2,1]:= DY.Text;  STRR.Cells[3,1]:= DY.Text;  STRR.Cells[4,1]:= DY.Text;
    xti:= StrToFloat(DX.Text); yt:= StrToFloat(DY.Text);
    myt:= yt;
    for i:=1 to nt do begin
      STRR.RowCount:= STRR.RowCount+1;
      yti:= yt+(h*Self.f(xti,yt,EDO.Text));

      tmp:= myt+(h*Self.f(xti,myt,EDO.Text));
      myti:= myt+(h*((Self.f(xti,myt,EDO.Text)+Self.f(xti+h,tmp,EDO.Text))/2));

      STRR.Cells[0,i+1]:= IntToStr(i);  STRR.Cells[1,i+1]:= FloatToStr(xti+h);
      STRR.Cells[2,i+1]:= FloatToStr(yti);  STRR.Cells[3,i+1]:= FloatToStr(myti);
      if(SOL.Text <> '') then
        STRR.Cells[4,i+1]:= FloatToStr(Self.f(xti+h,0,SOL.Text));
      xti:= xti+h;
      yt:= yti;
      myt:= myti;
    end;
end;


end.

//TfrmGraficadora
