unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TFigure = class
    public
      name: string;
      area: real;
      perimetro: real;
      function show(): string;
      function add(a, b: integer): integer;
      procedure sho();
      constructor Create();
      destructor Destroy(); override;
    private
  end;

implementation
constructor TFigure.Create();
begin
  Self.name:= 'unknown';
  Self.area:= 0.0;
  Self.perimetro:= 0.0;
end;

destructor TFigure.Destroy();
begin
end;

function TFigure.show(): string;
begin
  Result:= 'name: ' + Self.name;
end;

procedure TFigure.sho();
begin
  WriteLn('name: ' + Self.name);
end;

function TFigure.add(a,b: integer): integer;
begin
  Result:= a+b;
end;

end.

