unit stad;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Grids, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    Celda: TChart;
    Palet: TColorDialog;
    Gareas: TAreaSeries;
    Gbarras: TBarSeries;
    Glineal: TLineSeries;
    Gpastel: TPieSeries;
    Datos: TGroupBox;
    Grafica: TGroupBox;
    Dat: TStringGrid;
    MainMenu1: TMainMenu;
    Archivo: TMenuItem;
    Barras: TMenuItem;
    Areas: TMenuItem;
    Autor: TMenuItem;
    Pastel: TMenuItem;
    Info: TMenuItem;
    Abrir: TMenuItem;
    Guardar: TMenuItem;
    MenuItem4: TMenuItem;
    Salir: TMenuItem;
    Editar: TMenuItem;
    Color1: TMenuItem;
    Graficas: TMenuItem;
    Lineal: TMenuItem;
    procedure AbrirClick(Sender: TObject);
    procedure AreasClick(Sender: TObject);
    procedure AutorClick(Sender: TObject);
    procedure BarrasClick(Sender: TObject);
    procedure Color1Click(Sender: TObject);
    procedure DatEditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GuardarClick(Sender: TObject);
    procedure HacerGrafica();
    procedure LinealClick(Sender: TObject);
    procedure PastelClick(Sender: TObject);
    procedure SalirClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  CG: TColor;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.AbrirClick(Sender: TObject);
begin
    Dat.LoadFromFile('data.xml');
end;

procedure TForm1.GuardarClick(Sender: TObject);
begin
  Dat.SaveToFile('data.xml');
end;

procedure TForm1.HacerGrafica();
var i,n,r: integer;
begin
  r:= Dat.RowCount;
  {clear}
  Glineal.Clear;   Gareas.Clear;
  Gbarras.Clear;   GPastel.Clear;
  Dat.Cells[0,0]:= 'Values';
  for i:=1 to r-1 do begin
    if Dat.Cells[0,i] <> '' then begin
      n:= StrToInt(Dat.Cells[0,i]);
      if Pastel.Checked then begin
        Gpastel.Add(n,'',CG);
      end;
      if Barras.Checked then begin
        Gbarras.Add(n,'',CG);
      end;
      if Lineal.Checked then begin
        Glineal.Add(n,'',CG);
      end;
      if Areas.Checked then begin
        Gareas.Add(n,'',CG);
      end;
    end;
  end;
end;

procedure TForm1.AutorClick(Sender: TObject);
begin
  ShowMessage('Percy Maldonado Quispe');
end;

procedure TForm1.AreasClick(Sender: TObject);
begin
    Areas.Checked:= not Areas.Checked;
    {if Areas.Checked = true then begin
      Lineal.Checked = false;
    end;}
    HacerGrafica();
end;

procedure TForm1.LinealClick(Sender: TObject);
begin
     Lineal.Checked:= not Lineal.Checked;
     HacerGrafica();
end;

procedure TForm1.PastelClick(Sender: TObject);
begin
     Pastel.Checked:= not Pastel.Checked;
     HacerGrafica();
end;

procedure TForm1.BarrasClick(Sender: TObject);
begin
     Barras.Checked:= not Barras.Checked;
     HacerGrafica();
end;

procedure TForm1.SalirClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Color1Click(Sender: TObject);
begin
  if Palet.Execute then begin
    CG:= Palet.Color;
    HacerGrafica();
  end;
end;

procedure TForm1.DatEditingDone(Sender: TObject);
begin
  HacerGrafica();
end;

end.

