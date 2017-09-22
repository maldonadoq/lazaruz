unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, ParseMath;
                               //Añadimos la unidad ParseMath en uses
type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    //En el formulario se agrega un Tchart, se puede encontrar
    //dando click derecho en la barra de herramientas
    //y luego buscar Tchart
    Chart1: TChart;
    //Al darle doble click en el Tchart del formulario aparecera una ventana
    //donde podemos añadir varios tipos graficas, en este caso cree un TConstanLine para ambos ejes x,y
    //y un TFuncSeries que es donde se dan los puntos para la grafica
    Chart1ConstantLine1: TConstantLine;  //eje X
    Chart1ConstantLine2: TConstantLine;  //eje Y
    Chart1FuncSeries1: TFuncSeries;      //Serie para graficar una funcion
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    //Procedimiento que se crea seleccionando un objeto TFuncSeries del inspector
    //de componentes,luego en la pestaña eventos dandole al boton  [...] del evento Oncalculate
    procedure Button1Click(Sender: TObject);
    procedure Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure FormCreate(Sender: TObject);

  public
    //Creamos una variable de tipo TParseMath
    miParse : TParseMath;
    //Funcion para hallar la imagen de un punto x dado
    function f(x:Real):Real;

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

  //Instanciamos nuestro objeto TParseMath
  miParse := TParseMath.create();
  //Funcion del parse para agregar una nueva variable, en este caso 'x'
  miParse.AddVariable('x',0.0);
  //Funcion del parse para cambiar el valor de una varible previamente añadida
  miParse.NewValue('x',0.1);
end;

function TForm1.f(x:Real):Real;
begin
  //Actualiza el valor de x
  miParse.NewValue('x',x);

  //La funcion evaluate obtiene el resultado de f(x) de una expression y un x previamente añadidos
  //tambien acepta multiples variables cada una con sus respectivos valores
  Result:= miParse.Evaluate();
end;

procedure TForm1.Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  //hallamos el punto a partir de y = f(x), esto se actualizara automaticamente en el TFuncSeries
  //Si usan otro tipo de grafica deberan añadir manualmente los puntos, generalmente cada grafica tiene una funcion ADD
  //que nos sirve para ello
  AY := f(AX);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Chart1FuncSeries1.Active:=False;
  //En el atributo expression del parse añadimos la funcion en formato string, que en este caso lo obtiene de un TEdit
  miParse.Expression:= Edit1.Text;
  //para que el programa no de errores en la pestaña propiedades seleccionado FunctionSeries
  //poner la propiedad Active como falsa
  //una vez añadida la funcion que queremos graficar recien la activamos
  Chart1FuncSeries1.Active:=True;
end;

end.

