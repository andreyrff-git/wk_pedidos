object ConsultaClientes: TConsultaClientes
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Consulta de Clientes'
  ClientHeight = 398
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 49
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 0
      Width = 183
      Height = 15
      Caption = 'Digite C'#243'digo ou Nome do Cliente'
    end
    object edtBusca: TEdit
      Left = 5
      Top = 14
      Width = 229
      Height = 23
      Hint = 'Bot'#227'o Selecionar ou tecle <ENTER> na grid.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnExit = edtBuscaExit
    end
    object btnSelecionar: TButton
      Left = 237
      Top = 13
      Width = 97
      Height = 25
      Caption = 'Selecionar'
      TabOrder = 1
      OnClick = btnSelecionarClick
    end
    object rgConsulta: TRadioGroup
      Left = 344
      Top = 7
      Width = 185
      Height = 30
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'C'#243'digo'
        'Nome')
      ParentFont = False
      TabOrder = 2
    end
  end
  object pnAll: TPanel
    Left = 0
    Top = 49
    Width = 624
    Height = 349
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 351
    object dbgClientes: TDBGrid
      Left = 1
      Top = 1
      Width = 622
      Height = 347
      Hint = 'Bot'#227'o Selecionar ou tecle <ENTER> na grid.'
      Align = alClient
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      StyleName = 'Windows'
      OnKeyDown = dbgClientesKeyDown
    end
  end
  object cdsClientes: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 520
    Top = 80
  end
  object dsClientes: TDataSource
    Left = 440
    Top = 80
  end
end
