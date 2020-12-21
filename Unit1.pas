unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids;

const
  Rad = 15; // Радиус
  Len = 40; // Расстояние между уровнями по вертикали

  PenColor = clRed;

  BrushColor = clYellow;
  BackColor = clBlack;

type
  Tree = ^TreeEl;

  TreeEl = record
    Left: Tree;
    Right: Tree;
    Value: Integer;
    Thread: Boolean; // Признак правой нити
    X, Y: Integer; // Координаты кружка
  end;

  TForm1 = class(TForm)
    lb1: TLabel;
    nudElCount: TEdit;
    stgEls: TStringGrid;
    btnBuild: TButton;
    imgTree: TImage;
    lbl2: TLabel;
    nudDelEl: TEdit;
    btnDel: TButton;
    lblPram: TLabel;
    lblSim: TLabel;
    lblObr: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure nudElCountChange(Sender: TObject);
    procedure btnBuildClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
    { Private declarations }
  public
    NowTree: Tree;
  end;

procedure Add(El: Integer; var Rez: Tree);
procedure Draw(El: Tree; Y, X1, X2: Integer; var bmp: TBitmap);
function Obr(El: Tree): string;
function SimAndSew(El: Tree; var bmp: TBitmap): string;
function Pram(El: Tree): string;
procedure PunktLineTo(x0, y0, X, Y: Integer; var bmp: TBitmap);
procedure DelEl(val: Integer; var Der, PrevEl: Tree);

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.nudElCountChange(Sender: TObject);
begin
  if (nudElCount.Text <> '') then

    stgEls.RowCount := strtoint(nudElCount.Text);
end;

procedure DelEl(val: Integer; var Der, PrevEl: Tree);
var
  prev, El, X: Tree;
  function Find(val: Integer; var Der: Tree): Tree;
  begin
    if Der = nil then
    begin
      Result := Der;
      Exit;
    end;
    if Der^.Value = val then
      Result := Der
    else
    begin
      prev := Der;
      if Der^.Value < val then
        Result := Find(val, Der^.Right)
      else
        Result := Find(val, Der^.Left)
    end;
  end;

begin

  prev := PrevEl;
  El := Find(val, Der);
  if El = nil then
  begin
    MessageBoxW(0, 'Элемент не найден', 'Ошибка', MB_OK + MB_ICONSTOP +
      MB_TOPMOST);
    Exit;
  end;
  if (El^.Left = nil) then
  begin
    if prev^.Left = El then
      prev^.Left := El^.Right
    else
      prev^.Right := El^.Right;
    Dispose(El);
  end
  else if (El^.Right = nil) or (El^.Thread) then
  begin
    if prev^.Left = El then
      prev^.Left := El^.Left
    else
      prev^.Right := El^.Left;
    Dispose(El);
  end
  else
  begin

    X := El^.Right;
    while X^.Left <> nil do
      X := X^.Left;
    El^.Value := X^.Value;
    DelEl(X^.Value, El^.Right, El)
  end;
end;

procedure PunktLineTo(x0, y0, X, Y: Integer; var bmp: TBitmap);
var
  X1, y1, X2, y2, i: Integer;
begin

  if X > x0 then
  begin
    X1 := x0;
    y1 := y0;
    X2 := X;
    y2 := Y;
  end
  else
  begin
    X1 := X;
    y1 := Y;
    X2 := x0;
    y2 := y0;
  end;
  bmp.Canvas.Pen.Width := 2;
  bmp.Canvas.Pen.Color := clLime;
  bmp.Canvas.Pen.Style := psDot;

  i := X1;
  while i <= X2 do
  begin
    bmp.Canvas.MoveTo(i, y1);
    bmp.Canvas.LineTo(i + 15, y1);
    i := i + 30;

  end;

  i := y1;
  if y1 > y2 then
    while i >= y2 do
    begin
      bmp.Canvas.MoveTo(X2, i);
      bmp.Canvas.LineTo(X2, i - 15);
      i := i - 30;

    end
  else
    while i <= y2 do
    begin
      bmp.Canvas.MoveTo(X2, i);
      bmp.Canvas.LineTo(X2, i + 15);
      i := i + 30;

    end;
end;


function Obr(El: Tree): string;
begin
  if El = nil then
  begin
    Result := '0 ';
    Exit;
  end;
  Result := IntToStr(El^.Value) + ' ';

  Result := Result + Obr(El^.Left);
  Result := Result + IntToStr(El^.Value) + ' ';

  Result := Result + Obr(El^.Right);

  Result := Result + '(' + IntToStr(El^.Value) + ')' + ' ';
