-- Criando o esquema do banco de dados para a oficina
CREATE DATABASE Oficina;
USE Oficina;

-- Tabela Cliente
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

-- Tabela Veículo
CREATE TABLE Veiculo (
    id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    placa VARCHAR(10) UNIQUE NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    marca VARCHAR(100) NOT NULL,
    ano INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Tabela Serviço
CREATE TABLE Servico (
    id_servico INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);

-- Tabela Ordem de Serviço
CREATE TABLE OrdemServico (
    id_ordem INT PRIMARY KEY AUTO_INCREMENT,
    id_veiculo INT,
    data_abertura DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Aberta', 'Em Andamento', 'Concluída', 'Cancelada') NOT NULL,
    total DECIMAL(10,2),
    FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo)
);

-- Tabela Itens da Ordem de Serviço
CREATE TABLE ItemOrdemServico (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_ordem INT,
    id_servico INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_ordem) REFERENCES OrdemServico(id_ordem),
    FOREIGN KEY (id_servico) REFERENCES Servico(id_servico)
);

-- Inserção de dados
INSERT INTO Cliente (nome, cpf, telefone, email) VALUES 
('João Silva', '123.456.789-00', '11987654321', 'joao@email.com'),
('Maria Souza', '987.654.321-00', '11912345678', 'maria@email.com');

INSERT INTO Veiculo (id_cliente, placa, modelo, marca, ano) VALUES 
(1, 'ABC-1234', 'Civic', 'Honda', 2019),
(2, 'XYZ-9876', 'Corolla', 'Toyota', 2021);

INSERT INTO Servico (descricao, preco) VALUES 
('Troca de óleo', 150.00),
('Alinhamento', 100.00),
('Revisão geral', 300.00);

INSERT INTO OrdemServico (id_veiculo, status, total) VALUES 
(1, 'Aberta', NULL),
(2, 'Em Andamento', NULL);

INSERT INTO ItemOrdemServico (id_ordem, id_servico, quantidade, preco_unitario) VALUES 
(1, 1, 1, 150.00),
(1, 2, 1, 100.00),
(2, 3, 1, 300.00);

-- Consultas SQL

-- Recuperação de todas as ordens de serviço
SELECT * FROM OrdemServico;

-- Quantidade de serviços realizados por ordem de serviço
SELECT id_ordem, COUNT(id_item) AS total_servicos
FROM ItemOrdemServico
GROUP BY id_ordem;

-- Valor total por ordem de serviço
SELECT id_ordem, SUM(quantidade * preco_unitario) AS total
FROM ItemOrdemServico
GROUP BY id_ordem
HAVING SUM(quantidade * preco_unitario) > 100;

-- Clientes que possuem veículos cadastrados
SELECT c.nome, v.modelo, v.marca, v.ano
FROM Cliente c
INNER JOIN Veiculo v ON c.id_cliente = v.id_cliente;

-- Veículos e seus respectivos serviços realizados
SELECT v.modelo, v.placa, s.descricao, ios.quantidade, ios.preco_unitario
FROM Veiculo v
INNER JOIN OrdemServico os ON v.id_veiculo = os.id_veiculo
INNER JOIN ItemOrdemServico ios ON os.id_ordem = ios.id_ordem
INNER JOIN Servico s ON ios.id_servico = s.id_servico
ORDER BY v.modelo;
