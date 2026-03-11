-- KPI Dashboard - Indicadores Chave de Performance
-- GitHub SQL Data Analysis Project

-- Configuração de parâmetros (ajuste conforme necessário)
-- Para PostgreSQL: SET datestyle = 'ISO, DMY';
-- Para MySQL: SET @data_inicio = '2024-01-01', @data_fim = '2024-12-31';

-- 1. KPIs Principais
WITH kpi_principais AS (
    SELECT 
        COUNT(*) as total_vendas,
        SUM(valor_total) as faturamento_total,
        AVG(valor_total) as ticket_medio,
        COUNT(DISTINCT id_cliente) as clientes_unicos,
        COUNT(DISTINCT DATE(data_venda)) as dias_com_venda,
        SUM(quantidade) as unidades_vendidas
    FROM vendas
    WHERE data_venda BETWEEN '2024-01-01' AND '2024-12-31'
),
kpi_anterior AS (
    SELECT 
        COUNT(*) as total_vendas_anterior,
        SUM(valor_total) as faturamento_anterior,
        AVG(valor_total) as ticket_medio_anterior,
        COUNT(DISTINCT id_cliente) as clientes_unicos_anterior
    FROM vendas
    WHERE data_venda BETWEEN '2023-01-01' AND '2023-12-31'
)
SELECT 
    'KPIs Principais' as categoria,
    total_vendas,
    ROUND(faturamento_total, 2) as faturamento_total,
    ROUND(ticket_medio, 2) as ticket_medio,
    clientes_unicos,
    ROUND(faturamento_total / dias_com_venda, 2) as media_diaria,
    ROUND(unidades_vendidas * 1.0 / total_vendas, 2) as unidades_por_venda,
    ROUND((total_vendas - total_vendas_anterior) * 100.0 / total_vendas_anterior, 2) as crescimento_vendas_pct,
    ROUND((faturamento_total - faturamento_anterior) * 100.0 / faturamento_anterior, 2) as crescimento_faturamento_pct
FROM kpi_principais, kpi_anterior;

-- 2. Performance por Categoria
SELECT 
    'Performance por Categoria' as categoria,
    categoria_produto,
    COUNT(*) as vendas,
    ROUND(SUM(valor_total), 2) as faturamento,
    ROUND(AVG(valor_total), 2) as ticket_medio,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM vendas WHERE data_venda BETWEEN '2024-01-01' AND '2024-12-31') as share_vendas_pct,
    SUM(valor_total) * 100.0 / (SELECT SUM(valor_total) FROM vendas WHERE data_venda BETWEEN '2024-01-01' AND '2024-12-31') as share_faturamento_pct
FROM vendas
WHERE data_venda BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY categoria_produto
ORDER BY faturamento DESC;

-- 3. Performance por Região
SELECT 
    'Performance por Região' as categoria,
    regiao,
    COUNT(*) as vendas,
    ROUND(SUM(valor_total), 2) as faturamento,
    COUNT(DISTINCT id_cliente) as clientes_ativos,
    ROUND(SUM(valor_total) / COUNT(DISTINCT id_cliente), 2) as valor_por_cliente,
    ROUND(AVG(valor_total), 2) as ticket_medio
FROM vendas
WHERE data_venda BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY regiao
ORDER BY faturamento DESC;

-- 4. Top Performers
-- Top 5 Clientes
SELECT 
    'Top 5 Clientes' as categoria,
    id_cliente,
    nome,
    COUNT(*) as vendas,
    ROUND(SUM(valor_total), 2) as faturamento_total,
    ROUND(AVG(valor_total), 2) as ticket_medio
FROM (
    SELECT 
        v.id_cliente,
        c.nome,
        v.id_venda,
        v.valor_total
    FROM vendas v
    JOIN clientes c ON v.id_cliente = c.id_cliente
    WHERE v.data_venda BETWEEN '2024-01-01' AND '2024-12-31'
) top_clientes
GROUP BY id_cliente, nome
ORDER BY faturamento_total DESC
LIMIT 5;

-- Top 5 Produtos
SELECT 
    'Top 5 Produtos' as categoria,
    id_produto,
    categoria_produto,
    COUNT(*) as frequencia,
    SUM(quantidade) as unidades_total,
    ROUND(SUM(valor_total), 2) as faturamento_total
FROM vendas
WHERE data_venda BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY id_produto, categoria_produto
ORDER BY faturamento_total DESC
LIMIT 5;

-- 5. Métricas de Retenção
WITH cliente_compras AS (
    SELECT 
        id_cliente,
        COUNT(*) as total_compras,
        SUM(valor_total) as valor_total,
        MIN(data_venda) as primeira_compra,
        MAX(data_venda) as ultima_compra,
        CURRENT_DATE - MAX(data_venda) as dias_desde_ultima
    FROM vendas
    WHERE data_venda BETWEEN '2024-01-01' AND '2024-12-31'
    GROUP BY id_cliente
),
segmentos_cliente AS (
    SELECT 
        *,
        CASE 
            WHEN total_compras = 1 THEN 'Nova Compra'
            WHEN total_compras BETWEEN 2 AND 3 THEN 'Regular'
            WHEN total_compras BETWEEN 4 AND 6 THEN 'Frequente'
            ELSE 'VIP'
        END as segmento_frequencia,
        CASE 
            WHEN dias_desde_ultima <= 30 THEN 'Ativo'
            WHEN dias_desde_ultima <= 90 THEN 'Inativo Recente'
            WHEN dias_desde_ultima <= 180 THEN 'Inativo'
            ELSE 'Churn'
        END as status_atividade
    FROM cliente_compras
)
SELECT 
    'Métricas de Retenção' as categoria,
    COUNT(*) as total_clientes,
    SUM(CASE WHEN segmento_frequencia = 'Nova Compra' THEN 1 ELSE 0 END) as novos_clientes,
    SUM(CASE WHEN segmento_frequencia = 'VIP' THEN 1 ELSE 0 END) as clientes_vip,
    SUM(CASE WHEN status_atividade = 'Ativo' THEN 1 ELSE 0 END) as clientes_ativos,
    SUM(CASE WHEN status_atividade = 'Churn' THEN 1 ELSE 0 END) as clientes_churn,
    ROUND(AVG(total_compras), 2) as media_compras_por_cliente,
    ROUND(AVG(valor_total), 2) as valor_medio_por_cliente
FROM segmentos_cliente;
