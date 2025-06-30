object fPrincipal: TfPrincipal
  Left = 0
  Top = 0
  Caption = 'Projeto WK'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  WindowState = wsMaximized
  OnCreate = FormCreate
  TextHeight = 15
  object Button1: TButton
    Left = 192
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object MainMenu1: TMainMenu
    Left = 168
    Top = 48
    object PedidosdeVendas1: TMenuItem
      Caption = 'Pedidos de Vendas'
      object NovoPedido1: TMenuItem
        Caption = '&Pedidos'
        OnClick = NovoPedido1Click
      end
    end
    object Sair1: TMenuItem
      Caption = '&Sair'
      OnClick = Sair1Click
    end
  end
end
