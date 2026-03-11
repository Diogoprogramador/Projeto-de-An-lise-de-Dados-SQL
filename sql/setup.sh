#!/bin/bash

# Script de Setup Automático - SQL Data Analysis Project
# Uso: ./setup.sh [postgresql|mysql|sqlite]

DB_TYPE=${1:-postgresql}
DB_NAME="vendas_analysis"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"

echo "🚀 Configurando projeto SQL Data Analysis..."
echo "📊 Tipo de banco: $DB_TYPE"

# Verificar se o arquivo de dados existe
if [ ! -f "data/vendas.csv" ]; then
    echo "❌ Arquivo data/vendas.csv não encontrado!"
    exit 1
fi

if [ ! -f "data/clientes.csv" ]; then
    echo "❌ Arquivo data/clientes.csv não encontrado!"
    exit 1
fi

case $DB_TYPE in
    postgresql)
        echo "🔧 Configurando PostgreSQL..."
        
        # Criar banco de dados
        createdb -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME 2>/dev/null || echo "⚠️  Banco já existe ou erro de conexão"
        
        # Executar script de criação
        PGPASSWORD="" psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f scripts/criar_tabelas.sql
        
        echo "✅ PostgreSQL configurado!"
        echo "📋 Para conectar: psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME"
        ;;
        
    mysql)
        echo "🔧 Configurando MySQL..."
        
        # Criar banco de dados
        mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;" 2>/dev/null || echo "⚠️  Erro ao criar banco"
        
        # Executar script de criação
        mysql -h $DB_HOST -P $DB_PORT -u $DB_USER $DB_NAME < scripts/criar_tabelas.sql
        
        echo "✅ MySQL configurado!"
        echo "📋 Para conectar: mysql -h $DB_HOST -P $DB_PORT -u $DB_USER $DB_NAME"
        ;;
        
    sqlite)
        echo "🔧 Configurando SQLite..."
        
        # Executar script de criação
        sqlite3 $DB_NAME.db < scripts/criar_tabelas.sql
        
        echo "✅ SQLite configurado!"
        echo "📋 Para conectar: sqlite3 $DB_NAME.db"
        ;;
        
    *)
        echo "❌ Tipo de banco não suportado: $DB_TYPE"
        echo "📋 Opções: postgresql, mysql, sqlite"
        exit 1
        ;;
esac

echo ""
echo "🎯 Próximos passos:"
echo "1. Execute as análises:"
echo "   - queries/analise_vendas.sql"
echo "   - queries/analise_avancada.sql" 
echo "   - queries/kpi_dashboard.sql"
echo ""
echo "2. Para subir ao GitHub:"
echo "   git remote add origin <seu-repo>"
echo "   git push -u origin main"
echo ""
echo "🚀 Projeto pronto para uso!"
