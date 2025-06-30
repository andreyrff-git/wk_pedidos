object Pedidos: TPedidos
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Pedidos'
  ClientHeight = 527
  ClientWidth = 695
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  TextHeight = 15
  object pnCabecalho: TPanel
    Left = 0
    Top = 0
    Width = 695
    Height = 221
    Align = alTop
    TabOrder = 0
    object pnProdutos: TPanel
      Left = 1
      Top = 153
      Width = 693
      Height = 67
      Align = alBottom
      TabOrder = 0
      ExplicitTop = 69
      object gbProdutos: TGroupBox
        Left = 1
        Top = 1
        Width = 691
        Height = 65
        Align = alTop
        Caption = ' Informa'#231#245'es dos Produtos '
        Enabled = False
        TabOrder = 0
        ExplicitTop = -7
        object lbCodigoProduto: TLabel
          Left = 24
          Top = 14
          Width = 39
          Height = 15
          Caption = 'C'#243'digo'
          StyleName = 'Windows'
        end
        object btPesquisaProduto: TSpeedButton
          Left = 148
          Top = 31
          Width = 23
          Height = 22
          Hint = 'Consultar Produtos'
          Caption = '...'
          OnClick = btPesquisaProdutoClick
        end
        object Label1: TLabel
          Left = 178
          Top = 14
          Width = 54
          Height = 15
          Caption = 'Descri'#231#227'o:'
          StyleName = 'Windows'
        end
        object Label2: TLabel
          Left = 507
          Top = 14
          Width = 89
          Height = 15
          Caption = 'Valor do Produto'
          StyleName = 'Windows'
        end
        object Label3: TLabel
          Left = 430
          Top = 14
          Width = 62
          Height = 15
          Caption = 'Quantidade'
          StyleName = 'Windows'
        end
        object edtCodigoProduto: TEdit
          Left = 24
          Top = 30
          Width = 121
          Height = 23
          NumbersOnly = True
          TabOrder = 0
          OnExit = edtCodigoProdutoExit
        end
        object edtDescProduto: TEdit
          Left = 179
          Top = 30
          Width = 238
          Height = 23
          Enabled = False
          TabOrder = 1
        end
        object edtQuantidade: TEdit
          Left = 430
          Top = 30
          Width = 66
          Height = 23
          NumbersOnly = True
          TabOrder = 2
        end
        object btnConfirma: TButton
          Left = 616
          Top = 28
          Width = 71
          Height = 25
          Hint = 'Confirmar item para o pedido'
          Caption = 'Confirmar'
          TabOrder = 4
          OnClick = btnConfirmaClick
        end
        object edtPrecoVenda: TNumberBox
          Left = 510
          Top = 30
          Width = 100
          Height = 23
          TabOrder = 3
        end
      end
    end
    object pnControlePedidos: TPanel
      Left = 1
      Top = 1
      Width = 693
      Height = 80
      Align = alTop
      TabOrder = 1
      object gbPedidos: TGroupBox
        Left = 1
        Top = 1
        Width = 691
        Height = 104
        Align = alTop
        Caption = 'Pedidos '
        TabOrder = 0
        ExplicitWidth = 272
        object Label4: TLabel
          Left = 9
          Top = 19
          Width = 101
          Height = 15
          Caption = 'N'#250'mero do Pedido'
        end
        object edtNrPedido: TEdit
          Left = 12
          Top = 40
          Width = 104
          Height = 23
          NumbersOnly = True
          TabOrder = 0
          OnEnter = edtNrPedidoEnter
        end
        object btnConsultarPedido: TButton
          Left = 122
          Top = 38
          Width = 63
          Height = 25
          Hint = 'Consultar Pedido'
          Caption = 'Consultar'
          Enabled = False
          TabOrder = 1
          OnClick = btnConsultarPedidoClick
        end
        object pnlBtn: TPanel
          Left = 200
          Top = 31
          Width = 169
          Height = 38
          TabOrder = 2
          object btnGravarPedido: TButton
            Left = 15
            Top = 6
            Width = 63
            Height = 25
            Hint = 'Gravar Pedido'
            Caption = 'Gravar'
            Enabled = False
            TabOrder = 0
            OnClick = btnGravarPedidoClick
          end
          object btnExcluiPedido: TButton
            Left = 93
            Top = 6
            Width = 63
            Height = 25
            Hint = 'Excluir Pedido'
            Caption = 'Excluir'
            TabOrder = 1
            OnClick = btnExcluiPedidoClick
          end
        end
      end
    end
    object gbCliente: TGroupBox
      Left = 1
      Top = 81
      Width = 693
      Height = 68
      Align = alTop
      Caption = 'Cliente'
      TabOrder = 2
      object btPesquisaCliente: TSpeedButton
        Left = 150
        Top = 32
        Width = 23
        Height = 23
        Hint = 'Consultar Clientes'
        Caption = '...'
        OnClick = btPesquisaClienteClick
      end
      object lbCodigoCliente: TLabel
        Left = 26
        Top = 15
        Width = 96
        Height = 15
        Caption = 'C'#243'digo do Cliente'
      end
      object lbNomeCliente: TLabel
        Left = 186
        Top = 15
        Width = 90
        Height = 15
        Caption = 'Nome do Cliente'
      end
      object edtCodCliente: TEdit
        Left = 26
        Top = 32
        Width = 121
        Height = 23
        NumbersOnly = True
        TabOrder = 0
        OnExit = edtCodClienteExit
      end
      object bdkCliente: TDBLookupComboBox
        Left = 184
        Top = 32
        Width = 434
        Height = 23
        KeyField = 'codigo'
        ListField = 'nome'
        ListSource = dsCliente
        TabOrder = 1
        OnExit = bdkClienteExit
      end
    end
  end
  object pnRodape: TPanel
    Left = 0
    Top = 486
    Width = 695
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 400
    object pnTotal: TPanel
      Left = 509
      Top = 1
      Width = 185
      Height = 39
      Align = alRight
      Alignment = taRightJustify
      Caption = 'Valor Total --> 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 501
    end
  end
  object pnGrid: TPanel
    Left = 0
    Top = 221
    Width = 695
    Height = 265
    Align = alClient
    TabOrder = 2
    ExplicitTop = 137
    ExplicitHeight = 263
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 693
      Height = 263
      Align = alClient
      DataSource = dsItensPedido
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      StyleName = 'Windows'
      OnDrawColumnCell = DBGrid1DrawColumnCell
      OnKeyDown = DBGrid1KeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'CodigoProduto'
          Title.Caption = 'C'#243'digo do Produto'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DescricaoProduto'
          Title.Caption = 'Descri'#231#227'o do Produto'
          Width = 313
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Quantidade'
          Title.Alignment = taCenter
          Width = 73
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ValorUnitario'
          Title.Alignment = taRightJustify
          Title.Caption = 'Valor Unit'#225'rio'
          Width = 84
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ValorTotal'
          Title.Alignment = taRightJustify
          Title.Caption = 'Valor Total'
          Visible = True
        end>
    end
  end
  object cdsItensPedido: TClientDataSet
    Aggregates = <>
    Params = <>
    OnCalcFields = cdsItensPedidoCalcFields
    Left = 392
    Top = 217
    object cdsItensPedidoCodigoProduto: TIntegerField
      FieldName = 'CodigoProduto'
    end
    object cdsItensPedidoDescricaoProduto: TStringField
      FieldName = 'DescricaoProduto'
      Size = 255
    end
    object cdsItensPedidoQuantidade: TCurrencyField
      FieldName = 'Quantidade'
      currency = False
    end
    object cdsItensPedidoValorUnitario: TCurrencyField
      FieldName = 'ValorUnitario'
    end
    object cdsItensPedidoValorTotal: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'ValorTotal'
      Calculated = True
    end
  end
  object dsItensPedido: TDataSource
    DataSet = cdsItensPedido
    Left = 307
    Top = 217
  end
  object dsCliente: TDataSource
    DataSet = qryClientes
    Left = 307
    Top = 297
  end
  object qryClientes: TFDQuery
    Connection = DM.FDConnection
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT codigo, nome from clientes'
      'order by nome')
    Left = 384
    Top = 297
    object qryClientescodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object qryClientesnome: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome'
      Origin = 'nome'
      Size = 133
    end
  end
  object VirtualImageList1: TVirtualImageList
    Images = <>
    Left = 480
    Top = 297
  end
end
