object fmMain: TfmMain
  Left = 309
  Top = 279
  Caption = 'Renamer v.1.0'
  ClientHeight = 516
  ClientWidth = 714
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 714
    Height = 497
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 353
      Height = 497
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object cmbDrive: TDriveComboBox
        Left = 0
        Top = 0
        Width = 353
        Height = 19
        Align = alTop
        DirList = lbDir
        TabOrder = 0
      end
      object lbDir: TDirectoryListBox
        Left = 0
        Top = 19
        Width = 353
        Height = 97
        Align = alTop
        FileList = lbFile
        ItemHeight = 16
        TabOrder = 1
      end
      object lbFile: TFileListBox
        Left = 0
        Top = 116
        Width = 353
        Height = 381
        Align = alClient
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 2
        OnClick = lbFileClick
        OnKeyDown = lbFileKeyDown
      end
    end
    object pnlRight: TPanel
      Left = 353
      Top = 0
      Width = 361
      Height = 497
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object pnlResult: TPanel
        Left = 0
        Top = 241
        Width = 361
        Height = 256
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lbResult: TListBox
          Left = 0
          Top = 0
          Width = 361
          Height = 256
          Align = alClient
          ItemHeight = 13
          TabOrder = 0
        end
      end
      object pnlSettings: TPanel
        Left = 0
        Top = 0
        Width = 361
        Height = 241
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object lblMask: TLabel
          Left = 6
          Top = 36
          Width = 68
          Height = 13
          Caption = #1052#1072#1089#1082#1072' '#1080#1084#1077#1085#1080':'
        end
        object lblExts: TLabel
          Left = 183
          Top = 36
          Width = 119
          Height = 13
          Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1088#1072#1089#1096#1080#1088#1077#1085#1080#1103':'
        end
        object bvlSettings: TBevel
          Left = 0
          Top = 115
          Width = 361
          Height = 3
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Shape = bsBottomLine
        end
        object Label1: TLabel
          Left = 7
          Top = 76
          Width = 160
          Height = 13
          Caption = #1044#1083#1103' '#1087#1088#1086#1089#1090#1086#1075#1086' '#1087#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1085#1080#1103':'
        end
        object Label2: TLabel
          Left = 6
          Top = 118
          Width = 167
          Height = 13
          Caption = #1044#1083#1103' '#1085#1086#1084#1077#1088#1085#1086#1075#1086' '#1087#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1085#1080#1103':'
        end
        object rgRenameType: TRadioGroup
          Left = 0
          Top = 0
          Width = 361
          Height = 33
          Align = alTop
          Caption = #1058#1080#1087' '#1087#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1085#1080#1103
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            #1055#1088#1086#1089#1090#1086#1081
            #1055#1086' '#1085#1086#1084#1077#1088#1091' '#1074' '#1080#1084#1077#1085#1080)
          TabOrder = 0
          OnClick = rgRenameTypeClick
        end
        object edMask: TEdit
          Left = 6
          Top = 50
          Width = 171
          Height = 27
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = '[C] - [NAME]'
          OnChange = edMaskChange
          OnKeyPress = edMaskKeyPress
        end
        object edExts: TEdit
          Left = 183
          Top = 50
          Width = 170
          Height = 27
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnChange = edExtsChange
        end
        object cmbMaskAdd: TComboBox
          Left = 6
          Top = 90
          Width = 85
          Height = 22
          Ctl3D = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          Text = '[C]'
          OnClick = cmbMaskAddClick
          Items.Strings = (
            '[C]'
            '[NAME]'
            '[RANDOM]')
        end
        object sedZeroCnt: TSpinEdit
          Left = 92
          Top = 90
          Width = 85
          Height = 22
          Ctl3D = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          MaxValue = 15
          MinValue = 1
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 4
          Value = 1
          OnChange = sedZeroCntChange
        end
        object cmbExts: TComboBox
          Left = 183
          Top = 90
          Width = 85
          Height = 22
          Ctl3D = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = []
          ItemHeight = 14
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 5
          OnClick = cmbExtsClick
        end
        object sedStartNum: TSpinEdit
          Left = 6
          Top = 133
          Width = 85
          Height = 22
          Hint = #1053#1072#1095#1072#1083#1086' '#1094#1080#1092#1088#1099' '#1074' '#1085#1072#1079#1074#1072#1085#1080#1080'.'
          Ctl3D = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          MaxValue = 255
          MinValue = 0
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          Value = 0
          OnChange = sedZeroCntChange
        end
        object chbNums: TCheckBox
          Left = 97
          Top = 135
          Width = 136
          Height = 17
          Caption = #1074#1089#1077' '#1094#1080#1092#1088#1099' '#1074' '#1085#1072#1079#1074#1072#1085#1080#1080
          TabOrder = 7
          OnClick = chbNumsClick
        end
      end
    end
  end
  object stsBar: TStatusBar
    Left = 0
    Top = 497
    Width = 714
    Height = 19
    Panels = <>
  end
end
