program PedidoVenda;

uses
  Vcl.Forms,
  FireDAC.Phys.MySQLWrapper,
  DMConnection in 'src\database\DMConnection.pas' {DM: TDataModule},
  ReadConfig in 'src\database\config\ReadConfig.pas',
  model.TCliente in 'src\model\model.TCliente.pas',
  ClienteController in 'src\controller\ClienteController.pas',
  ClienteRepository in 'src\database\persist\ClienteRepository.pas',
  ProdutoRepository in 'src\database\persist\ProdutoRepository.pas',
  model.TProduto in 'src\model\model.TProduto.pas',
  ProdutoController in 'src\controller\ProdutoController.pas',
  FrmConsultaClientes in 'src\view\FrmConsultaClientes.pas' {ConsultaClientes},
  FrmPrincipal in 'src\view\FrmPrincipal.pas' {Principal},
  FrmConsultaProdutos in 'src\view\FrmConsultaProdutos.pas' {ConsultaProdutos},
  model.TPedidoDadosGerais in 'src\model\model.TPedidoDadosGerais.pas',
  model.TPedidoProdutos in 'src\model\model.TPedidoProdutos.pas',
  PedidoRepository in 'src\database\persist\PedidoRepository.pas',
  PedidoController in 'src\controller\PedidoController.pas',
  FrmPedidos in 'src\view\FrmPedidos.pas' {Pedidos},
  model.TPedidoCompleto in 'src\model\model.TPedidoCompleto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TPrincipal, Principal);
  //  Application.CreateForm(TPrincipal, Principal);
  Application.Run;
end.
