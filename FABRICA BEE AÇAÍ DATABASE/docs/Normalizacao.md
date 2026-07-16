# Normalização do Banco de Dados

## Objetivo

A normalização foi aplicada para reduzir redundâncias, evitar anomalias de inserção, atualização e exclusão e preservar a consistência dos dados utilizados pelo Planejamento e Controle da Produção (PCP).

A estrutura foi analisada até a **Quarta Forma Normal (4FN)**. O documento acadêmico original apresentava explicitamente 1FN, 2FN e 3FN e, em seguida, analisava as dependências multivaloradas. Essa análise das dependências multivaloradas corresponde ao fundamento necessário para verificar a 4FN.

---

## 1. Primeira Forma Normal — 1FN

Uma relação está na 1FN quando:

- todos os atributos possuem valores atômicos;
- não existem listas ou grupos repetidos dentro de uma mesma coluna;
- cada registro pode ser identificado por uma chave;
- conjuntos repetitivos são representados em tabelas próprias.

### Venda e itens

Uma venda pode conter vários produtos. Esses produtos não são armazenados em uma lista dentro de `venda`.

A estrutura utilizada é:

```text
venda 1:N item_venda
```

Cada linha de `item_venda` registra:

- produto;
- lote de origem;
- quantidade;
- valor unitário;
- subtotal.

### Produção e insumos

Uma produção utiliza vários insumos. Os insumos não são armazenados em um campo textual dentro de `producao`.

Cada consumo é registrado em:

```text
insumo_producao
```

### Resultado da 1FN

Os atributos são atômicos e os grupos repetitivos foram separados em tabelas de detalhe ou associação.

---

## 2. Segunda Forma Normal — 2FN

Uma relação está na 2FN quando:

- está na 1FN;
- todos os atributos não-chave dependem da chave primária completa;
- não existem dependências parciais em tabelas com chave composta.

### Tabela `insumo_producao`

A chave primária é composta por:

```text
ID_PRODUCAO + ID_INSUMO
```

Os atributos:

```text
QTD_UTILIZADA
UNIDADE_UTILIZADA
```

dependem da combinação completa.

A quantidade utilizada não representa apenas a produção nem apenas o insumo. Ela representa o consumo de um insumo específico dentro de uma produção específica.

### Tabelas com chave simples

Nas tabelas com chave primária simples, como `usuario`, `producao`, `produto`, `compra` e `venda`, os atributos descritivos dependem diretamente do identificador principal.

### Resultado da 2FN

Não foram identificadas dependências parciais nos relacionamentos principais do modelo.

---

## 3. Terceira Forma Normal — 3FN

Uma relação está na 3FN quando:

- está na 2FN;
- os atributos não-chave dependem somente da chave;
- atributos não-chave não determinam outros atributos não-chave de forma indevida.

### Parceiros comerciais

A tabela `venda` armazena `ID_CLIENTE`, mas não repete:

- nome;
- documento;
- contato;
- endereço;
- município;
- UF.

Esses dados permanecem em `parceiro_cliente`.

O mesmo cadastro é reutilizado nas compras por meio de `ID_FORNECEDOR`.

### Financeiro

A tabela `mov_financeira` armazena os dados comuns da movimentação, como:

- tipo;
- valor;
- data;
- descrição;
- forma de pagamento;
- status.

Os dados específicos de cada operação permanecem nas tabelas:

- `venda`;
- `compra`;
- `compra_embalagem`;
- `pagamento_funcionario`.

Essa separação evita repetir dados específicos de venda, compra ou pagamento na movimentação financeira.

### Produção e produto acabado

`produto` referencia a produção de origem por `ID_PRODUCAO`. Os dados completos do lote permanecem em `producao`, evitando repetição desnecessária.

### Estoque

O cadastro do insumo é mantido em `insumo`, enquanto sua posição operacional é controlada em `estoque_insumo`.

O mesmo princípio é aplicado a:

```text
produto
estoque_produto
```

### Resultado da 3FN

As informações cadastrais, operacionais, financeiras e de estoque foram separadas por responsabilidade, reduzindo dependências transitivas.

---

## 4. Quarta Forma Normal — 4FN

Uma relação está na 4FN quando:

- está na Forma Normal de Boyce-Codd ou, no contexto deste projeto, ao menos na 3FN;
- não possui duas ou mais dependências multivaloradas independentes dentro da mesma tabela;
- fatos independentes e repetitivos são separados em relações próprias.

A 4FN é especialmente importante quando uma entidade pode possuir vários valores independentes de categorias diferentes.

### Produção e insumos

Uma produção pode utilizar vários insumos.

Um insumo pode ser utilizado em várias produções.

Essa dependência multivalorada foi separada em:

```text
producao N:N insumo
        ↓
insumo_producao
```

A tabela associativa registra somente o fato necessário:

```text
produção + insumo + quantidade + unidade
```

### Venda e itens vendidos

Uma venda pode possuir vários itens.

Um produto ou lote pode aparecer em várias vendas.

Essa relação foi separada em:

```text
venda 1:N item_venda
produto 1:N item_venda
producao 1:N item_venda
```

