program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, DR, CustApp
  { you can add units after this };

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TMyApplication }

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
  D : TDR;
  vl : array of real;
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
  setlength(vl,3);
  vl[0]:= 1.0; vl[1]:= 2.0; vl[2]:= 2.0;
  WriteLn('x: '+FloatToStr(vl[0])+' y: '+FloatToStr(vl[1])+' z: '+FloatToStr(vl[2]));
  WriteLn('f(x,y,z): 2x+xy+z');
  D:= TDR.Create();
  WriteLn('df('+FloatToStr(vl[0])+','+FloatToStr(vl[1])+','+FloatToStr(vl[2])+')/dx: ' + FloatToStr(D.DPA(vl,0.00001,1)));
  WriteLn('df('+FloatToStr(vl[0])+','+FloatToStr(vl[1])+','+FloatToStr(vl[2])+')/dy: ' + FloatToStr(D.DPA(vl,0.00001,2)));
  WriteLn('df('+FloatToStr(vl[0])+','+FloatToStr(vl[1])+','+FloatToStr(vl[2])+')/dz: ' + FloatToStr(D.DPA(vl,0.00001,3)));
  D.Destroy();
  // stop program loop
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

