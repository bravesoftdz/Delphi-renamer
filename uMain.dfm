object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'fmMain'
  ClientHeight = 517
  ClientWidth = 728
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object stsBar: TStatusBar
    Left = 0
    Top = 498
    Width = 728
    Height = 19
    Panels = <>
    ExplicitLeft = 224
    ExplicitTop = 240
    ExplicitWidth = 0
  end
  object lbFile: TFileListBox
    Left = 8
    Top = 231
    Width = 353
    Height = 264
    FileType = [ftHidden, ftSystem, ftArchive, ftNormal]
    IntegralHeight = True
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 1
    OnKeyDown = lbFileKeyDown
  end
  object lbDir: TDirectoryListBox
    Left = 8
    Top = 128
    Width = 353
    Height = 97
    FileList = lbFile
    ItemHeight = 16
    TabOrder = 2
  end
  object cmbDrive: TDriveComboBox
    Left = 8
    Top = 103
    Width = 353
    Height = 19
    TabOrder = 3
  end
end
