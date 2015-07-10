unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, ComCtrls;

type
  TfmMain = class(TForm)
    stsBar: TStatusBar;
    lbFile: TFileListBox;
    lbDir: TDirectoryListBox;
    cmbDrive: TDriveComboBox;
    procedure lbFileKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    btnCrtl: boolean;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.lbFileKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = 65) then
    FileListBox1.SelectAll;
end;

end.
