# Camada de banco de dados

## Arquivos

### `schema.sql`

Cria a estrutura consolidada do banco, com 18 tabelas, chaves, constraints e relacionamentos.

### `seed.sql`

Insere somente dados fictícios e opcionais.

### `views.sql`

Cria views para consultas recorrentes de PCP, estoque, vendas, financeiro, perdas e rastreabilidade.

### `consultas_analiticas.sql`

Reúne consultas para indicadores, exploração e relatórios.

### `indexes.sql`

Documenta índices adicionais. Revise antes de executar, pois vários já podem existir no `schema.sql`.

### `dicionario_de_dados.md`

Explica a finalidade das tabelas, os campos e os relacionamentos.

## Ordem sugerida

```text
1. schema.sql
2. seed.sql (opcional)
3. views.sql
4. consultas_analiticas.sql
```

## Fonte de verdade

O `schema.sql` é a referência estrutural da versão atual do portfólio. DER, modelo lógico e dicionário devem ser atualizados a partir dele.
