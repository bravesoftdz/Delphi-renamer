{
  Сокращения:
  cmb - TComboBox
  chb - TCheckBox
  bvl - TBevel
  btn - TButton
  sed - TSpinEdit
  ed - TEdit
  lb - TListBox
  lbl - TLabel
  rg - TRadioGroup
  pnl - TPanel
}
unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, ComCtrls, ExtCtrls, Spin, ShellAPI;

type
  TfmMain = class(TForm)
    stsBar: TStatusBar;
    lbFile: TFileListBox;
    lbDir: TDirectoryListBox;
    cmbDrive: TDriveComboBox;
    lbResult: TListBox;
    pnlMain: TPanel;
    pnlLeft: TPanel;
    pnlResult: TPanel;
    pnlRight: TPanel;
    pnlSettings: TPanel;
    rgRenameType: TRadioGroup;
    edMask: TEdit;
    lblMask: TLabel;
    edExts: TEdit;
    lblExts: TLabel;
    cmbMaskAdd: TComboBox;
    sedZeroCnt: TSpinEdit;
    cmbExts: TComboBox;
    bvlSettings: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    sedStartNum: TSpinEdit;
    chbNums: TCheckBox;
    procedure lbFileKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShowSelected;
    procedure lbFileClick(Sender: TObject);
    procedure cmbMaskAddClick(Sender: TObject);
    procedure sedZeroCntChange(Sender: TObject);
    procedure edMaskChange(Sender: TObject);
    procedure edExtsChange(Sender: TObject);
    procedure cmbExtsClick(Sender: TObject);
    function DoMask(const src: string; index: integer): string;
    procedure FormCreate(Sender: TObject);
    procedure Init;
    procedure rgRenameTypeClick(Sender: TObject);
    procedure chbNumsClick(Sender: TObject);
    procedure edMaskKeyPress(Sender: TObject; var Key: Char);
  private
    mskZeroCnt: integer;
    mskText, mskExts: string;
    rType: boolean;
    function MulStr(Input: string; Rep: integer): string;
    function AddZeros(index, iCnt: integer): string;
    function DelSomeStr(const sourceStr, delStr: string; mode: integer = 1): string;
    function CheckExt(const Ext: string): boolean;
    function CheckMask(const Mask: string): boolean;
    procedure UpdateType;
  public

  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

// Добавляем ведущие нули к нумерации

function TfmMain.AddZeros(index, iCnt: integer): string;
begin
  Result:= '';
  if Length(inttostr(index)) >= iCnt then
    Result:= inttostr(index)
  else
    Result:= MulStr('0', iCnt - Length(inttostr(index))) + inttostr(index)
end;

// Выключаем возможность выбора стартовой позиции при включеном флажке

procedure TfmMain.chbNumsClick(Sender: TObject);
begin
  sedStartNum.Enabled:= not chbNums.Checked;
end;

// Проверка на присутствие расширения в списке

function TfmMain.CheckExt(const Ext: string): boolean;
begin
  if pos(Ext, mskExts) > 0 then
    Result:= true
  else
    Result:= false;
end;

// Проверка коректности маски (иначе все имена буду одинаковые, что невозможно)

function TfmMain.CheckMask(const Mask: string): boolean;
begin
  Result:= false;
  if (pos('[C]', Mask) > 0) or (Pos('[NAME]', Mask) > 0) then
    Result:= true;
end;

// Добавляем расширение в набор

procedure TfmMain.cmbExtsClick(Sender: TObject);
begin
  edExts.SelText:= cmbExts.Text + ';';
end;

// Добавляем маску

procedure TfmMain.cmbMaskAddClick(Sender: TObject);
begin
  edMask.SelText:= cmbMaskAdd.Text;
end;

// Обертка для удаления подстроки

function TfmMain.DelSomeStr(const sourceStr, delStr: string;
  mode: integer): string;
begin
  case mode of
    1:begin
      result:= stringreplace(sourceStr, delStr, '', [rfIgnoreCase]);
    end;
    2:begin
      result:= stringreplace(sourceStr, delStr, '', [rfReplaceAll, rfIgnoreCase]);
    end;
    else
      result:= stringreplace(sourceStr, delStr, '', [rfIgnoreCase]);
  end;
end;

// Применеие маски к имени файла согласно настройкам

function TfmMain.DoMask(const src: string; index: integer): string;
var
  res: string;
