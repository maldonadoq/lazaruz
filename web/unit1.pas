unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb;

type

  { TFPWebModule1 }

  TFPWebModule1 = class(TFPWebModule)
    procedure DataModuleRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; Var Handled: Boolean);
  private

  public

  end;

var
  FPWebModule1: TFPWebModule1;

implementation

{$R *.lfm}

{ TFPWebModule1 }

procedure TFPWebModule1.DataModuleRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; Var Handled: Boolean);
var a,b: real;
begin
     a:= FloatToStr(ARequest.QueryFields.Values('a'));
     b:= FloatToStr(ARequest.QueryFields.Values('b'));
     AResponse.ContentType:='text/html;charset=utf-8';
     Aresponse.Contents.Text:='Suma: ' + FloatToStr(a+b);
end;

initialization
  RegisterHTTPModule('TFPWebModule1', TFPWebModule1);
end.

