-- Script para criar tabelas do banco de dados de vendas
-- Análise de Dados SQL - GitHub Project

-- Limpar tabelas se existirem
DROP TABLE IF EXISTS vendas;
DROP TABLE IF EXISTS clientes;

-- Criar tabela de clientes
CREATE TABLE clientes (
    id_cliente INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cidade VARCHAR(50),
    estado VARCHAR(2),
    data_cadastro DATE,
    segmento VARCHAR(20) CHECK (segmento IN ('Standard', 'Premium'))
);

-- Criar tabela de vendas
CREATE TABLE vendas (
    id_venda INTEGER PRIMARY KEY,
    data_venda DATE NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    valor_unitario DECIMAL(10,2) NOT NULL CHECK (valor_unitario > 0),
    valor_total DECIMAL(10,2) NOT NULL CHECK (valor_total > 0),
    categoria_produto VARCHAR(50),
    regiao VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Criar índices para melhor performance
CREATE INDEX idx_vendas_data ON vendas(data_venda);
CREATE INDEX idx_vendas_cliente ON vendas(id_cliente);
CREATE INDEX idx_vendas_categoria ON vendas(categoria_produto);
CREATE INDEX idx_clientes_segmento ON clientes(segmento);

-- Inserir dados dos clientes (SQLite)
INSERT INTO clientes(id_cliente, nome, email, cidade, estado, data_cadastro, segmento) VALUES
(101,'João Silva','joao@email.com','São Paulo','SP','2023-01-15','Premium'),
(102,'Maria Santos','maria@email.com','Porto Alegre','RS','2023-02-20','Standard'),
(103,'Carlos Oliveira','carlos@email.com','Salvador','BA','2023-03-10','Standard'),
(104,'Ana Costa','ana@email.com','Rio de Janeiro','RJ','2023-01-25','Premium'),
(105,'Pedro Lima','pedro@email.com','São Paulo','SP','2023-04-05','Standard'),
(106,'Luiza Fernandes','luiza@email.com','Manaus','AM','2023-02-15','Standard'),
(107,'Ricardo Mendes','ricardo@email.com','Porto Alegre','RS','2023-05-12','Premium'),
(108,'Juliana Alves','juliana@email.com','Belo Horizonte','MG','2023-03-20','Standard'),
(109,'Fernando Gomes','fernando@email.com','Recife','PE','2023-01-30','Standard'),
(110,'Camila Dias','camila@email.com','Florianópolis','SC','2023-04-18','Premium'),
(111,'Roberto Silva','roberto@email.com','Brasília','DF','2023-02-28','Standard'),
(112,'Tatiana Oliveira','tatiana@email.com','São Paulo','SP','2023-06-01','Premium'),
(113,'Marcos Costa','marcos@email.com','Salvador','BA','2023-03-15','Standard'),
(114,'Patrícia Lima','patricia@email.com','Rio de Janeiro','RJ','2023-05-20','Premium'),
(115,'André Santos','andre@email.com','Porto Alegre','RS','2023-02-10','Standard'),
(116,'Lúcia Mendes','lucia@email.com','Manaus','AM','2023-04-25','Standard'),
(117,'Eduardo Alves','eduardo@email.com','Belo Horizonte','MG','2023-01-18','Premium'),
(118,'Sofia Gomes','sofia@email.com','Recife','PE','2023-03-08','Standard'),
(119,'Gustavo Dias','gustavo@email.com','Florianópolis','SC','2023-05-15','Premium'),
(120,'Fernanda Costa','fernanda@email.com','Brasília','DF','2023-02-22','Standard');

-- Inserir dados das vendas (SQLite)
INSERT INTO vendas(id_venda, data_venda, id_cliente, id_produto, quantidade, valor_unitario, valor_total, categoria_produto, regiao) VALUES
(1,'2024-01-15',101,501,2,150.00,300.00,'Eletrônicos','Sudeste'),
(2,'2024-01-16',102,502,1,89.90,89.90,'Roupas','Sul'),
(3,'2024-01-17',103,503,3,25.50,76.50,'Livros','Nordeste'),
(4,'2024-01-18',104,504,1,1200.00,1200.00,'Eletrônicos','Sudeste'),
(5,'2024-01-19',105,505,2,45.00,90.00,'Alimentos','Sudeste'),
(6,'2024-01-20',106,506,1,299.99,299.99,'Eletrônicos','Norte'),
(7,'2024-01-21',107,507,4,15.00,60.00,'Alimentos','Sul'),
(8,'2024-01-22',108,508,2,75.00,150.00,'Roupas','Sudeste'),
(9,'2024-01-23',109,509,1,45.00,45.00,'Livros','Nordeste'),
(10,'2024-01-24',110,510,3,89.90,269.70,'Roupas','Sul'),
(11,'2024-01-25',101,511,1,899.99,899.99,'Eletrônicos','Sudeste'),
(12,'2024-01-26',111,512,2,35.00,70.00,'Alimentos','Norte'),
(13,'2024-01-27',112,513,1,120.00,120.00,'Roupas','Sudeste'),
(14,'2024-01-28',113,514,5,12.50,62.50,'Alimentos','Nordeste'),
(15,'2024-01-29',114,515,2,89.90,179.80,'Eletrônicos','Sul'),
(16,'2024-01-30',115,516,3,25.00,75.00,'Livros','Sudeste'),
(17,'2024-01-31',116,517,1,450.00,450.00,'Eletrônicos','Norte'),
(18,'2024-02-01',117,518,4,22.50,90.00,'Alimentos','Sul'),
(19,'2024-02-02',118,519,2,65.00,130.00,'Roupas','Nordeste'),
(20,'2024-02-03',119,520,1,35.00,35.00,'Livros','Sudeste');

-- Verificar dados inseridos
SELECT 'Clientes inseridos: ' || COUNT(*) as info FROM clientes;
SELECT 'Vendas inseridas: ' || COUNT(*) as info FROM vendas;
