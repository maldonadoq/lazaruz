unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, ColorBox, Grids, ParseMath,
  TAChartUtils, TATools, TACustomSeries, TADrawUtils;

type

  { TEDOS }

  TEDOS = class(TForm)
    XP: TEdit;
    YP: TEdit;
    PlotearS: TLineSeries;
    DY: TEdit;
    DX: TEdit;
    SOL: TEdit;
    RK: TButton;
    EU: TButton;
    chrGrafica: TChart;
    Area: TAreaSeries;
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
    procedure RKClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncionCalculate(const AX, AY: Double; s: string; out AF: Double);
    procedure GraficarFuncionConPloteo();
    procedure Plot();
    procedure Init();

  private
    { private declarations }
    Parse  : TparseMath;
    Xminimo, Xmaximo: String;

    function f(x,y: Double; s: string): Double;
    function fd(x,y,z: Double; s: string): Double;
    Procedure DetectarIntervalo();

  public
    { public declarations }
  end;

var
  EDOS: TEDOS;

implementation

{$R *.lfm}

{ TEDOS }

Procedure TEDOS.DetectarIntervalo();
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

function TEDOS.f(x,y: Double; s: string): Double;
begin
     parse.Expression:= s;
     Parse.NewValue('x', x);
     Parse.NewValue('y', y);
     Result:= Parse.Evaluate();
end;

function TEDOS.fd(x,y,z: Double; s: string): Double;
begin
     parse.Expression:= s;
     Parse.NewValue('x', x);
     Parse.NewValue('y', y);
     Parse.NewValue('z', z);
     Result:= Parse.Evaluate();
end;

Procedure TEDOS.GraficarFuncionConPloteo();
var
    i: Integer;
begin
    Funcion.Active:= False;
    Plotear.ShowPoints:= false; PlotearS.ShowPoints:= false;
    Plotear.LinePen.Color:= cboxColorFuncion.Colors[cboxColorFuncion.ItemIndex];
    PlotearS.LinePen.Color:= cboxColorFuncion.Colors[0];

    for i:=1 to STRR.RowCount-1 do begin
       Plotear.AddXY(StrToFloat(STRR.Cells[1,i]), StrToFloat(STRR.Cells[2,i]));
    end;

    if(SOL.Text<>'') then begin
        for i:=1 to STRR.RowCount-1 do
            PlotearS.AddXY(StrToFloat(STRR.Cells[1,i]), StrToFloat(STRR.Cells[3,i]));
    end;
    Plotear.Active:= true;
    PlotearS.Active:= true;
end;

procedure TEDOS.Plot();
begin
 Plotear.Clear;
 PlotearS.Clear;
 if STRR.RowCount<2 then
    exit;

 DetectarIntervalo();
 Self.GraficarFuncionConPloteo();
end;

procedure TEDOS.Button1Click(Sender: TObject);
begin
 Area.Active:= true;
end;

procedure TEDOS.FormCreate(Sender: TObject);
begin
  Parse := TparseMath.create;
  Parse.AddVariable('x',0.0);
  parse.AddVariable('y',0.0);
  parse.AddVariable('z',0.0);
end;

procedure TEDOS.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
end;

procedure TEDOS.FuncionCalculate(const AX, AY: Double; s: string; out AF: Double);
begin
  AF := Self.f(AX,AY,s);
end;

procedure TEDOS.Init();
begin
 STRR.Clear();
 STRR.RowCount:= 2;
 STRR.Cells[0,0]:= 'n';  STRR.Cells[1,0]:= 'x_n';  STRR.Cells[2,0]:= 'metodo';    STRR.Cells[3,0]:= 'real';  STRR.Cells[4,0]:= 'error';
 STRR.Cells[0,1]:= '0';  STRR.Cells[1,1]:= DX.Text;  STRR.Cells[2,1]:= DY.Text;  STRR.Cells[3,1]:= DY.Text;  STRR.Cells[4,1]:= '0';
end;

procedure TEDOS.EUClick(Sender: TObject);
var
    h,zt,xi,xf, xti, yt: real;
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

    Self.Init();
    xti:= StrToFloat(DX.Text); yt:= StrToFloat(DY.Text);
    for i:=1 to nt do begin
      STRR.RowCount:= STRR.RowCount+1;
      xti:= StrToFloat(STRR.Cells[1,i]);
      zt:= StrToFloat(STRR.Cells[2,i]);
      yt:= yt+(h*Self.fd(xti,yt,zt,'z'));
      zt:= zt+(h*(Self.fd(xti,yt,zt,EDO.Text)));
      if(SOL.Text<>'') then
          STRR.Cells[3,i+1]:= FloatToStr(Self.fd(xti+h,yt,zt,Sol.Text));

      STRR.Cells[0,i+1]:= IntToStr(i);
      STRR.Cells[1,i+1]:= FloatToStr(xti+h);
      STRR.Cells[2,i+1]:= FloatToStr(zt);
    end;
    Self.Plot();
end;

procedure TEDOS.RKClick(Sender: TObject);
var
    h,zt,xi,xf, xti, yt,ky1,ky2,ky3,ky4,kz1,kz2,kz3,kz4: real;
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

    Self.Init();
    yt:= StrToFloat(DY.Text);
    for i:=1 to nt do begin
      STRR.RowCount:= STRR.RowCount+1;
      xti:= StrToFloat(STRR.Cells[1,i]);
      zt:= StrToFloat(STRR.Cells[2,i]);

      ky1:= Self.fd(xti,yt,zt,'z');
      ky2:= Self.fd(xti+(h/2),yt+(ky1*h/2),zt,'z');
      ky3:= Self.fd(xti+(h/2),yt+(ky2*h/2),zt,'z');
      ky4:= Self.fd(xti+h,yt+(ky3*h),zt,'z');

      kz1:= Self.fd(xti,yt,zt,EDO.Text);
      kz2:= Self.fd(xti+(h/2),yt+(ky1*h/2),zt+(kz1*h/2),EDO.Text);
      kz3:= Self.fd(xti+(h/2),yt+(ky2*h/2),zt+(kz2*h/2),EDO.Text);
      kz4:= Self.fd(xti+h,yt+(ky3*h),zt+(kz3*h),EDO.Text);

      yt:= yt+(h*(ky1 + (2*ky2) + (2*ky3) +ky4)/6);
      zt:= zt+(h*(kz1 + (2*kz2) + (2*kz3) +kz4)/6);

      if(SOL.Text<>'') then
          STRR.Cells[3,i+1]:= FloatToStr(Self.fd(xti+h,yt,zt,Sol.Text));

      STRR.Cells[0,i+1]:= IntToStr(i);
      STRR.Cells[1,i+1]:= FloatToStr(xti+h);
      STRR.Cells[2,i+1]:= FloatToStr(zt);
    end;
    Self.Plot();
end;


end.

//TEDOS
