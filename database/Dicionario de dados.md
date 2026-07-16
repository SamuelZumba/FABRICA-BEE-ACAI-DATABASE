# Dicionário de Dados — Gestão Fábrica Bee Açaí

Este documento descreve a camada pública de dados do sistema. A tabela `producao` representa o núcleo do Planejamento e Controle da Produção (PCP) e se relaciona aos materiais consumidos, embalagens, produto acabado, vendas, perdas e usuários responsáveis.


## Convenções

- **PK**: chave primária.
- **FK**: chave estrangeira.
- **UK**: restrição de unicidade.
- **NULL**: campo opcional.
- Tipos `DECIMAL(12,3)` são utilizados em quantidades para preservar precisão.
- Tipos `DECIMAL(12,2)` são utilizados em valores monetários.
- O banco utiliza `utf8mb4` e mecanismo InnoDB.

---

## 1. `usuario`

### Finalidade

Armazena os usuários autorizados a acessar o sistema e preserva a responsabilidade pelas operações realizadas.

### Campos principais

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_USUARIO` | INT UNSIGNED | PK | Identificador do usuário |
| `NOME` | VARCHAR(120) | NOT NULL | Nome completo |
| `CPF` | VARCHAR(14) | UNIQUE | Documento usado no cadastro e autenticação |
| `EMAIL` | VARCHAR(120) | UNIQUE | E-mail do usuário |
| `FOTO_PERFIL` | VARCHAR(255) | NULL | Caminho da imagem |
| `CARGO` | VARCHAR(80) | NULL | Função na empresa |
| `SENHA` | VARCHAR(255) | NOT NULL | Hash da senha |
| `NIVEL_ACESSO` | VARCHAR(20) | CHECK | Admin ou Colaborador |
| `STATUS_USUARIO` | VARCHAR(20) | CHECK | Ativo ou Desativado |
| `TOKEN_RECUP` | VARCHAR(255) | NULL | Token de recuperação |
| `DATA_EXP_TOKEN` | DATETIME | NULL | Expiração do token |
| `TEMA` | VARCHAR(10) | CHECK | light ou dark |
| `DATA_CADASTRO` | DATETIME | DEFAULT | Data do cadastro |

### Relacionamentos

- 1:N com `producao`;
- 1:N com `descarte`;
- 1:N com `mov_financeira`;
- 1:N com `venda`;
- 1:N com `pagamento_funcionario`.

---

## 2. `parceiro_cliente`

### Finalidade

Centraliza clientes, fornecedores ou parceiros que exercem as duas funções.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_PARCEIRO` | INT UNSIGNED | PK | Identificador |
| `NOME` | VARCHAR(120) | NOT NULL | Nome ou razão social |
| `CNPJ` | VARCHAR(18) | UNIQUE/NULL | CNPJ, quando aplicável |
| `CPF_CNPJ` | VARCHAR(18) | NULL | Documento fiscal informado |
| `CONTATO` | VARCHAR(120) | DEFAULT | Telefone ou contato |
| `EMAIL` | VARCHAR(160) | NULL | E-mail |
| `TIPO_PARCEIRO` | VARCHAR(20) | CHECK | Cliente, Fornecedor ou Ambos |
| `STATUS_PARCEIRO` | VARCHAR(20) | CHECK | Ativo ou Desativado |
| `CEP` | VARCHAR(9) | NULL | CEP |
| `LOGRADOURO` | VARCHAR(160) | NULL | Endereço |
| `NUMERO` | VARCHAR(20) | NULL | Número |
| `COMPLEMENTO` | VARCHAR(80) | NULL | Complemento |
| `BAIRRO` | VARCHAR(100) | NULL | Bairro |
| `CODIGO_MUNICIPIO` | VARCHAR(7) | NULL | Código IBGE |
| `MUNICIPIO` | VARCHAR(100) | NULL | Município |
| `UF` | CHAR(2) | CHECK/NULL | Unidade federativa |
| `DATA_CADASTRO` | DATETIME | DEFAULT | Data do cadastro |

### Relacionamentos

- 1:N com `compra`;
- 1:N com `compra_embalagem`;
- 1:N com `venda`;
- 1:N com `mov_financeira`.

