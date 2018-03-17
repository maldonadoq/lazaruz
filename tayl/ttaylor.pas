unit ttaylor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Grids, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    box: TGroupBox;
    xn: TEdit;
    Ok: TButton;
    comb: TComboBox;
    max: TEdit;
    error: TEdit;
    men: TPanel;
    table: TStringGrid;
    function Factorial(a: integer): real;

    procedure FormCreate(Sender: TObject);
    procedure OkClick(Sender: TObject);
    procedure Clear;
    procedure Sin(x,h: real; n: integer);
    procedure Cos(x,h: real; n: integer);
    procedure Exp(x,h: real; n: integer);
    procedure Ln(x,h: real; n: integer);
    procedure Arctg(x,h: real; n: integer);
    procedure Sinh(x,h: real; n: integer);
    procedure Cosh(x,h: real; n: integer);

  private
  public
    Pi: real;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Pi:= 3.141592654;
end;

procedure TForm1.Clear;
begin
  table.Clear;
  table.RowCount:= 1;
  table.Cells[0,0]:= 'Value';
  table.Cells[1,0]:= 'EA';
  table.Cells[2,0]:= 'ER';
  table.Cells[3,0]:= 'ERP';
end;

procedure TForm1.OkClick(Sender: TObject);
var
  h, x: real;
  n: integer;
begin
  h:= StrToFloat(error.Text);
  n:= StrToInt(max.Text);
  x:= StrToFloat(xn.Text);
  case comb.ItemIndex of
    0: Sin(x,h,n);
    1: Cos(x,h,n);
    2: Exp(x,h,n);
    3: Ln(x,h,n);
    4: Arctg(x,h,n);
    5: Sinh(x,h,n);
    6: Cosh(x,h,n);
  end;
end;

function Tform1.Factorial(a: integer): real;
var i: integer;
begin
  Result:=1;
  for i:=1 to a do
      Result:= Result*i;
end;

procedure TForm1.Sin(x,h: real; n: integer);
begin
  //table.Cells[0,0]:= 'sin';
end;

procedure TForm1.Cos(x,h: real; n: integer);
begin
end;

procedure TForm1.Exp(x,h: real; n: integer);
var
    i: integer = 1;
    rt, v, e: real;
begin
     v:= 1;
     e:= (h+1);
     Clear;
     while (h<e) do begin
         table.RowCount:= table.RowCount+1;
         rt:= v;
         v:= v + (power(x,i)/Factorial(i));
         e:= abs(v-rt);
         table.Cells[0,i]:= FloatToStr(v);
         table.Cells[1,i]:= FloatToStr(e);
         table.Cells[2,i]:= FloatToStr(e/v);
         table.Cells[3,i]:= FloatToStr((e/v)*100);
         i:=i+1;
     end;
end;

procedure TForm1.Ln(x,h: real; n: integer);
var
    i: integer = 1;
    rt, v, e: real;
begin
  v:= 1; e:= (h+1);
  Clear;
  if x=0 then begin
    table.RowCount:= 2;
    table.Cells[0,1]:= '1'
  end
  else if (x>0) and (x<=2) then begin
    ShowMessage('Taylor Ln!');
  end
  else
    ShowMessage('[ Exp Dom: R ]');
end;

procedure TForm1.Arctg(x,h: real; n: integer);
begin
end;


procedure TForm1.Sinh(x,h: real; n: integer);
begin
end;


procedure TForm1.Cosh(x,h: real; n: integer);
begin
end;

end.

