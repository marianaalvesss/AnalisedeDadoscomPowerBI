-- Criando o esquema do banco de dados para e-commerce
CREATE DATABASE Ecommerce;
USE Ecommerce;

-- Tabela Cliente
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    tipo ENUM('PJ', 'PF') NOT NULL,
    cpf_cnpj VARCHAR(18) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20)
);

-- Tabela Endereço
CREATE TABLE Endereco (
    id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    logradouro VARCHAR(255) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Tabela Fornecedor
CREATE TABLE Fornecedor (
    id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    contato VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela Produto
CREATE TABLE Produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    id_fornecedor INT,
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor)
);

-- Tabela Estoque
CREATE TABLE Estoque (
    id_estoque INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT,
    quantidade INT NOT NULL,
    localizacao VARCHAR(100),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Tabela Pedido
CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pendente', 'Enviado', 'Entregue', 'Cancelado') NOT NULL,
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Tabela ItemPedido
CREATE TABLE ItemPedido (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    id_produto INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    tipo_pagamento ENUM('Cartão de Crédito', 'Boleto', 'Pix', 'Transferência') NOT NULL,
    status ENUM('Aprovado', 'Pendente', 'Recusado') NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- Inserção de dados
INSERT INTO Cliente (nome, tipo, cpf_cnpj, email, telefone) VALUES 
('Maria Silva', 'PF', '123.456.789-00', 'maria@email.com', '11987654321'),
('Empresa XYZ', 'PJ', '12.345.678/0001-99', 'contato@xyz.com', '1133334444');

INSERT INTO Fornecedor (nome, contato, email) VALUES 
('Fornecedor A', '1111-2222', 'fornecedorA@email.com'),
('Fornecedor B', '3333-4444', 'fornecedorB@email.com');

INSERT INTO Produto (nome, descricao, preco, id_fornecedor) VALUES 
('Produto 1', 'Descrição do Produto 1', 100.00, 1),
('Produto 2', 'Descrição do Produto 2', 150.00, 2);

INSERT INTO Estoque (id_produto, quantidade, localizacao) VALUES 
(1, 50, 'Depósito 1'),
(2, 30, 'Depósito 2');

INSERT INTO Pedido (id_cliente, status, codigo_rastreio) VALUES 
(1, 'Pendente', 'RA123456789BR');

INSERT INTO ItemPedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES 
(1, 1, 2, 100.00);

INSERT INTO Pagamento (id_pedido, tipo_pagamento, status) VALUES 
(1, 'Pix', 'Aprovado');

-- Consultas SQL

-- Quantos pedidos foram feitos por cada cliente?
SELECT c.nome, COUNT(p.id_pedido) AS total_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.nome;

-- Algum vendedor também é fornecedor?
SELECT c.nome AS vendedor, f.nome AS fornecedor
FROM Cliente c
INNER JOIN Fornecedor f ON c.nome = f.nome;

-- Relação de produtos, fornecedores e estoques
SELECT p.nome AS produto, f.nome AS fornecedor, e.quantidade AS estoque
FROM Produto p
INNER JOIN Fornecedor f ON p.id_fornecedor = f.id_fornecedor
INNER JOIN Estoque e ON p.id_produto = e.id_produto;

-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT f.nome AS fornecedor, p.nome AS produto
FROM Fornecedor f
INNER JOIN Produto p ON f.id_fornecedor = p.id_fornecedor;

-- Filtrando pedidos aprovados com PIX
SELECT * FROM Pagamento WHERE tipo_pagamento = 'Pix' AND status = 'Aprovado';

-- Ordenação dos pedidos mais recentes
SELECT * FROM Pedido ORDER BY data_pedido DESC;