end;


procedure DelThread(var El: Tree);
begin
  if El = nil then
    Exit;

  DelThread(El^.Left);
  if El^.Thread = False then
    DelThread(El^.Right);
  if El^.Thread then
  begin
    El^.Thread := False;
    El^.Right := nil;
  end;
end;


function Pram(El: Tree): string;
begin
  if El = nil then
  begin
    Result := '0 ';
    Exit;
  end;
  Result := Result + '(' + IntToStr(El^.Value) + ')' + ' ';

  Result := Result + Pram(El^.Left);
  Result := Result + IntToStr(El^.Value) + ' ';

  Result := Result + Pram(El^.Right);
  Result := Result + IntToStr(El^.Value) + ' ';
end;

function SimAndSew(El: Tree; var bmp: TBitmap): string;
var
  prev: Tree;

  function Sim(El: Tree; var bmp: TBitmap): string;
  begin
    if El = nil then
    begin
      Result := '0 ';
      Exit;
    end;
    Result := IntToStr(El^.Value) + ' ';

    Result := Result + Sim(El^.Left, bmp);
    Result := Result + '(' + IntToStr(El^.Value) + ')' + ' ';

    if (prev^.Right = nil) or (prev^.Thread = true) then
    begin
      prev^.Thread := true;
      prev^.Right := El;
      PunktLineTo(prev^.X + Rad, prev^.Y, El^.X, El^.Y + Rad, bmp);
    end
    else
      prev^.Thread := False;
    prev := El;

    if Not El^.Thread then
    begin
      Result := Result + Sim(El^.Right, bmp);
      Result := Result + IntToStr(El^.Value) + ' ';
    end
    else
      Result := Result + '0 ' + IntToStr(El^.Value) + ' ';
  end;

begin
  prev := El^.Left;
  Result := Sim(El^.Left, bmp);

  if (prev^.Right = nil) then
  begin
    prev^.Thread := true;
    prev^.Right := El;

    PunktLineTo(prev^.X + Rad, prev^.Y, bmp.Width - 10, prev^.Y, bmp);
    PunktLineTo(bmp.Width - 10, prev^.Y, El^.X, El^.Y + Rad, bmp);
  end;
end;

procedure Add(El: Integer; var Rez: Tree);
begin
  if Rez = nil then
  begin
    New(Rez);
    Rez^.Value := El;
    Rez^.Left := nil;
    Rez^.Right := nil;
    Rez^.Thread := False;
  end
  else if El < Rez^.Value then
    Add(El, Rez^.Left)
  else
    Add(El, Rez^.Right)
end;


procedure Draw(El: Tree; Y, X1, X2: Integer; var bmp: TBitmap);

  procedure DrawRec(El: Tree; Y, X1, X2: Integer; var bmp: TBitmap);
  begin

    bmp.Canvas.Brush.Color := BackColor;
    bmp.Height := bmp.Height + Rad * 2 + Len;
    bmp.Canvas.Ellipse((X2 + X1) div 2 - Rad, Y, (X2 + X1) div 2 + Rad,
      Y + Rad * 2);
    bmp.Canvas.Brush.Color := BrushColor;
    bmp.Canvas.FloodFill((X2 + X1) div 2, Y + Rad, PenColor, fsBorder);
    bmp.Canvas.TextOut((X2 + X1) div 2 - Rad + 8, Y + 7, IntToStr(El^.Value));
    bmp.Canvas.Brush.Color := BackColor;
    El^.X := (X2 + X1) div 2;
    El^.Y := Y + Rad;

    if El^.Left <> nil then
    begin

      bmp.Canvas.MoveTo((X1 + X2) div 2, Y + Rad * 2);
      bmp.Canvas.LineTo(((X1 + X2) div 2 + X1) div 2, Y + Rad * 2 + Len);

      DrawRec(El^.Left, Y + Rad * 2 + Len, X1, (X1 + X2) div 2, bmp);
    end;
    if (El^.Right <> nil) and (Not El^.Thread) then
    begin

      bmp.Canvas.MoveTo((X1 + X2) div 2, Y + Rad * 2);
      bmp.Canvas.LineTo(((X1 + X2) div 2 + X2) div 2, Y + Rad * 2 + Len);

      DrawRec(El^.Right, Y + Rad * 2 + Len, (X1 + X2) div 2, X2, bmp);
    end;
  end;