---

## 3. `insumo`

### Finalidade

Mantém o cadastro dos materiais consumidos na produção.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_INSUMO` | INT UNSIGNED | PK | Identificador |
| `NOME` | VARCHAR(120) | NOT NULL | Nome do insumo |
| `QTD_ESTOQUE` | DECIMAL(12,3) | >= 0 | Quantidade mantida por compatibilidade operacional |
| `ESTOQUE_MINIMO` | DECIMAL(12,3) | >= 0 | Limite para alerta |
| `UNIDADE_MEDIDA` | VARCHAR(10) | CHECK | UN, KG, G, L ou ML |
| `DATA_VALIDADE` | DATE | NULL | Validade do insumo |

### Observação de modelagem

A posição operacional de estoque é controlada por `estoque_insumo`. O campo `insumo.QTD_ESTOQUE` foi mantido para compatibilidade com rotinas existentes e deve permanecer sincronizado com a tabela de estoque.

---

## 4. `estoque_insumo`

### Finalidade

Controla a posição operacional do estoque de cada insumo.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_ESTOQUE_INSUMO` | INT UNSIGNED | PK | Identificador |
| `ID_INSUMO` | INT UNSIGNED | FK/UNIQUE | Insumo controlado |
| `QTD_ESTOQUE` | DECIMAL(12,3) | >= 0 | Quantidade disponível |
| `ESTOQUE_MINIMO` | DECIMAL(12,3) | >= 0 | Quantidade mínima |
| `STATUS_ESTOQUE` | VARCHAR(20) | CHECK | Disponivel, Atencao, Esgotado ou Vencido |
| `DATA_ENTRADA` | DATE | DEFAULT | Data da entrada |

### Relacionamento

- 1:1 com `insumo`.

---

## 5. `embalagem`

### Finalidade

Cadastra embalagens e controla estoque, reserva e capacidade.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_EMBALAGEM` | INT UNSIGNED | PK | Identificador |
| `NOME` | VARCHAR(100) | NOT NULL | Nome da embalagem |
| `CAPACIDADE` | DECIMAL(12,3) | > 0 | Capacidade |
| `UNIDADE_CAPACIDADE` | VARCHAR(10) | CHECK | Unidade da capacidade |
| `UNIDADE_MEDIDA` | VARCHAR(10) | CHECK | Unidade de estoque, fixada em UN |
| `QTD_ESTOQUE` | DECIMAL(12,3) | >= 0 | Quantidade física |
| `QTD_RESERVADA` | DECIMAL(12,3) | 0 até estoque | Quantidade comprometida |
| `ESTOQUE_MINIMO` | DECIMAL(12,3) | >= 0 | Limite de alerta |

### Relacionamentos

- 1:N com `producao`;
- 1:N com `compra_embalagem`.

---

## 6. `producao`

### Finalidade

Representa um lote fabricado e controla seu ciclo produtivo.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_PRODUCAO` | INT UNSIGNED | PK | Identificador |
| `NOME_PRODUTO` | VARCHAR(120) | NOT NULL | Produto fabricado |
| `TAMANHO` | DECIMAL(12,3) | > 0 | Tamanho unitário |
| `UNIDADE_MEDIDA` | VARCHAR(10) | CHECK | Unidade do produto |
| `LOTE` | VARCHAR(50) | UNIQUE | Código do lote |
| `QTD_NO_LOTE` | DECIMAL(12,3) | > 0 | Quantidade produzida |
| `ETAPA_ATUAL` | VARCHAR(30) | CHECK | Etapa produtiva |
| `TEMPO_RESFRIAMENTO_HORAS` | INT | NULL | Duração do resfriamento |
| `INICIO_RESFRIAMENTO` | DATETIME | NULL | Início |
| `FIM_RESFRIAMENTO` | DATETIME | NULL | Previsão/fim |
| `NOTIFICADO_RESFRIAMENTO` | TINYINT | 0/1 | Controle de notificação |
| `DATA_FABRICACAO` | DATE | NOT NULL | Fabricação |
| `DATA_VALIDADE` | DATE | NULL | Validade |
| `ID_USUARIO` | INT UNSIGNED | FK | Responsável |
| `ID_EMBALAGEM` | INT UNSIGNED | FK/NULL | Embalagem usada |
| `QTD_EMBALAGEM_RESERVADA` | DECIMAL(12,3) | >= 0 | Reserva |
| `EMBALAGEM_BAIXADA` | TINYINT | 0/1 | Confirma baixa |

