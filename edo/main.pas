unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, ColorBox, Grids, ParseMath,
  TAChartUtils, TATools, TACustomSeries;

type

  { TfrmGraficadora }

  TfrmGraficadora = class(TForm)
    DY: TEdit;
    DX: TEdit;
    GRA: TButton;
    EU: TButton;
    chrGrafica: TChart;
    Area: TAreaSeries;
    Label1: TLabel;
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
    procedure FuncionCalculate(const AX, AY: Double; out AF: Double);

    Procedure GraficarFuncion();
    Procedure GraficarFuncionConPloteo();

  private
    { private declarations }
    Parse  : TparseMath;
    Xminimo, Xmaximo: String;

    function f(x,y: Double ): Double;
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

function TfrmGraficadora.f(x,y: Double): Double;
begin
     parse.Expression:= EDO.Text;
     Parse.NewValue('x', x);
     Parse.NewValue('y', y);
     Result:= Parse.Evaluate();
end;

Procedure TfrmGraficadora.GraficarFuncionConPloteo();
var i: Integer;
begin
    Funcion.Active:= False;
    //Plotear.Marks.Style:= smsValue;
    Plotear.ShowPoints:= false;

    Plotear.LinePen.Color:= cboxColorFuncion.Colors[ cboxColorFuncion.ItemIndex ];  ;

    for i:=1 to STRR.RowCount-1 do begin
       Plotear.AddXY(StrToFloat(STRR.Cells[1,i]), StrToFloat(STRR.Cells[3,i]));
    end;
    Plotear.Active:= true;
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


procedure TfrmGraficadora.GRAClick(Sender: TObject);
begin
 Plotear.Clear;
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

procedure TfrmGraficadora.FuncionCalculate(const AX, AY: Double; out AF: Double);
begin
  AF := Self.f(AX,AY);
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
        exit;
        ShowMessage('Punto Inicial Mal');
    end;

    STRR.Clear();
    STRR.RowCount:= 2;
    STRR.Cells[0,0]:= 'n';  STRR.Cells[1,0]:= 'x_n';  STRR.Cells[2,0]:= 'euler';    STRR.Cells[3,0]:= 'euler m.';  STRR.Cells[4,0]:= 'real';
    STRR.Cells[0,1]:= '0';  STRR.Cells[1,1]:= DX.Text;  STRR.Cells[2,1]:= DY.Text;  STRR.Cells[3,1]:= DY.Text;  STRR.Cells[4,0]:= DY.Text;
    xti:= StrToFloat(DX.Text); yt:= StrToFloat(DY.Text);
    myt:= yt;
    for i:=1 to nt do begin
      STRR.RowCount:= STRR.RowCount+1;
      yti:= yt+(h*Self.f(xti,yt));

      tmp:= myt+(h*Self.f(xti,myt));
      myti:= myt+(h*((Self.f(xti,myt)+Self.f(xti+h,tmp))/2));

      STRR.Cells[0,i+1]:= IntToStr(i);  STRR.Cells[1,i+1]:= FloatToStr(xti+h);
      STRR.Cells[2,i+1]:= FloatToStr(yti);  STRR.Cells[3,i+1]:= FloatToStr(myti);
      //STRR.Cells[4,i+1]:= FloatToStr(Self.f());
      xti:= xti+h;
      yt:= yti;
      myt:= myti;
    end;
end;


end.

