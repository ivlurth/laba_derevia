object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form 1'
  ClientHeight = 649
  ClientWidth = 864
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lb1: TLabel
    Left = 19
    Top = 11
    Width = 146
    Height = 17
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1101#1083#1077#1084#1077#1085#1090#1086#1074':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Yu Gothic UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object imgTree: TImage
    Left = 100
    Top = 202
    Width = 747
    Height = 439
  end
  object lbl2: TLabel
    Left = 500
    Top = 11
    Width = 131
    Height = 17
    Caption = #1059#1076#1072#1083#1103#1077#1084#1072#1103' '#1074#1077#1088#1096#1080#1085#1072':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Yu Gothic UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblPram: TLabel
    Left = 19
    Top = 51
    Width = 97
    Height = 17
    Caption = #1055#1088#1103#1084#1086#1081' '#1086#1073#1093#1086#1076':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Yu Gothic UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblSim: TLabel
    Left = 19
    Top = 95
    Width = 145
    Height = 17
    Caption = #1057#1080#1084#1084#1077#1090#1088#1080#1095#1085#1099#1081' '#1086#1073#1093#1086#1076':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Yu Gothic UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblObr: TLabel
    Left = 19
    Top = 139
    Width = 108
    Height = 17
    Caption = #1050#1086#1085#1094#1077#1074#1086#1081' '#1086#1073#1093#1086#1076':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Yu Gothic UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object nudElCount: TEdit
    Left = 171
    Top = 8
    Width = 121
    Height = 25
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Yu Gothic UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = nudElCountChange
  end
  object stgEls: TStringGrid
    Left = 19
    Top = 202
    Width = 65
    Height = 439
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnBuild: TButton
    Left = 306
    Top = 8
    Width = 75
    Height = 25
    Caption = #1057#1090#1072#1088#1090
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Yu Gothic UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btnBuildClick
  end
  object nudDelEl: TEdit
    Left = 637
    Top = 8
    Width = 121
    Height = 25
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Yu Gothic UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object btnDel: TButton
    Left = 772
    Top = 8
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Yu Gothic UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnDelClick
  end
  object Memo1: TMemo
    Left = 170
    Top = 51
    Width = 677
    Height = 38
    Enabled = False
    TabOrder = 5
  end
  object Memo2: TMemo
    Left = 170
    Top = 95
    Width = 677
    Height = 38
    Enabled = False
    TabOrder = 6
  end
  object Memo3: TMemo
    Left = 170
    Top = 139
    Width = 677
    Height = 38
    Enabled = False
    TabOrder = 7
  end
end
