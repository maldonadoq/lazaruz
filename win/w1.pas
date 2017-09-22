unit w1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    r: TEdit;
    c: TEdit;
    Ok: TButton;
    wind: TStringGrid;
    procedure OkClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.OkClick(Sender: TObject);
var i,j,r1,c1: integer;
begin
     c1:= StrToInt(c.Text);
     r1:= StrToInt(r.Text);
     wind.Clear;
     wind.RowCount:= r1+1;
     wind.ColCount:= c1+1;
     for i:=0 to c1 do
         wind.Cells[i,0]:= IntToStr(i);
     for i:=0 to r1 do
         wind.Cells[0,i]:= IntToStr(i);

     for i:=1 to wind.RowCount-1 do begin
       for j:=1 to wind.ColCount-1 do begin
         wind.Cells[j,i]:= IntToStr(i*j);
       end;
     end;
end;

end.

