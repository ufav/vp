object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 617
  ClientWidth = 1035
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    1035
    617)
  PixelsPerInch = 96
  TextHeight = 13
  object green_list: TWebBrowser
    Left = 0
    Top = 405
    Width = 185
    Height = 209
    Anchors = [akLeft, akBottom]
    TabOrder = 0
    OnNavigateComplete2 = green_listNavigateComplete2
    OnDocumentComplete = green_listDocumentComplete
    ControlData = {
      4C0000001F1300009A1500000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E12620A000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 577
    Height = 209
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object predictions: TWebBrowser
    Left = 191
    Top = 405
    Width = 194
    Height = 209
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    OnNavigateComplete2 = predictionsNavigateComplete2
    OnDocumentComplete = predictionsDocumentComplete
    ExplicitTop = 208
    ControlData = {
      4C0000000D1400009A1500000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E12620A000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Memo2: TMemo
    Left = 0
    Top = 215
    Width = 577
    Height = 184
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object Memo3: TMemo
    Left = 391
    Top = 405
    Width = 186
    Height = 209
    Anchors = [akLeft, akBottom]
    TabOrder = 4
  end
end