### Relacionamentos

- N:1 com `usuario`;
- N:1 com `embalagem`;
- N:N com `insumo`, por `insumo_producao`;
- 1:1 com `produto`;
- 1:N com `item_venda`;
- 1:N com `descarte`.

---

## 7. `insumo_producao`

### Finalidade

Resolve o relacionamento N:N entre produção e insumo e registra o consumo.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_PRODUCAO` | INT UNSIGNED | PK/FK | Produção |
| `ID_INSUMO` | INT UNSIGNED | PK/FK | Insumo |
| `QTD_UTILIZADA` | DECIMAL(12,3) | > 0 | Quantidade consumida |
| `UNIDADE_UTILIZADA` | VARCHAR(10) | CHECK | Unidade registrada |

---

## 8. `produto`

### Finalidade

Representa o produto acabado originado de uma produção e contém dados comerciais e tributários.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_PRODUTO` | INT UNSIGNED | PK | Identificador |
| `PRECO` | DECIMAL(12,2) | >= 0 | Preço |
| `LOTE_DISPONIVEL` | VARCHAR(50) | NOT NULL | Lote |
| `QTD_DISPONIVEL` | DECIMAL(12,3) | >= 0 | Quantidade |
| `ESTOQUE_MINIMO` | DECIMAL(12,3) | >= 0 | Mínimo |
| `DATA_VALIDADE` | DATE | NOT NULL | Validade |
| `ID_PRODUCAO` | INT UNSIGNED | FK/UNIQUE | Produção de origem |
| `NCM` | VARCHAR(8) | NULL | NCM |
| `CFOP` | VARCHAR(4) | NULL | CFOP |
| `ORIGEM_MERCADORIA` | CHAR(1) | CHECK | Código de origem |
| `CSOSN` | VARCHAR(4) | NULL | CSOSN |
| `CST_ICMS` | VARCHAR(3) | NULL | CST ICMS |
| `CEST` | VARCHAR(7) | NULL | CEST |
| `UNIDADE_TRIBUTAVEL` | VARCHAR(6) | DEFAULT | Unidade fiscal |
| `ALIQUOTA_ICMS` | DECIMAL(7,4) | >= 0 | Alíquota |
| `ALIQUOTA_PIS` | DECIMAL(7,4) | >= 0 | Alíquota |
| `ALIQUOTA_COFINS` | DECIMAL(7,4) | >= 0 | Alíquota |

---

## 9. `estoque_produto`

### Finalidade

Controla a posição de estoque do produto acabado.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_ESTOQUE_PRODUTO` | INT UNSIGNED | PK | Identificador |
| `ID_PRODUTO` | INT UNSIGNED | FK/UNIQUE | Produto |
| `QTD_DISPONIVEL` | DECIMAL(12,3) | >= 0 | Quantidade |
| `ESTOQUE_MINIMO` | DECIMAL(12,3) | >= 0 | Mínimo |
| `STATUS_ESTOQUE` | VARCHAR(20) | CHECK | Situação |
| `DATA_ENTRADA` | DATE | DEFAULT | Entrada |

---

## 10. `descarte`

### Finalidade

Registra refugos, descartes e perdas de insumos.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_DESCARTE` | INT UNSIGNED | PK | Identificador |
| `DATA` | DATE | NOT NULL | Data |
| `QUANTIDADE` | DECIMAL(12,3) | > 0 | Quantidade |
| `MOTIVO` | VARCHAR(255) | NOT NULL | Motivo |
| `TIPO_PERDA` | VARCHAR(30) | CHECK | Refugo, Descarte ou Perda de Insumo |
| `ID_USUARIO` | INT UNSIGNED | FK | Responsável |
| `ID_INSUMO` | INT UNSIGNED | FK/NULL | Insumo |
| `ID_PRODUCAO` | INT UNSIGNED | FK/NULL | Produção/lote |

