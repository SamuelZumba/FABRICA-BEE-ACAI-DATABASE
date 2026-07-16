# Catálogo de KPIs

## PCP e produção

| KPI | Finalidade | Regra resumida | Fonte principal | Decisão apoiada |
|---|---|---|---|---|
| Lotes em andamento | Acompanhar o fluxo produtivo | Produções ainda não liberadas nem descartadas | `producao` | Identificar carga operacional |
| Lotes por etapa | Detectar concentração e gargalos | Contagem agrupada por `ETAPA_ATUAL` | `producao` | Priorizar etapas com acúmulo |
| Lotes em resfriamento | Controlar bloqueio e liberação | `ETAPA_ATUAL = 'Resfriamento'` | `producao` | Planejar disponibilidade para venda |
| Quantidade produzida | Medir volume produtivo | Soma de `QTD_NO_LOTE` no período | `producao` | Comparar capacidade e demanda |
| Tempo restante de resfriamento | Acompanhar conclusão dos lotes | Diferença entre `FIM_RESFRIAMENTO` e horário atual | `producao` | Organizar liberação e expedição |

## Estoque e suprimentos

| KPI | Finalidade | Regra resumida | Fonte principal | Decisão apoiada |
|---|---|---|---|---|
| Insumos abaixo do mínimo | Antecipar reposição | Estoque atual menor ou igual ao mínimo | `estoque_insumo` | Planejar compras |
| Produtos abaixo do mínimo | Evitar ruptura comercial | Disponível menor ou igual ao mínimo | `estoque_produto` | Ajustar produção |
| Embalagens livres | Medir capacidade disponível | Estoque físico menos quantidade reservada | `embalagem` | Autorizar novos lotes |
| Produtos próximos do vencimento | Reduzir perdas | Validade dentro da janela definida | `produto`, `producao` | Priorizar venda ou descarte preventivo |
| Necessidade de reposição | Quantificar compra sugerida | Mínimo menos estoque atual, limitado a zero | `estoque_insumo` | Dimensionar pedido ao fornecedor |

## Comercial e financeiro

| KPI | Finalidade | Regra resumida | Fonte principal | Decisão apoiada |
|---|---|---|---|---|
| Faturamento | Medir receita de vendas | Soma do valor total das vendas | `venda` | Avaliar desempenho comercial |
| Entradas financeiras | Consolidar receitas | Soma das movimentações de entrada | `mov_financeira` | Acompanhar caixa operacional |
| Saídas financeiras | Consolidar despesas | Soma das movimentações de saída | `mov_financeira` | Controlar custos |
| Resultado financeiro | Medir saldo operacional | Entradas menos saídas | `mov_financeira` | Avaliar sustentabilidade financeira |
| Ticket médio | Medir valor médio por venda | Faturamento dividido pelo número de vendas | `venda` | Apoiar estratégia comercial |
| Produtos mais vendidos | Identificar demanda | Soma da quantidade por produto | `item_venda`, `producao` | Planejar produção |
| Clientes com maior faturamento | Identificar relevância comercial | Soma das vendas por cliente | `venda`, `parceiro_cliente` | Priorizar relacionamento |

## Qualidade e rastreabilidade

| KPI | Finalidade | Regra resumida | Fonte principal | Decisão apoiada |
|---|---|---|---|---|
| Perdas por tipo | Medir desperdício | Soma das quantidades por tipo de perda | `descarte` | Atuar em qualidade |
| Perdas por motivo | Identificar causas recorrentes | Soma e contagem agrupadas por motivo | `descarte` | Criar ação corretiva |
| Saldo teórico do lote | Comparar produção, venda e perda | Produzido menos vendido menos perdido | `producao`, `item_venda`, `descarte` | Conferir consistência operacional |
| Rastreabilidade do lote | Consolidar histórico | Produção, insumos, vendas e perdas vinculadas | várias tabelas | Auditoria e controle de qualidade |

## Observação

As consultas SQL correspondentes permanecem em `database/consultas_analiticas.sql`. Este catálogo descreve o significado gerencial, não a implementação técnica.
