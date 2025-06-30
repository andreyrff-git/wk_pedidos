CREATE DATABASE `wk_pedidos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;

create table clientes (
codigo INT NOT NULL AUTO_INCREMENT,
nome varchar(100),
cidade varchar(70),
uf varchar(2),
PRIMARY KEY (codigo),
    INDEX idx_nome (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


create table produtos (
codigo INT NOT NULL AUTO_INCREMENT,
descricao varchar(100) NOT NULL,
preco_venda DECIMAL(14, 4) NOT NULL,
PRIMARY KEY (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


create table pedido_geral (
nrpedido INT NOT NULL AUTO_INCREMENT,
codcliente INT NOT NULL,
vrtotal DECIMAL(14, 4) NOT NULL,
data_emissao datetime default CURRENT_TIMESTAMP,
PRIMARY KEY (nrpedido),
FOREIGN KEY pedido_cliente (codcliente) references clientes(codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


create table pedidos_produtos (
id INT NOT NULL AUTO_INCREMENT,
nrpedido INT NOT NULL,
codproduto INT NOT NULL,
quantidade decimal(10,2),
vrunitario DECIMAL(14, 4) NOT NULL,
vrtotal DECIMAL(14, 4) NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY pedido_prod_produto (codproduto) references produtos(codigo)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY pedido_prod_pedido (nrpedido) references pedido_geral(nrpedido)
ON DELETE RESTRICT
ON UPDATE CASCADE,
INDEX idx_nrpedido (nrpedido),
INDEX idx_produto (codproduto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO clientes (nome, cidade, uf) VALUES
('João Silva', 'São Paulo', 'SP'),
('Maria Oliveira', 'Rio de Janeiro', 'RJ'),
('Carlos Pereira', 'Belo Horizonte', 'MG'),
('Ana Santos', 'Porto Alegre', 'RS'),
('Pedro Costa', 'Salvador', 'BA'),
('Lucia Ferreira', 'Brasília', 'DF'),
('Marcos Souza', 'Fortaleza', 'CE'),
('Juliana Almeida', 'Curitiba', 'PR'),
('Fernando Lima', 'Recife', 'PE'),
('Patricia Rocha', 'Manaus', 'AM'),
('Ricardo Martins', 'Belém', 'PA'),
('Amanda Gonçalves', 'Goiânia', 'GO'),
('Roberto Barbosa', 'Florianópolis', 'SC'),
('Camila Castro', 'Vitória', 'ES'),
('Gustavo Nunes', 'Natal', 'RN'),
('Isabela Cardoso', 'Maceió', 'AL'),
('Eduardo Ramos', 'João Pessoa', 'PB'),
('Larissa Moreira', 'Teresina', 'PI'),
('Daniel Batista', 'Campo Grande', 'MS'),
('Vanessa Andrade', 'Cuiabá', 'MT');


INSERT INTO produtos (descricao, preco_venda) VALUES
('Smartphone Galaxy S23', 4299.90),
('Notebook Dell Inspiron 15', 3599.00),
('TV LED 55" 4K Samsung', 2899.99),
('Fone Bluetooth JBL', 249.90),
('Mouse Gamer Logitech', 189.50),
('Teclado Mecânico RGB', 299.00),
('Monitor 24" LG Full HD', 899.00),
('Câmera Canon EOS Rebel', 2199.90),
('Tablet Samsung Galaxy Tab', 1299.00),
('Impressora HP Deskjet', 499.90),
('HD Externo Seagate 1TB', 299.00),
('SSD Kingston 500GB', 349.90),
('Webcam Logitech C920', 399.00),
('Caixa de Som JBL Charge', 799.90),
('Smartwatch Amazfit GTS', 599.00),
('Roteador TP-Link Archer', 249.90),
('Ventilador de Mesa', 129.90),
('Liquidificador Mondial', 159.00),
('Air Fryer Philco 4,5L', 499.90),
('Micro-ondas Panasonic', 699.00);