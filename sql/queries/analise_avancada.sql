-- Análise Avançada de Dados
-- GitHub SQL Data Analysis Project

-- 1. Análise de RFM (Recência, Frequência, Valor)
WITH rfm_analysis AS (
    SELECT 
        c.id_cliente,
        c.nome,
        c.segmento,
        MAX(v.data_venda) as ultima_compra,
        CURRENT_DATE - MAX(v.data_venda) as dias_ultima_compra,
        COUNT(v.id_venda) as frequencia_compras,
        SUM(v.valor_total) as valor_total_compras,
        AVG(v.valor_total) as ticket_medio
    FROM clientes c
    JOIN vendas v ON c.id_cliente = v.id_cliente
    GROUP BY c.id_cliente, c.nome, c.segmento
),
rfm_scores AS (
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY dias_ultima_compra DESC) as recency_score,
        NTILE(5) OVER (ORDER BY frequencia_compras) as frequency_score,
        NTILE(5) OVER (ORDER BY valor_total_compras) as monetary_score
    FROM rfm_analysis
)
SELECT 
    id_cliente,
    nome,
    segmento,
    dias_ultima_compra,
    frequencia_compras,
    valor_total_compras,
    ticket_medio,
    recency_score,
    frequency_score,
    monetary_score,
    (recency_score + frequency_score + monetary_score) as rfm_score_total,
    CASE 
        WHEN (recency_score + frequency_score + monetary_score) >= 13 THEN 'Campeão'
        WHEN (recency_score + frequency_score + monetary_score) >= 10 THEN 'Cliente Leal'
        WHEN (recency_score + frequency_score + monetary_score) >= 7 THEN 'Potencial Leal'
        WHEN (recency_score + frequency_score + monetary_score) >= 5 THEN 'Novo'
        WHEN (recency_score + frequency_score + monetary_score) >= 3 THEN 'Em Risco'
        ELSE 'Perdido'
    END as segmento_rfm
FROM rfm_scores
ORDER BY rfm_score_total DESC;

-- 2. Análise de Cesta de Compras (Market Basket Analysis)
SELECT 
    v1.categoria_produto as categoria_principal,
    v2.categoria_produto as_categoria_secundaria,
    COUNT(*) as frequencia_conjunta,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM vendas), 2) as percentual_total
FROM vendas v1
JOIN vendas v2 ON v1.id_cliente = v2.id_cliente 
    AND v1.id_venda != v2.id_venda 
    AND v1.categoria_produto != v2.categoria_produto
GROUP BY v1.categoria_produto, v2.categoria_produto
HAVING COUNT(*) > 1
ORDER BY frequencia_conjunta DESC;

-- 3. Análise de Cohort por Mês de Primeira Compra
WITH cohorts AS (
    SELECT 
        c.id_cliente,
        DATE_TRUNC('month', MIN(v.data_venda)) as cohort_month,
        DATE_TRUNC('month', v.data_venda) as order_month,
        EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', v.data_venda), DATE_TRUNC('month', MIN(v.data_venda)))) as period_number
    FROM clientes c
    JOIN vendas v ON c.id_cliente = v.id_cliente
    GROUP BY c.id_cliente, DATE_TRUNC('month', v.data_venda)
),
cohort_sizes AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT id_cliente) as cohort_size
    FROM cohorts
    GROUP BY cohort_month
),
cohort_analysis AS (
    SELECT 
        c.cohort_month,
        c.period_number,
        COUNT(DISTINCT c.id_cliente) as active_customers,
        cs.cohort_size
    FROM cohorts c
    JOIN cohort_sizes cs ON c.cohort_month = cs.cohort_month
    GROUP BY c.cohort_month, c.period_number, cs.cohort_size
)
SELECT 
    TO_CHAR(cohort_month, 'YYYY-MM') as cohort,
    period_number,
    active_customers,
    cohort_size,
    ROUND(active_customers * 100.0 / cohort_size, 2) as retention_rate
FROM cohort_analysis
ORDER BY cohort, period_number;

-- 4. Análise de Crescimento (Month-over-Month)
WITH monthly_metrics AS (
    SELECT 
        DATE_TRUNC('month', data_venda) as month,
        COUNT(*) as total_orders,
        SUM(valor_total) as total_revenue,
        COUNT(DISTINCT id_cliente) as unique_customers,
        LAG(SUM(valor_total)) OVER (ORDER BY DATE_TRUNC('month', data_venda)) as prev_revenue,
        LAG(COUNT(DISTINCT id_cliente)) OVER (ORDER BY DATE_TRUNC('month', data_venda)) as prev_customers
    FROM vendas
    GROUP BY DATE_TRUNC('month', data_venda)
)
SELECT 
    TO_CHAR(month, 'YYYY-MM') as mes,
    total_orders,
    ROUND(total_revenue, 2) as faturamento,
    unique_customers,
    ROUND(total_revenue / unique_customers, 2) as revenue_per_customer,
    CASE 
        WHEN prev_revenue IS NULL THEN NULL
        ELSE ROUND((total_revenue - prev_revenue) * 100.0 / prev_revenue, 2)
    END as revenue_growth_pct,
    CASE 
        WHEN prev_customers IS NULL THEN NULL
        ELSE ROUND((unique_customers - prev_customers) * 100.0 / prev_customers, 2)
    END as customer_growth_pct
FROM monthly_metrics
ORDER BY month;

-- 5. Análise de Preços e Elasticidade
SELECT 
    categoria_produto,
    COUNT(*) as quantidade_vendas,
    MIN(valor_unitario) as preco_minimo,
    MAX(valor_unitario) as preco_maximo,
    AVG(valor_unitario) as preco_medio,
    ROUND(STDDEV(valor_unitario), 2) as desvio_padrao_preco,
    SUM(quantidade) as quantidade_total_vendida,
    ROUND(SUM(valor_total), 2) as faturamento_total
FROM vendas
GROUP BY categoria_produto
ORDER BY faturamento_total DESC;
