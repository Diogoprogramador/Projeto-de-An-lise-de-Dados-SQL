-- Análise de Dados de Vendas
-- GitHub SQL Data Analysis Project

-- 1. Visão Geral das Vendas
SELECT 
    'Visão Geral' as tipo_analise,
    COUNT(*) as total_vendas,
    SUM(valor_total) as faturamento_total,
    AVG(valor_total) as ticket_medio,
    MIN(data_venda) as primeira_venda,
    MAX(data_venda) as ultima_venda
FROM vendas;

-- 2. Vendas por Categoria de Produto
SELECT 
    categoria_produto,
    COUNT(*) as quantidade_vendas,
    SUM(valor_total) as faturamento_total,
    AVG(valor_total) as ticket_medio,
    ROUND(SUM(valor_total) * 100.0 / (SELECT SUM(valor_total) FROM vendas), 2) as percentual_faturamento
FROM vendas 
GROUP BY categoria_produto 
ORDER BY faturamento_total DESC;

-- 3. Vendas por Região
SELECT 
    regiao,
    COUNT(*) as quantidade_vendas,
    SUM(valor_total) as faturamento_total,
    AVG(valor_total) as ticket_medio,
    COUNT(DISTINCT id_cliente) as clientes_unicos
FROM vendas 
GROUP BY regiao 
ORDER BY faturamento_total DESC;

-- 4. Top 10 Clientes por Faturamento
SELECT 
    c.id_cliente,
    c.nome,
    c.segmento,
    COUNT(v.id_venda) as quantidade_vendas,
    SUM(v.valor_total) as faturamento_total,
    AVG(v.valor_total) as ticket_medio
FROM clientes c
JOIN vendas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nome, c.segmento
ORDER BY faturamento_total DESC
LIMIT 10;

-- 5. Análise Temporal - Vendas por Mês
SELECT 
    DATE_TRUNC('month', data_venda) as mes,
    COUNT(*) as quantidade_vendas,
    SUM(valor_total) as faturamento_total,
    AVG(valor_total) as ticket_medio,
    COUNT(DISTINCT id_cliente) as clientes_unicos
FROM vendas 
GROUP BY DATE_TRUNC('month', data_venda)
ORDER BY mes;

-- 6. Análise de Segmento de Clientes
SELECT 
    c.segmento,
    COUNT(DISTINCT c.id_cliente) as quantidade_clientes,
    COUNT(v.id_venda) as quantidade_vendas,
    SUM(v.valor_total) as faturamento_total,
    AVG(v.valor_total) as ticket_medio
FROM clientes c
LEFT JOIN vendas v ON c.id_cliente = v.id_cliente
GROUP BY c.segmento
ORDER BY faturamento_total DESC;

-- 7. Produtos mais Vendidos (por quantidade)
SELECT 
    id_produto,
    categoria_produto,
    COUNT(*) as frequencia_venda,
    SUM(quantidade) as quantidade_total,
    SUM(valor_total) as faturamento_total
FROM vendas 
GROUP BY id_produto, categoria_produto
ORDER BY quantidade_total DESC, faturamento_total DESC
LIMIT 10;

-- 8. Análise de Sazonalidade por Dia da Semana
SELECT 
    EXTRACT(DOW FROM data_venda) as dia_semana_num,
    CASE 
        WHEN EXTRACT(DOW FROM data_venda) = 0 THEN 'Domingo'
        WHEN EXTRACT(DOW FROM data_venda) = 1 THEN 'Segunda'
        WHEN EXTRACT(DOW FROM data_venda) = 2 THEN 'Terça'
        WHEN EXTRACT(DOW FROM data_venda) = 3 THEN 'Quarta'
        WHEN EXTRACT(DOW FROM data_venda) = 4 THEN 'Quinta'
        WHEN EXTRACT(DOW FROM data_venda) = 5 THEN 'Sexta'
        WHEN EXTRACT(DOW FROM data_venda) = 6 THEN 'Sábado'
    END as dia_semana,
    COUNT(*) as quantidade_vendas,
    SUM(valor_total) as faturamento_total,
    AVG(valor_total) as ticket_medio
FROM vendas 
GROUP BY EXTRACT(DOW FROM data_venda), dia_semana
ORDER BY dia_semana_num;