begin
  bmp.Canvas.Pen.Width := 3;
  bmp.Canvas.Brush.Color := BackColor;
  bmp.Height := bmp.Height + Rad * 2 + Len;
  bmp.Canvas.Brush.Color := BrushColor;
  bmp.Canvas.FillRect(Bounds((X1 + X2) div 2 - 25, Y, 50, Rad * 2));
  bmp.Canvas.Font.Style := [fsBold];
  bmp.Canvas.TextOut((X1 + X2) div 2 - 15, Y + 7, 'HEAD');
  bmp.Canvas.MoveTo((X1 + X2) div 2, Y + Rad * 2);
  bmp.Canvas.LineTo((X1 + X2) div 2, Y + Rad * 2 + (Len div 2));
  El^.X := (X1 + X2) div 2 + 25;
  El^.Y := Y;
  DrawRec(El^.Left, Y + Rad * 2 + (Len div 2), X1, X2, bmp);
end;

procedure TForm1.btnBuildClick(Sender: TObject);
var
  i: Integer;
  Elements: array of Integer;
  bmp: TBitmap;
  X: Tree;
begin
  if (nudElCount.Text <> '') then
    SetLength(Elements, strtoint(nudElCount.Text));
    try
    for i := Low(Elements) to High(Elements) do

      Elements[i] := strtoint(stgEls.Cells[0, i]);
  except
    MessageBoxW(0, 'Введите все числовые элементы', 'Ошибка', MB_OK + MB_ICONSTOP + MB_TOPMOST);
    Exit;
  end;
  NowTree := nil;
  for i := Low(Elements) to High(Elements) do
    Add(Elements[i], NowTree);
  New(X);
  X^.Left := NowTree;
  X^.Right := X;
  X^.Value := -1;
  NowTree := X;
  bmp := TBitmap.Create;
  with bmp do
  begin
    Canvas.Pen.Color := PenColor;
    Canvas.Brush.Color := BackColor;
    Width := imgTree.Width;
  end;
  Draw(NowTree, 0, 0, imgTree.Width, bmp);
  lblObr.Caption := 'Концевой обход: ';
  Memo3.Text := Obr(NowTree^.Left);
  lblPram.Caption := 'Прямой обход: ';
  Memo1.Text := Pram(NowTree^.Left);
  lblSim.Caption := 'Симметричный обход: ';
  Memo2.Text := SimAndSew(NowTree, bmp);
  imgTree.Picture := TPicture(bmp);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {stgEls.Cells[0, 0] := '10';
  stgEls.Cells[1, 0] := '12';
  stgEls.Cells[2, 0] := '6';
  stgEls.Cells[3, 0] := '11';
  stgEls.Cells[4, 0] := '4';
  stgEls.Cells[5, 0] := '15';
  stgEls.Cells[6, 0] := '9';
  stgEls.Cells[7, 0] := '20';
  stgEls.Cells[8, 0] := '14';
  stgEls.Cells[9, 0] := '17';
  stgEls.Cells[0, 0] := '10';
  stgEls.Cells[0, 1] := '12';
  stgEls.Cells[0, 2] := '6';
  stgEls.Cells[0, 3] := '11';
  stgEls.Cells[0, 4] := '4';
  stgEls.Cells[0, 5] := '15';
  stgEls.Cells[0, 6] := '9';
  stgEls.Cells[0, 7] := '20';
  stgEls.Cells[0, 8] := '14';
  stgEls.Cells[0, 9] := '17'; }
end;

procedure TForm1.btnDelClick(Sender: TObject);
var
  bmp: TBitmap;
begin
  DelThread(NowTree^.Left);
  if (nudDelEl.Text <> '') then
    DelEl(strtoint(nudDelEl.Text), NowTree^.Left, NowTree);
  // Отображаем
  bmp := TBitmap.Create;
  with bmp do
  begin
    Canvas.Pen.Color := PenColor;
    Canvas.Brush.Color := BackColor;
    Width := imgTree.Width;
  end;
  Draw(NowTree, 0, 0, imgTree.Width, bmp);
  // Обходы
  lblObr.Caption := 'Концевой обход: ';
  Memo3.Text := Obr(NowTree^.Left);
  lblPram.Caption := 'Прямой обход: ';
  Memo1.Text := Pram(NowTree^.Left);
  lblSim.Caption := 'Симметричный обход: ';
  Memo2.Text := SimAndSew(NowTree, bmp);
  imgTree.Picture := TPicture(bmp);
end;

end.
