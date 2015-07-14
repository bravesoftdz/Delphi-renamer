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
  Dialogs, StdCtrls, FileCtrl, ComCtrls, ExtCtrls, Spin, ShellAPI,
  ImpFileListBox;

type
  TfmMain = class(TForm)
    stsBar: TStatusBar;
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
    lblSimple: TLabel;
    lblNum: TLabel;
    sedStartNum: TSpinEdit;
    chbNums: TCheckBox;
    btnRename: TButton;
    lbFile: TImpFileListBox;
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
    procedure btnRenameClick(Sender: TObject);
    procedure RenameList;
  private
    mskZeroCnt: integer;
    mskText, mskExts: string;
    rType, nAll: boolean;
    function MulStr(Input: string; Rep: integer): string;
    function AddZeros(index, iCnt: integer): string;
    function DelSomeStr(const sourceStr, delStr: string; mode: integer = 1): string;
    function CheckExt(const Ext: string): boolean;
    function CheckMask(const Mask: string): boolean;
    procedure UpdateType;
    function GetNumberStr(const src: string; const start: integer): string;
    function GetAllNumberStr(const src: string): string;
    function Filter_0(const src: string; const index: integer): string;
    function Filter_1(const src: string; const index: integer): string;
    function Filter_2(const src: string; const index: integer): string;
  public

  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

// Для отладки
procedure ODS(const s: string);
begin
  OutputDebugString(PChar(s));
end;

// Вытягиваем из строки число
function TfmMain.GetAllNumberStr(const src: string): string;
var
  n, len: integer;
begin
  Result:= '';
  n:= 0;
  while n <= len do
  begin
    if src[n] in ['0'..'9'] then
    begin
      Result:= Result + src[n];
      inc(n);
    end;
  end;
end;

// Выбираем число по позиции (если следующий символ не число, прекращаем цикл)
function TfmMain.GetNumberStr(const src: string; const start: integer): string;
var
  n, len: integer;
begin
  Result:= '';
  n:= start;
  while n < len do
  begin
    if src[n] in ['0'..'9'] then
    begin
      Result:= Result + src[n];
      inc(n);
    end
    else
      n:= len;
  end;
end;

// Добавляем ведущие нули к нумерации
function TfmMain.AddZeros(index, iCnt: integer): string;
begin
  Result:= '';
  if Length(inttostr(index)) >= iCnt then
    Result:= inttostr(index)
  else
    Result:= MulStr('0', iCnt - Length(inttostr(index))) + inttostr(index)
end;

// Переименование файлов
procedure TfmMain.btnRenameClick(Sender: TObject);
begin
  RenameList;
end;

// Выключаем возможность выбора стартовой позиции при включеном флажке
procedure TfmMain.chbNumsClick(Sender: TObject);
begin
  sedStartNum.Enabled:= not chbNums.Checked;
  nAll:= chbNums.Checked;
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
  if (pos('[C]', Mask) > 0) or (Pos('[N]', Mask) > 0) then
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

// Обертка для удаления подстроку из строки
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
  res, num: string;
  num_i: integer;
begin
  Result:= '';
  if src = '' then Exit;
  if mskText = '' then
  begin
    Result:= src;
    Exit;
  end;
  case rType of
    true:begin
      res:= Filter_0(src, index);
    end
    else
    begin
      case nAll of
        true:begin
          res:= Filter_1(src, index);
        end
        else
        begin
          res:= Filter_2(src, index);
        end;
      end;
    end;
  end;
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

// Простой фильтр
function TfmMain.Filter_0(const src: string; const index: integer): string;
var
  res, fSrc: string;
  isDir: Boolean;
begin
  isDir:= false;
  res:= mskText;
  fSrc:= src;
  if (fSrc[1] = '[') and (fSrc[length(fSrc)] = ']') then
  begin
    Delete(fSrc, 1, 1);
    Delete(fSrc, length(fSrc), 1);
    isDir:= true;
  end;
  if pos('[C]', mskText) > 0 then
  begin
    res:= StringReplace(res, '[C]', AddZeros(index + 1, mskZeroCnt), [rfReplaceAll]);
  end;
  if pos('[N]', res) > 0 then
  begin
    if not isDir then
      res:= StringReplace(res, '[N]', DelSomeStr(fSrc,ExtractFileExt(fSrc)), [rfReplaceAll])
    else
      res:= StringReplace(res, '[N]', fSrc, [rfReplaceAll]);
  end;
  if pos('[R]', res) > 0 then
  begin
    Randomize;
    res:= StringReplace(res, '[R]', inttostr(Random(9999999)), [rfReplaceAll]);
  end;
  if not isDir then
    res:= res + ExtractFileExt(src);
  Result:= res;
end;

// Нумерованный фильтр для всех чисел в названии
function TfmMain.Filter_1(const src: string; const index: integer): string;
var
  res, num, fSrc: string;
  num_i: integer;
  isDir: Boolean;
