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

// ������ ���������� �������
procedure TForm1.BitBtn1Click(Sender: TObject);
var name: string;
begin
  name := inputbox('��������!', '������� �������� �������', '�������');
  RichEdit1.Lines.SaveToFile('Notes/' + name +'.rtf');
  Listbox1.Items.Add(name);
  Listbox1.ItemIndex := Listbox1.Items.Count-1
end;

// ������ �������� ����� �������
procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Listbox1.ItemIndex := -1;
  Label1.Caption := '����� �������';
  Richedit1.Lines.Clear
end;

// ������ �������� �������
procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  if listbox1.Itemindex >= 0 then begin
    DeleteFile('Notes/' + Listbox1.Items[listbox1.ItemIndex] +'.rtf');
    Listbox1.Items.Delete(listbox1.ItemIndex);
    Richedit1.Lines.Clear;
    label1.Caption := ''
  end;
end;

// ������ "������"
procedure TForm1.Button1Click(Sender: TObject);
begin
  if fsBold in richedit1.SelAttributes.Style then
    richedit1.SelAttributes.Style := richedit1.SelAttributes.Style - [fsBold]
  else richedit1.SelAttributes.Style := richedit1.SelAttributes.Style + [fsBold]
end;

// ������ "������"
procedure TForm1.Button2Click(Sender: TObject);
begin
  if fsItalic in richedit1.SelAttributes.Style then
    richedit1.SelAttributes.Style := richedit1.SelAttributes.Style - [fsItalic]
  else richedit1.SelAttributes.Style := richedit1.SelAttributes.Style + [fsItalic]
end;

// ������ "������������"
procedure TForm1.Button3Click(Sender: TObject);
begin
  if fsUnderline in richedit1.SelAttributes.Style then
    richedit1.SelAttributes.Style := richedit1.SelAttributes.Style - [fsUnderline]
  else richedit1.SelAttributes.Style := richedit1.SelAttributes.Style + [fsUnderline]
end;

// ������ "�����������"
procedure TForm1.Button4Click(Sender: TObject);
begin
  if fsStrikeOut in richedit1.SelAttributes.Style then
    richedit1.SelAttributes.Style := richedit1.SelAttributes.Style - [fsStrikeOut]
  else richedit1.SelAttributes.Style := richedit1.SelAttributes.Style + [fsStrikeOut]
end;

// ����� ������
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  richedit1.SelAttributes.Name:=combobox1.Text;
end;

// ����� ������ ��� ����� � ����������
procedure TForm1.ComboBox1Enter(Sender: TObject);
begin
  richedit1.SelAttributes.Name:=combobox1.Text;
end;

// ����� ������� ������
procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  if combobox2.Text <> '' then
    richedit1.SelAttributes.Size:=strtoint(combobox2.Text);
end;

// ����� ������� ������ � ����������
procedure TForm1.ComboBox2Enter(Sender: TObject);
begin
  if combobox2.Text <> '' then
    richedit1.SelAttributes.Size:=strtoint(combobox2.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
var SearchRec: TSearchRec;
begin
  // ���������� ����������� ������ �������
  Combobox1.Items:=Screen.Fonts;

  // ������� ������� Notes � ������� � ������������ ���� ��� ���
  if createDir('Notes') then begin
    RichEdit1.Lines.Add('����� ����������! � ������ ���������� �� ������ ��������� � ������������� �������, �������� �� �����, ��������� �������� ����� ����� ������');
    RichEdit1.Lines.SaveToFile('Notes/Wellcome.rtf');
    RichEdit1.Lines.Clear;
  end;

  // ����� ���� ������� � �������� Notes
  if FindFirst(ExtractFilePath(ParamStr(0))+'Notes\*.rtf', faAnyFile, SearchRec) = 0  then
  repeat
    //������� ������ ������� � ListBox ��� �������
    Listbox1.Items.Add(StringReplace(SearchRec.Name, '.rtf', '', [rfReplaceAll]));
  until FindNext(SearchRec) <> 0;
  FindClose(SearchRec);
end;

// ����� ������� �� ������ � ��������
procedure TForm1.ListBox1Click(Sender: TObject);
var filename: string;
    filedate: integer;
begin
  if listbox1.ItemIndex >= 0 then begin
    filename := 'Notes/' + listbox1.Items[listbox1.ItemIndex] + '.rtf';
    richedit1.Lines.LoadFromFile(filename);
    filedate := fileAge(filename);
    if fileDate > -1 then
      Label1.Caption := '���� ���������� ���������: ' + DateTimeToStr(FileDateToDateTime(filedate))
  end
end;

end.