begin
  Result:= '';
  if src = '' then Exit;
  if mskText = '' then
  begin
    Result:= src;
    Exit;
  end;
  res:= mskText;
  if pos('[C]', mskText) > 0 then
  begin
    res:= StringReplace(res, '[C]', AddZeros(index + 1, mskZeroCnt), [rfReplaceAll]);
  end;
  if pos('[NAME]', res) > 0 then
  begin
    res:= StringReplace(res, '[NAME]', DelSomeStr(src,ExtractFileExt(src)), [rfReplaceAll]);
  end;
  if pos('[RANDOM]', res) > 0 then
  begin
    Randomize;
    res:= StringReplace(res, '[RANDOM]', inttostr(Random(9999999)), [rfReplaceAll]);
  end;
  res:= res + ExtractFileExt(src);
  Result:= res;
end;

// Изменение списка включенных расширений (обновим список)

procedure TfmMain.edExtsChange(Sender: TObject);
begin
  mskExts:= edExts.Text;
  ShowSelected;
end;

// Изменение маски (обновление списка)

procedure TfmMain.edMaskChange(Sender: TObject);
begin
  mskText:= edMask.Text;
  ShowSelected;
end;

// Блокируем ввод некоректных символов в названии

procedure TfmMain.edMaskKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['\', '/', ':', '*', '?', '"', '<', '>', '|'] then
    Key:= #0;
end;

// При создании проводим инициализацию необходимых переменных

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Init;
end;

// Инициализация необходимых переменных

procedure TfmMain.Init;
begin
  edMask.OnChange(self);
  edMask.SelStart:= edMask.GetTextLen;
  rType:= true;
  UpdateType;
end;

// При клике обновим список

procedure TfmMain.lbFileClick(Sender: TObject);
begin
  ShowSelected;
end;

// При Ctrl+A выбираем все файлы и обновляем список

procedure TfmMain.lbFileKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = ord('A')) then
    lbFile.SelectAll;
  ShowSelected;
end;

// Размножение строки

function TfmMain.MulStr(Input: string; Rep: integer): string;
var
  i: integer;
begin
  for i := 0 to Rep - 1 do
    result := result + Input;
end;

// При изменении типа нумерации обновим переменные

procedure TfmMain.rgRenameTypeClick(Sender: TObject);
begin
  rType:= (rgRenameType.ItemIndex = 0);
  UpdateType;
end;

// Отображение примененного фильтра

procedure TfmMain.ShowSelected;
var
  I, n: Integer;
begin
  lbResult.Items.BeginUpdate;
  cmbExts.Items.BeginUpdate;
  lbResult.Clear;
  cmbExts.Clear;
  n:= 0;
  for I := 0 to lbFile.Count - 1 do
  begin
    if lbFile.Selected[I] then
    begin
      if mskExts <> '' then
      begin
        if CheckExt(ExtractFileExt(lbFile.Items.Strings[I])) then
        begin
          lbResult.Items.Add(DoMask(lbFile.Items.Strings[I], n));
          inc(n);
        end;
      end
      else
      begin
        lbResult.Items.Add(DoMask(lbFile.Items.Strings[I], n));
        inc(n);
      end;
      if (cmbExts.Items.IndexOf(ExtractFileExt(lbFile.Items.Strings[I])) >= 0) or (pos(ExtractFileExt(lbFile.Items.Strings[I]), mskExts) > 0) then
        Continue;
      cmbExts.Items.Add(ExtractFileExt(lbFile.Items.Strings[I]));
    end;
  end;
  cmbExts.ItemIndex:= 0;
  if not CheckMask(edMask.Text) then
    lbResult.Color:= clRed
  else
    lbResult.Color:= clWhite;
  cmbExts.Items.EndUpdate;;
  lbResult.Items.EndUpdate;
end;

// Обновление интерфейса при изменениии типа нумерации

procedure TfmMain.UpdateType;
begin
  case rType of
    true:
    begin
      sedStartNum.Enabled:= false;
      chbNums.Enabled:= false;
    end
    else
    begin
      sedStartNum.Enabled:= true;
      chbNums.Enabled:= true;
    end;
  end;
end;

// Изменение количества ведущих нулей

procedure TfmMain.sedZeroCntChange(Sender: TObject);
begin
  mskZeroCnt:= sedZeroCnt.Value;
  ShowSelected;
end;

end.