begin
  isDir:= false;
  res:= mskText;
  num:= GetAllNumberStr(src);
  try
    num_i:= strtoint(num);
  except
    num_i:= 0;
  end;
  fSrc:= src;
  if (fSrc[1] = '[') and (fSrc[length(fSrc)] = ']') then
  begin
    Delete(fSrc, 1, 1);
    Delete(fSrc, length(fSrc), 1);
    isDir:= true;
  end;
  if pos('[C]', mskText) > 0 then
  begin
    res:= StringReplace(res, '[C]', AddZeros(num_i, mskZeroCnt), [rfReplaceAll]);
  end;
  if pos('[N]', res) > 0 then
  begin
    if not isDir then
    begin
      res:= StringReplace(res, '[N]', DelSomeStr(fSrc,ExtractFileExt(fSrc)), [rfReplaceAll]);
      res:= StringReplace(res, num, AddZeros(num_i, mskZeroCnt), [rfReplaceAll]);
    end
    else
    begin
      res:= StringReplace(res, '[N]', fSrc, [rfReplaceAll]);
      res:= StringReplace(res, num, AddZeros(num_i, mskZeroCnt), [rfReplaceAll]);
    end;
  end;
  if pos('[R]', res) > 0 then
  begin
    Randomize;
    res:= StringReplace(res, '[R]', inttostr(Random(9999999)), [rfReplaceAll]);
  end;
  if not isDir then
    res:= res + ExtractFileExt(src);
  Result:= res;
end;

// Нумерованный фильтр по позиции
function TfmMain.Filter_2(const src: string; const index: integer): string;
var
  res, num, fSrc: string;
  num_i: integer;
  isDir: Boolean;
begin
  res:= mskText;
  num:= GetNumberStr(src, sedStartNum.Value);
  try
    num_i:= strtoint(num);
  except
    num_i:= 0;
  end;
  fSrc:= src;
  if (fSrc[1] = '[') and (fSrc[length(fSrc)] = ']') then
  begin
    Delete(fSrc, 1, 1);
    Delete(fSrc, length(fSrc), 1);
    isDir:= true;
  end;
  if pos('[C]', mskText) > 0 then
  begin
    res:= StringReplace(res, '[C]', AddZeros(num_i, mskZeroCnt), [rfReplaceAll]);
  end;
  if pos('[N]', res) > 0 then
  begin
    if not isDir then
    begin
      res:= StringReplace(res, '[N]', DelSomeStr(fSrc,ExtractFileExt(fSrc)), [rfReplaceAll]);
      res:= StringReplace(res, num, AddZeros(num_i, mskZeroCnt), [rfReplaceAll]);
    end
    else
    begin
      res:= StringReplace(res, '[N]', fSrc, [rfReplaceAll]);
      res:= StringReplace(res, num, AddZeros(num_i, mskZeroCnt), [rfReplaceAll]);
    end;
  end;
  if pos('[R]', res) > 0 then
  begin
    Randomize;
    res:= StringReplace(res, '[R]', inttostr(Random(9999999)), [rfReplaceAll]);
  end;
  if not isDir then
    res:= res + ExtractFileExt(src);
  Result:= res;
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
  nAll:= false;
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

// Процедура переименования
procedure TfmMain.RenameList;
var
  i, n: integer;
  fName, nfName: TFileName;
begin
  n:= 0;
  Screen.Cursor:= crHourGlass;
  stsBar.Panels[0].Text := 'Начало обработки выделенных обьектов...';
  try
    for i := 0 to lbFile.Count - 1 do
    begin
      if lbFile.Selected[i] then
      begin
        if (lbFile.Items.Strings[i][1] = '[') and (lbFile.Items.Strings[i][length(lbFile.Items.Strings[i])] = ']') then
        begin
          fName:= lbFile.Items.Strings[i];
          Delete(fName, 1, 1);
          Delete(fName, length(fName), 1);
          fName:= lbDir.Directory + '\' + fName;
        end
        else
        begin
          fName:= lbDir.Directory + '\' + lbFile.Items.Strings[i];
        end;
        nfName:= lbDir.Directory + '\' + lbResult.Items.Strings[n];
        inc(n);
        if FileExists(fName) or DirectoryExists(fName) then
        begin
          if not RenameFile(fName, nfName) then
          begin
            ShowMessage('Не удалось переименовать файл или папку ''' + fName + '''');
          end;
        end
        else
        begin
          Exit;
          ShowMessage('Файла или папки ''' + fName + ''' не существует!');
        end;
      end;
    end;
  finally
    Screen.Cursor:= crDefault;
    stsBar.Panels[0].Text := 'Успешно завершено';
    lbFile.Update;
  end;
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
      if (cmbExts.Items.IndexOf(ExtractFileExt(lbFile.Items.Strings[I])) >= 0) or (pos(ExtractFileExt(lbFile.Items.Strings[I]), mskExts) > 0) or (lbFile.Items.Strings[I][length(lbFile.Items.Strings[I])] = ']') then
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
  stsBar.Panels[0].Text:= 'Выбрано файлов: ' + inttostr(lbResult.Count);
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
