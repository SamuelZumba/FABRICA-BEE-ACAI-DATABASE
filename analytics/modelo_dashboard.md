# Modelo do Dashboard

## Princípio de organização

O painel deve apresentar uma visão rápida do PCP e da operação. Os detalhes completos permanecem nas telas específicas e no relatório PDF.

## Bloco 1 — Resumo executivo

Indicadores principais:

- lotes em andamento;
- lotes em resfriamento;
- quantidade produzida;
- entradas;
- saídas;
- resultado financeiro.

Finalidade: permitir leitura imediata da situação produtiva e financeira.

## Bloco 2 — Produção

### Visual: lotes por etapa

- Tipo sugerido: gráfico de barras ou rosca;
- Fonte: `producao`;
- Pergunta respondida: em qual etapa os lotes estão concentrados?;
- Decisão: identificar gargalos do PCP.

### Visual: produção ao longo do período

- Tipo sugerido: linha ou colunas;
- Fonte: `producao`;
- Pergunta respondida: como o volume produzido evoluiu?;
- Decisão: comparar ritmo produtivo entre períodos.

## Bloco 3 — Estoque

### Visual: composição do estoque

- Insumos;
- produtos acabados;
- embalagens livres.

Finalidade: apresentar uma visão consolidada sem substituir as telas detalhadas.

### Alertas

- insumos abaixo do mínimo;
- produtos abaixo do mínimo;
- produtos próximos do vencimento;
- embalagens com saldo livre insuficiente.

## Bloco 4 — Financeiro

### Visual: entradas e saídas

- Tipo sugerido: colunas agrupadas por período;
- Fonte: `mov_financeira`;
- Decisão: acompanhar equilíbrio financeiro.

### Indicador: resultado

- Fórmula conceitual: entradas menos saídas;
- Evitar comparação percentual quando não existir base anterior válida.

## Bloco 5 — Qualidade

### Visual: perdas por tipo ou motivo

- Fonte: `descarte`;
- Decisão: identificar desperdícios recorrentes;
- Observação: pode ficar no relatório ou em uma visão analítica complementar, sem sobrecarregar o painel principal.

## Filtros

Filtros recomendados:

- hoje;
- últimos 7 dias;
- últimos 30 dias;
- mês atual;
- mês anterior;
- ano atual;
- período personalizado.

