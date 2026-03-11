# 📊 Projeto de Análise de Dados SQL

Projeto completo de análise de dados em SQL com foco em vendas e comportamento de clientes, desenvolvido com dedicação por Diogo.

## 📁 Estrutura do Projeto

```
sql/
├── data/                   # Dados de exemplo
│   ├── vendas.csv         # Dados de vendas
│   └── clientes.csv       # Dados de clientes
├── scripts/               # Scripts de configuração
│   └── criar_tabelas.sql  # Criação das tabelas
├── queries/               # Consultas SQL
│   ├── analise_vendas.sql      # Análise básica de vendas
│   ├── analise_avancada.sql    # Análises avançadas (RFM, Cohort, etc.)
│   └── kpi_dashboard.sql       # Dashboard de KPIs
├── results/              # Resultados das consultas
└── README.md            # Este arquivo
```

## 🚀 Como Usar

### 1. Configurar o Banco de Dados

```bash
# PostgreSQL
psql -U seu_usuario -d seu_banco -f scripts/criar_tabelas.sql

# MySQL
mysql -u seu_usuario -p seu_banco < scripts/criar_tabelas.sql

# SQLite
sqlite3 seu_banco.db < scripts/criar_tabelas.sql
```

### 2. Executar as Análises

```bash
# Análise básica de vendas
psql -U seu_usuario -d seu_banco -f queries/analise_vendas.sql

# Análises avançadas
psql -U seu_usuario -d seu_banco -f queries/analise_avancada.sql

# Dashboard de KPIs
psql -U seu_usuario -d seu_banco -f queries/kpi_dashboard.sql
```

## 📋 Análises Disponíveis

### 📈 Análise de Vendas (`analise_vendas.sql`)
- Visão geral das vendas
- Vendas por categoria de produto
- Vendas por região
- Top 10 clientes por faturamento
- Análise temporal (vendas por mês)
- Análise por segmento de clientes
- Produtos mais vendidos
- Análise de sazonalidade

### 🔬 Análises Avançadas (`analise_avancada.sql`)
- **Análise RFM**: Recência, Frequência e Valor
- **Market Basket Analysis**: Análise de cesta de compras
- **Análise de Cohort**: Retenção por cohort
- **Análise de Crescimento**: Month-over-Month
- **Análise de Preços**: Elasticidade e distribuição

### 📊 KPI Dashboard (`kpi_dashboard.sql`)
- KPIs principais com comparação ano anterior
- Performance por categoria
- Performance por região
- Top performers (clientes e produtos)
- Métricas de retenção e churn

## 🗄️ Estrutura dos Dados

### Tabela `clientes`
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| id_cliente | INTEGER | ID único do cliente |
| nome | VARCHAR(100) | Nome do cliente |
| email | VARCHAR(100) | Email único |
| cidade | VARCHAR(50) | Cidade |
| estado | VARCHAR(2) | Estado (sigla) |
| data_cadastro | DATE | Data de cadastro |
| segmento | VARCHAR(20) | Segmento (Standard/Premium) |

### Tabela `vendas`
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| id_venda | INTEGER | ID único da venda |
| data_venda | DATE | Data da venda |
| id_cliente | INTEGER | ID do cliente (FK) |
| id_produto | INTEGER | ID do produto |
| quantidade | INTEGER | Quantidade vendida |
| valor_unitario | DECIMAL(10,2) | Preço unitário |
| valor_total | DECIMAL(10,2) | Valor total da venda |
| categoria_produto | VARCHAR(50) | Categoria do produto |
| regiao | VARCHAR(20) | Região da venda |

## 🛠️ Tecnologias

- **SQL**: PostgreSQL/MySQL/SQLite compatível
- **Dados**: CSV formatados
- **Análises**: Window functions, CTEs, joins avançados

## 📝 Exemplos de Consultas

### Top 3 Clientes por Faturamento
```sql
SELECT 
    c.nome,
    COUNT(v.id_venda) as quantidade_vendas,
    SUM(v.valor_total) as faturamento_total
FROM clientes c
JOIN vendas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY faturamento_total DESC
LIMIT 3;
```

### Análise de Sazonalidade
```sql
SELECT 
    EXTRACT(MONTH FROM data_venda) as mes,
    SUM(valor_total) as faturamento_mensal
FROM vendas
GROUP BY EXTRACT(MONTH FROM data_venda)
ORDER BY mes;
```

## 🎯 Insights Possíveis

1. **Identificação dos melhores clientes** para programas de fidelidade
2. **Análise de performance por categoria** para otimização de estoque
3. **Padrões de compra sazonais** para planejamento de marketing
4. **Segmentação RFM** para campanhas personalizadas
5. **Análise de retenção** para reduzir churn

## 🤝 Contribuições

Sinta-se à vontade para:
- Adicionar novas consultas SQL
- Melhorar as análises existentes
- Adicionar mais dados de exemplo
- Sugerir novos KPIs

**Este projeto foi criado e mantido com ❤️ por Diogo**

## 📄 Licença

MIT License - Sinta-se livre para usar este projeto em seus próprios projetos de análise de dados.

---

**Autor**: Diogo  
**Data**: 2026 
**Versão**: 1.0

**Feito com dedicação por Diogo** 💙  
*Projeto de análise de dados SQL desenvolvido com carinho e atenção aos detalhes*
