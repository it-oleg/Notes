unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    RichEdit1: TRichEdit;
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    Button4: TButton;
    ComboBox2: TComboBox;
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// Кнопка сохранения заметки
procedure TForm1.BitBtn1Click(Sender: TObject);
var name: string;
begin
  name := inputbox('Внимание!', 'Введите название заметки', 'Заметка');
  RichEdit1.Lines.SaveToFile('Notes/' + name +'.rtf');
  Listbox1.Items.Add(name);
  Listbox1.ItemIndex := Listbox1.Items.Count-1
end;

// Кнопка создания новой заметки
procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Listbox1.ItemIndex := -1;
  Label1.Caption := 'Новая заметка';
  Richedit1.Lines.Clear
end;

// Кнопка удаления заметки
procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  if listbox1.Itemindex >= 0 then begin
    DeleteFile('Notes/' + Listbox1.Items[listbox1.ItemIndex] +'.rtf');
    Listbox1.Items.Delete(listbox1.ItemIndex);
    Richedit1.Lines.Clear;
    label1.Caption := ''
  end;
end;

// Кнопка "Жирный"
procedure TForm1.Button1Click(Sender: TObject);
begin
  if fsBold in richedit1.SelAttributes.Style then
    richedit1.SelAttributes.Style := richedit1.SelAttributes.Style - [fsBold]
  else richedit1.SelAttributes.Style := richedit1.SelAttributes.Style + [fsBold]
end;

// Кнопка "Курсив"
procedure TForm1.Button2Click(Sender: TObject);
begin
  if fsItalic in richedit1.SelAttributes.Style then
    richedit1.SelAttributes.Style := richedit1.SelAttributes.Style - [fsItalic]
  else richedit1.SelAttributes.Style := richedit1.SelAttributes.Style + [fsItalic]
end;

// Кнопка "Подчеркнутый"
procedure TForm1.Button3Click(Sender: TObject);
begin
  if fsUnderline in richedit1.SelAttributes.Style then
    richedit1.SelAttributes.Style := richedit1.SelAttributes.Style - [fsUnderline]
  else richedit1.SelAttributes.Style := richedit1.SelAttributes.Style + [fsUnderline]
end;

// Кнопка "Зачеркнутый"
procedure TForm1.Button4Click(Sender: TObject);
begin
  if fsStrikeOut in richedit1.SelAttributes.Style then
    richedit1.SelAttributes.Style := richedit1.SelAttributes.Style - [fsStrikeOut]
  else richedit1.SelAttributes.Style := richedit1.SelAttributes.Style + [fsStrikeOut]
end;

// Выбор шрифта
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  richedit1.SelAttributes.Name:=combobox1.Text;
end;

// Выбор шрифта при вводе с клавиатуры
procedure TForm1.ComboBox1Enter(Sender: TObject);
begin
  richedit1.SelAttributes.Name:=combobox1.Text;
end;

// Выбор размера шрифта
procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  if combobox2.Text <> '' then
    richedit1.SelAttributes.Size:=strtoint(combobox2.Text);
end;

// Выбор размера шрифта с клавиатуры
procedure TForm1.ComboBox2Enter(Sender: TObject);
begin
  if combobox2.Text <> '' then
    richedit1.SelAttributes.Size:=strtoint(combobox2.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
var SearchRec: TSearchRec;
begin
  // Заполнение выпадающего списка шрифтов
  Combobox1.Items:=Screen.Fonts;

  // Создать каталог Notes и заметку с приветствием если его нет
  if createDir('Notes') then begin
    RichEdit1.Lines.Add('Добро пожаловать! В данном приложении вы можете создавать и редактировать заметки, изменять их шрифт, добавлять картинки через буфер обмена');
    RichEdit1.Lines.SaveToFile('Notes/Wellcome.rtf');
    RichEdit1.Lines.Clear;
  end;

  // Поиск всех заметок в каталоге Notes
  if FindFirst(ExtractFilePath(ParamStr(0))+'Notes\*.rtf', faAnyFile, SearchRec) = 0  then
  repeat
    //выводим список заметок в ListBox без формата
    Listbox1.Items.Add(StringReplace(SearchRec.Name, '.rtf', '', [rfReplaceAll]));
  until FindNext(SearchRec) <> 0;
  FindClose(SearchRec);
end;

// Выбор заметки из списка и открытие
procedure TForm1.ListBox1Click(Sender: TObject);
var filename: string;
    filedate: integer;
begin
  if listbox1.ItemIndex >= 0 then begin
    filename := 'Notes/' + listbox1.Items[listbox1.ItemIndex] + '.rtf';
    richedit1.Lines.LoadFromFile(filename);
    filedate := fileAge(filename);
    if fileDate > -1 then
      Label1.Caption := 'Дата последнего изменения: ' + DateTimeToStr(FileDateToDateTime(filedate))
  end
end;

end.
