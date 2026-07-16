# Data Lineage dos Indicadores

Este documento mostra a origem dos dados utilizados na camada analítica.

| Indicador/visual | Tabelas de origem | Campos principais | Transformação |
|---|---|---|---|
| Lotes por etapa | `producao` | `ETAPA_ATUAL`, `ID_PRODUCAO` | Contagem por etapa |
| Quantidade produzida | `producao` | `QTD_NO_LOTE`, `DATA_FABRICACAO` | Soma por período |
| Lotes em resfriamento | `producao` | `ETAPA_ATUAL`, `FIM_RESFRIAMENTO` | Filtro e cálculo de tempo |
| Consumo de insumos | `insumo_producao`, `insumo`, `producao` | quantidade, unidade, lote | Join e agregação |
| Insumos abaixo do mínimo | `estoque_insumo`, `insumo` | estoque, mínimo, unidade | Comparação e cálculo de reposição |
| Embalagens livres | `embalagem` | estoque, reservado | Subtração |
| Produtos próximos do vencimento | `produto`, `producao`, `estoque_produto` | validade, lote, quantidade | Diferença de datas e filtro |
| Produtos mais vendidos | `item_venda`, `producao` | quantidade, valor, produto | Soma por produto |
| Faturamento por cliente | `venda`, `parceiro_cliente` | valor total, cliente | Soma por cliente |
| Entradas e saídas | `mov_financeira` | tipo, valor, data | Agregação condicional |
| Resultado financeiro | `mov_financeira` | tipo, valor | Entradas menos saídas |
| Perdas por motivo | `descarte` | tipo, motivo, quantidade | Agrupamento e soma |
| Saldo teórico por lote | `producao`, `item_venda`, `descarte` | produzido, vendido, perdido | Produzido menos vendido menos perdido |
| Rastreabilidade | `producao`, `insumo_producao`, `insumo`, `item_venda`, `venda`, `descarte`, `usuario` | chaves e dados operacionais | Integração por chaves estrangeiras |

## Fluxo simplificado

```text
Registros operacionais
        ↓
Tabelas relacionais
        ↓
Views e consultas em database/
        ↓
KPIs documentados em analytics/
        ↓
Painel e relatório gerencial
```
