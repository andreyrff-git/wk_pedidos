object Principal: TPrincipal
  Left = 0
  Top = 0
  Caption = 'Sistema de Pedido - WK'
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
  object MainMenu1: TMainMenu
    Left = 168
    Top = 48
    object Sistema1: TMenuItem
      Caption = 'Sistema'
      object Fechar1: TMenuItem
        Caption = '&Fechar'
        OnClick = Fechar1Click
      end
    end
    object Vendas1: TMenuItem
      Caption = '&Vendas'
      object ManutPedido1: TMenuItem
        Caption = '&Pedidos'
        OnClick = ManutPedido1Click
      end
    end
  end
end