Os itens não ficam misturados no cabeçalho de `venda`.

### Produção, insumos e descartes

Uma produção pode ter vários insumos consumidos e vários registros de descarte.

Esses conjuntos são independentes entre si. Por isso, não foram colocados juntos em uma única tabela de produção.

Foram separados em:

```text
insumo_producao
descarte
```

Isso evita combinações artificiais entre cada insumo consumido e cada perda registrada.

### Parceiro, compras e vendas

Um parceiro pode participar de várias compras e várias vendas.

Compras e vendas são fatos independentes e permanecem em tabelas distintas:

```text
compra
compra_embalagem
venda
```

### Resultado da 4FN

As principais dependências multivaloradas foram decompostas em tabelas próprias. O modelo evita armazenar conjuntos independentes de valores na mesma relação.

---

## 5. Dependências funcionais principais

| Tabela | Dependência funcional principal |
|---|---|
| `usuario` | `ID_USUARIO → dados cadastrais, acesso e recuperação` |
| `parceiro_cliente` | `ID_PARCEIRO → dados cadastrais, contato e dados fiscais` |
| `insumo` | `ID_INSUMO → nome, unidade, mínimo e validade` |
| `estoque_insumo` | `ID_ESTOQUE_INSUMO → insumo, quantidade, mínimo, status e entrada` |
| `embalagem` | `ID_EMBALAGEM → nome, capacidade, estoque, reserva e mínimo` |
| `producao` | `ID_PRODUCAO → lote, produto, quantidade, etapa, datas, usuário e embalagem` |
| `insumo_producao` | `(ID_PRODUCAO, ID_INSUMO) → quantidade e unidade utilizada` |
| `produto` | `ID_PRODUTO → preço, disponibilidade, validade, tributação e produção de origem` |
| `estoque_produto` | `ID_ESTOQUE_PRODUTO → produto, quantidade, mínimo, status e entrada` |
| `descarte` | `ID_DESCARTE → data, quantidade, motivo, tipo, usuário, insumo e produção` |
| `mov_financeira` | `ID_MOV → tipo, valor, data, parceiro, forma de pagamento e documento` |
| `compra` | `ID_COMPRA → fornecedor, insumo, quantidade, valor, validade e movimentação` |
| `compra_embalagem` | `ID_COMPRA_EMBALAGEM → fornecedor, embalagem, quantidade, valor e movimentação` |
| `venda` | `ID_VENDA → cliente, data, quantidade total, valor, usuário e movimentação` |
| `item_venda` | `ID_ITEM_VENDA → venda, produto, produção, quantidade e valores` |
| `pagamento_funcionario` | `ID_PAGAMENTO → competência, valor, data, usuário e movimentação` |
| `emissao_fiscal_config` | `ID_CONFIG → provedor, ambiente, credenciais protegidas e status` |
| `nota_fiscal` | `ID_NOTA → venda, modelo, status, chave, protocolo e respostas técnicas` |

---

## 6. Dependências multivaloradas

### Produção e insumos

```text
ID_PRODUCAO →→ ID_INSUMO
```

Uma produção pode utilizar vários insumos independentemente dos demais fatos da produção.

Solução:

```text
insumo_producao
```

### Venda e itens

```text
ID_VENDA →→ ID_ITEM_VENDA
```

Uma venda possui vários itens.

Solução:

```text
item_venda
```

### Produção e descartes

```text
ID_PRODUCAO →→ ID_DESCARTE
```

Uma produção pode possuir vários registros de perda ou refugo.

Solução:

```text
descarte
```

---

## 7. Integridade e restrições

A normalização é complementada por restrições de integridade:

- `PRIMARY KEY` para identificação única;
- `FOREIGN KEY` para rastreabilidade;
- `UNIQUE` para CPF, e-mail, lote e vínculos 1:1;
- `NOT NULL` para campos obrigatórios;
- `CHECK` para etapas, status, unidades, quantidades e tipos;
- `DEFAULT` para estados iniciais seguros.

---

## 8. Decisão de compatibilidade no estoque de insumos

Existem campos de quantidade em:

```text
insumo.QTD_ESTOQUE
estoque_insumo.QTD_ESTOQUE
```

Do ponto de vista estritamente normalizado, essa duplicação pode causar inconsistência.

Na versão atual:

- `estoque_insumo` é a fonte operacional principal;
- `insumo.QTD_ESTOQUE` foi mantido por compatibilidade com rotinas existentes;
- a aplicação deve sincronizar os dois valores;
- a remoção do campo redundante é uma possível melhoria futura após refatoração completa.

Essa decisão deve ser apresentada como uma compatibilidade técnica documentada, e não como parte ideal do modelo normalizado.

---

## 9. Conclusão

O modelo foi estruturado e analisado até a 4FN.

A separação entre cadastros, produção, consumo de materiais, estoque, vendas, compras, perdas, financeiro e fiscal reduz redundâncias e evita combinações indevidas de fatos independentes.

A estrutura preserva:

- integridade;
- rastreabilidade;
- histórico operacional;
- flexibilidade analítica;
- suporte ao PCP.
