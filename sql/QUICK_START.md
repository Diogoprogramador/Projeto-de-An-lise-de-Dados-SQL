# 🚀 Quick Start Guide

## Setup Automático (Recomendado)

```bash
# PostgreSQL (padrão)
./setup.sh

# MySQL  
./setup.sh mysql

# SQLite
./setup.sh sqlite
```

## Setup Manual

### 1. PostgreSQL
```bash
# Criar banco
createdb vendas_analysis

# Setup
psql -d vendas_analysis -f scripts/criar_tabelas.sql
```

### 2. MySQL
```bash
# Criar banco
mysql -e "CREATE DATABASE vendas_analysis;"

# Setup
mysql vendas_analysis < scripts/criar_tabelas.sql
```

### 3. SQLite
```bash
# Setup
sqlite3 vendas_analysis.db < scripts/criar_tabelas.sql
```

## Executar Análises

```bash
# Análise básica
psql vendas_analysis -f queries/analise_vendas.sql

# Análises avançadas
psql vendas_analysis -f queries/analise_avancada.sql

# Dashboard KPI
psql vendas_analysis -f queries/kpi_dashboard.sql
```

## Subir para GitHub

```bash
git remote add origin https://github.com/usuario/sql-data-analysis.git
git push -u origin main
```

## 📊 Estrutura dos Dados

- **20 clientes** com informações demográficas
- **20 vendas** com dados transacionais
- **Categorias**: Eletrônicos, Roupas, Livros, Alimentos
- **Regiões**: Sudeste, Sul, Nordeste, Norte

## 🎯 Insights Principais

1. **Top clientes** por faturamento
2. **Performance** por categoria/região  
3. **Sazonalidade** das vendas
4. **Segmentação RFM** de clientes
5. **Taxa de retenção** por cohort

Pronto para análise! 📈