---

## 11. `mov_financeira`

### Finalidade

Centraliza entradas e saídas financeiras.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_MOV` | INT UNSIGNED | PK | Identificador |
| `TIPO_MOVIMENTACAO` | VARCHAR(20) | CHECK | Entrada ou Saida |
| `VALOR` | DECIMAL(12,2) | >= 0 | Valor |
| `DATA` | DATE | NOT NULL | Data |
| `DESCRICAO` | TEXT | NULL | Descrição |
| `STATUS` | VARCHAR(30) | NULL | Status |
| `FORMA_PAGAMENTO` | VARCHAR(50) | NULL | Meio de pagamento |
| `ID_PARCEIRO_FK` | INT UNSIGNED | FK/NULL | Parceiro |
| `ID_USUARIO` | INT UNSIGNED | FK/NULL | Usuário |
| `QUANTIDADE` | DECIMAL(12,3) | >= 0/NULL | Quantidade relacionada |
| `TIPO_NOTA_FISCAL` | VARCHAR(30) | NULL | Tipo fiscal |
| `NUMERO_NOTA_FISCAL` | VARCHAR(50) | NULL | Número |
| `ANEXO_NOTA_FISCAL` | VARCHAR(255) | NULL | Arquivo |
| `OBSERVACAO` | TEXT | NULL | Observações |

---

## 12. `compra`

### Finalidade

Registra compras de insumos e as relaciona com fornecedor, estoque e financeiro.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_COMPRA` | INT UNSIGNED | PK | Identificador |
| `DATA_COMPRA` | DATE | NOT NULL | Data |
| `DATA_VALIDADE` | DATE | NULL | Validade adquirida |
| `QUANTIDADE` | DECIMAL(12,3) | > 0 | Quantidade |
| `VALOR_TOTAL` | DECIMAL(12,2) | >= 0 | Valor |
| `NUM_NOTA_FISCAL` | VARCHAR(50) | NULL | Nota |
| `ANEXO_NOTA` | VARCHAR(255) | NULL | Anexo |
| `ID_FORNECEDOR` | INT UNSIGNED | FK | Fornecedor |
| `ID_INSUMO` | INT UNSIGNED | FK | Insumo |
| `ID_MOV` | INT UNSIGNED | FK | Movimentação |

---

## 13. `compra_embalagem`

### Finalidade

Registra compras de embalagens.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_COMPRA_EMBALAGEM` | INT UNSIGNED | PK | Identificador |
| `DATA_COMPRA` | DATE | NOT NULL | Data |
| `QUANTIDADE` | DECIMAL(12,3) | > 0 | Quantidade |
| `VALOR_TOTAL` | DECIMAL(12,2) | >= 0 | Valor |
| `NUM_NOTA_FISCAL` | VARCHAR(50) | NULL | Nota |
| `ANEXO_NOTA` | VARCHAR(255) | NULL | Anexo |
| `ID_FORNECEDOR` | INT UNSIGNED | FK | Fornecedor |
| `ID_EMBALAGEM` | INT UNSIGNED | FK | Embalagem |
| `ID_MOV` | INT UNSIGNED | FK | Movimentação |

---

## 14. `venda`

### Finalidade

Armazena o cabeçalho da venda e seu vínculo com cliente, usuário e financeiro.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_VENDA` | INT UNSIGNED | PK | Identificador |
| `DATA_VENDA` | DATE | NOT NULL | Data |
| `QUANTIDADE` | DECIMAL(12,3) | >= 0 | Quantidade total |
| `VALOR_TOTAL` | DECIMAL(12,2) | >= 0 | Valor |
| `FORMA_PAGAMENTO` | VARCHAR(50) | NULL | Forma |
| `STATUS` | VARCHAR(30) | NULL | Status |
| `TIPO_NOTA_FISCAL` | VARCHAR(30) | NULL | Tipo |
| `NUM_NOTA_FISCAL` | VARCHAR(50) | NULL | Número |
| `ANEXO_NOTA` | VARCHAR(255) | NULL | Arquivo |
| `ID_USUARIO` | INT UNSIGNED | FK | Responsável |
| `ID_CLIENTE` | INT UNSIGNED | FK | Cliente |
| `ID_MOV` | INT UNSIGNED | FK | Movimentação |

