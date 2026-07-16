# Regras de Negócio

## PCP e produção

1. Cada produção representa um lote único.
2. Todo lote possui usuário responsável.
3. O lote registra produto, tamanho, quantidade, fabricação, validade e etapa.
4. A quantidade do lote deve ser maior que zero.
5. A produção pode utilizar uma embalagem cadastrada.
6. Antes da produção, deve ser verificada a disponibilidade de embalagem.
7. A embalagem pode ser reservada para impedir uso concorrente.
8. A reserva não pode exceder a quantidade física.
9. A baixa definitiva da embalagem deve ocorrer uma única vez.
10. Uma produção pode consumir vários insumos.
11. Um insumo pode participar de várias produções.
12. A baixa de insumo não pode exceder o estoque.
13. As etapas válidas são Preparacao, Batimento, Embalagem, Resfriamento, Liberado e Descartado.
14. Durante o resfriamento, o lote não pode ser vendido.
15. O sistema registra início e fim do resfriamento.
16. A notificação de fim de resfriamento não deve ser duplicada.
17. O produto acabado é vinculado à produção de origem.
18. O lote deve permanecer rastreável após venda ou perda.

## Insumos

1. Todo insumo possui unidade de medida.
2. Unidades válidas: UN, KG, G, L e ML.
3. Quantidades e estoque mínimo não podem ser negativos.
4. Compras aumentam o estoque.
5. Consumo produtivo reduz o estoque.
6. Perdas reduzem o estoque.
7. A posição operacional é controlada por `estoque_insumo`.
8. O campo de quantidade em `insumo` é mantido por compatibilidade e deve permanecer sincronizado.

## Conversão de unidades

1. 1 KG equivale a 1.000 G.
2. 1 L equivale a 1.000 ML.
3. Uma baixa informada em G pode reduzir estoque em KG.
4. Uma baixa informada em ML pode reduzir estoque em L.
5. Unidades incompatíveis devem ser rejeitadas.
6. Itens em UN não devem aceitar conversões fracionárias incompatíveis.

## Embalagens

1. A embalagem é controlada em unidades.
2. Cada cadastro possui nome, capacidade e unidade de capacidade.
3. A quantidade reservada deve estar entre zero e o estoque.
4. O saldo livre é `QTD_ESTOQUE - QTD_RESERVADA`.
5. Compras aumentam o estoque.
6. A produção reserva e posteriormente baixa embalagens.
7. Uma reserva cancelada deve devolver a quantidade ao saldo livre.

## Estoque de produto acabado

1. O produto acabado só fica disponível após liberação.
2. Produto em resfriamento permanece bloqueado.
3. Produto vencido não pode ser vendido.
4. Venda reduz o estoque.
5. Refugo ou descarte reduz o saldo relacionado.
6. Estoque mínimo gera alerta.

## Perdas

1. Tipos válidos: Refugo, Descarte e Perda de Insumo.
2. Refugo exige produção/lote.
3. Descarte de produto exige produção/lote.
4. Perda de insumo exige insumo.
5. Perda de insumo pode existir sem lote.
6. Sem lote, `ID_PRODUCAO` deve ser `NULL`.
7. Toda perda possui data, quantidade, motivo e usuário.
8. A quantidade deve ser positiva.
9. A atualização de estoque e o registro devem ocorrer de forma consistente.

## Compras

1. Compra exige fornecedor.
2. Compra de insumo exige insumo.
3. Compra de embalagem exige embalagem.
4. Quantidade deve ser positiva.
5. Valor não pode ser negativo.
6. A compra atualiza o estoque correspondente.
7. A compra gera saída financeira.
8. Compra, estoque e financeiro devem ser tratados na mesma transação.
9. Nota fiscal e anexo são opcionais.

## Vendas

1. Venda exige cliente e usuário.
2. Uma venda pode ter vários itens.
3. Cada item preserva produto e lote.
4. Só é permitido vender lote liberado.
5. A quantidade não pode exceder o saldo.
6. A venda reduz o estoque.
7. A venda gera entrada financeira.
8. Venda, itens, estoque e financeiro devem ser tratados na mesma transação.
9. Comprovante comercial não substitui nota fiscal.

## Financeiro

1. `TIPO_MOVIMENTACAO` aceita Entrada e Saida.
2. Venda gera Entrada.
3. Compra de insumo gera Saida.
4. Compra de embalagem gera Saida.
5. Pagamento de funcionário gera Saida.
6. `mov_financeira` centraliza os valores.
7. As tabelas operacionais preservam a origem.
8. Resultado = Entradas - Saídas.
9. O mesmo período deve ser aplicado aos indicadores e ao PDF.

## Fiscal

1. A emissão fiscal é opcional.
2. A empresa contrata o provedor diretamente.
3. Credenciais não podem ser publicadas ou armazenadas em texto puro.
4. Homologação deve preceder produção.
5. Salvar credenciais não significa emitir nota.
6. A nota é emitida somente após autorização.
7. NF-e utiliza modelo 55.
8. NFC-e utiliza modelo 65.
9. Status, chave, protocolo e resposta devem ser preservados.

## Usuários e histórico

1. CPF e e-mail são únicos.
2. Perfis: Admin e Colaborador.
3. Usuário desativado não acessa, mas permanece no histórico.
4. Senhas são armazenadas como hash.
5. Tokens de recuperação expiram.
