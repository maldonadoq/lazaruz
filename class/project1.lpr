program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, Unit1, CustApp
  { you can add units after this };

type

  { Figure }

  Figure = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ Figure }

procedure Figure.DoRun;
var
  ErrorMsg: String;
  Fig: TFigure;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
  Fig:= TFigure.Create();
  Fig.name:= 'Circulo';
  Fig.perimetro:= 34.22;
  Fig.area:= 123.23;
  WriteLn(Fig.show() );
  Fig.sho();
  WriteLn(Fig.add(6,2));
  Fig.Destroy;

  // stop program loop
  Terminate;
end;

constructor Figure.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor Figure.Destroy;
begin
  inherited Destroy;
end;

procedure Figure.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: Figure;
begin
  Application:=Figure.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