---

## 15. `item_venda`

### Finalidade

Detalha os produtos e lotes incluídos em cada venda.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_ITEM_VENDA` | INT UNSIGNED | PK | Identificador |
| `QUANTIDADE` | DECIMAL(12,3) | > 0 | Quantidade |
| `VALOR_UNITARIO` | DECIMAL(12,2) | >= 0 | Valor unitário |
| `VALOR_TOTAL_ITEM` | DECIMAL(12,2) | >= 0 | Subtotal |
| `ID_VENDA` | INT UNSIGNED | FK | Venda |
| `ID_PRODUTO` | INT UNSIGNED | FK | Produto |
| `ID_PRODUCAO` | INT UNSIGNED | FK | Lote de origem |

---

## 16. `pagamento_funcionario`

### Finalidade

Registra pagamentos e comprovantes relacionados a funcionários.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_PAGAMENTO` | INT UNSIGNED | PK | Identificador |
| `MES_REFERENCIA` | VARCHAR(7) | NOT NULL | Competência |
| `VALOR_PAGO` | DECIMAL(12,2) | >= 0 | Valor |
| `DATA_PAGAMENTO` | DATE | NOT NULL | Data |
| `DESCRICAO` | TEXT | NULL | Descrição |
| `COMPROVANTE` | VARCHAR(255) | NULL | Arquivo |
| `ID_USUARIO` | INT UNSIGNED | FK | Funcionário/usuário |
| `ID_MOV` | INT UNSIGNED | FK | Movimentação |

---

## 17. `emissao_fiscal_config`

### Finalidade

Mantém a configuração opcional da integração fiscal.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_CONFIG` | INT UNSIGNED | PK | Identificador |
| `PROVEDOR` | VARCHAR(60) | DEFAULT | Provedor |
| `STATUS_CONFIG` | VARCHAR(40) | DEFAULT | Situação |
| `AMBIENTE` | VARCHAR(20) | CHECK | Homologacao ou Producao |
| `CLIENT_ID` | VARCHAR(255) | NULL | Identificador técnico |
| `CLIENT_SECRET_CRIPT` | LONGTEXT | NULL | Segredo criptografado |
| `CNPJ` | VARCHAR(14) | NULL | CNPJ da empresa |
| `ESCOPO` | VARCHAR(160) | DEFAULT | Escopos |
| `ULTIMO_TESTE` | DATETIME | NULL | Último teste |
| `ULTIMO_ERRO` | TEXT | NULL | Último erro |
| `DATA_ATUALIZACAO` | DATETIME | NULL | Atualização |

---

## 18. `nota_fiscal`

### Finalidade

Controla o ciclo de vida da NF-e ou NFC-e vinculada a uma venda.

| Campo | Tipo | Regra | Descrição |
|---|---|---|---|
| `ID_NOTA` | INT UNSIGNED | PK | Identificador |
| `ID_VENDA` | INT UNSIGNED | FK | Venda |
| `MODELO` | VARCHAR(4) | CHECK | 55 ou 65 |
| `STATUS_NOTA` | VARCHAR(30) | CHECK | Estado do documento |
| `ID_PROVEDOR` | VARCHAR(100) | NULL | Identificador externo |
| `NUMERO` | VARCHAR(30) | NULL | Número |
| `SERIE` | VARCHAR(10) | NULL | Série |
| `CHAVE_ACESSO` | VARCHAR(60) | UNIQUE/NULL | Chave |
| `PROTOCOLO` | VARCHAR(80) | NULL | Protocolo |
| `MOTIVO_STATUS` | TEXT | NULL | Retorno fiscal |
| `PAYLOAD_JSON` | LONGTEXT | NULL | Requisição |
| `RESPOSTA_JSON` | LONGTEXT | NULL | Resposta |
| `DATA_EMISSAO` | DATETIME | NULL | Emissão |
| `DATA_ATUALIZACAO` | DATETIME | DEFAULT | Atualização |
