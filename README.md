# FABRICA-BEE-ACAI-DATABASEE

# Sistema Fábrica Bee Açaí

## Sobre este repositório

Este repositório apresenta a **camada de dados, a modelagem relacional, as consultas analíticas e a documentação técnica** de um sistema web desenvolvido para apoiar o **Planejamento e Controle da Produção (PCP)** da Fábrica Bee Açaí.

O projeto surgiu a partir de um problema real: com o início da fabricação própria e da expansão para revenda, os controles internos de produção, matérias-primas, embalagens, resfriamento, validade, estoque, perdas e movimentações financeiras não acompanharam o crescimento da operação. A ausência de um PCP estruturado fazia com que informações importantes permanecessem fragmentadas e que decisões fossem tomadas com base em dados incompletos.

A solução foi projetada como um **hub de gestão industrial**, conectando o fluxo produtivo aos módulos de estoque, compras, vendas, financeiro, rastreabilidade, alertas e relatórios gerenciais.

> O código-fonte completo da aplicação não está disponível publicamente, pois o sistema contém regras de negócio específicas e será utilizado em uma operação real. Este repositório reúne somente artefatos técnicos selecionados para portfólio, sem credenciais, documentos fiscais, dados pessoais ou informações comerciais reais.

---

## Problema central: ausência de PCP estruturado

O problema central identificado foi a **falha no Planejamento e Controle da Produção**.

Antes da solução, a empresa não possuía um mecanismo centralizado para:

- planejar e acompanhar lotes de produção;
- controlar a entrada, disponibilidade e consumo de matérias-primas;
- verificar a disponibilidade de embalagens;
- acompanhar as etapas de preparação, batimento, embalagem e resfriamento;
- impedir a venda de lotes ainda não liberados;
- controlar validade, estoque mínimo, refugos e perdas;
- rastrear o histórico completo de cada lote;
- integrar compras, estoque, produção, vendas e financeiro;
- gerar indicadores confiáveis para apoio à decisão.

A consequência era um cenário de **decisões sob incerteza**, com maior risco de desperdício, ruptura de estoque, perda de validade, falhas de rastreabilidade e inconsistências financeiras.

---

## Objetivo da solução

O sistema foi desenvolvido para estruturar o PCP e centralizar as informações da fábrica, permitindo que a gestão acompanhe o ciclo completo do produto:

```text
Necessidade de produção
        ↓
Verificação de insumos e embalagens
        ↓
Compras e entrada em estoque, quando necessário
        ↓
Abertura da ordem/lote de produção
        ↓
Reserva de embalagens
        ↓
Registro e baixa dos insumos consumidos
        ↓
Acompanhamento das etapas produtivas
        ↓
Embalagem e baixa das embalagens reservadas
        ↓
Resfriamento e bloqueio temporário para venda
        ↓
Liberação do produto acabado
        ↓
Estoque disponível para comercialização
        ↓
Venda vinculada ao produto e ao lote
        ↓
Baixa de estoque e entrada financeira
        ↓
Dashboard, rastreabilidade e relatório gerencial
```

Fluxos de exceção, como **refugo, descarte e perda de insumo**, também são registrados e atualizam os respectivos estoques.

---

## Escopo do sistema

### PCP e produção

- abertura de ordens/lotes de produção;
- identificação única por lote;
- registro de produto, tamanho, quantidade, fabricação e validade;
- associação do usuário responsável;
- associação e reserva de embalagem;
- consumo de múltiplos insumos;
- acompanhamento das etapas produtivas;
- controle do tempo de resfriamento;
- bloqueio de produtos durante o resfriamento;
- liberação do produto acabado;
- rastreabilidade completa do lote.

### Materiais e estoque

- cadastro de insumos;
- estoque operacional de insumos;
- cadastro e estoque de embalagens;
- quantidades reservadas e quantidades livres;
- estoque de produtos acabados;
- estoque mínimo;
- alertas de atenção, esgotamento e vencimento;
- entradas por compras;
- baixas por produção, venda e perdas;
- conversão entre KG/G e L/ML.

### Compras

- cadastro unificado de fornecedores e parceiros;
- compra de insumos;
- compra de embalagens;
- vínculo com fornecedor;
- atualização automática do estoque;
- registro da saída financeira;
- número e anexo de nota fiscal, quando disponíveis.

### Vendas

- cadastro de clientes;
- venda com múltiplos itens;
- vínculo entre produto vendido e lote de origem;
- validação da disponibilidade;
- baixa de estoque;
- entrada financeira;
- comprovante comercial sem valor fiscal;
- estrutura para integração fiscal opcional.

### Perdas e qualidade

- refugo de produção;
- descarte de produto acabado;
- perda de insumo;
- registro de quantidade, motivo, data e responsável;
- lote obrigatório para refugo/descarte de produto;
- lote opcional para perda de insumo;
- baixa do estoque correspondente;
- dados para análise de desperdícios.

### Financeiro

- entradas de vendas;
- saídas de compras de insumos;
- saídas de compras de embalagens;
- pagamentos de funcionários;
- histórico de movimentações;
- formas de pagamento e status;
- filtros por período;
- cálculo de entradas, saídas e resultado financeiro.

### Fiscal

- ativação opcional da emissão fiscal;
- conta contratada diretamente pela empresa;
- ambiente de homologação e produção;
- configuração protegida de credenciais;
- controle de NF-e e NFC-e;
- status de processamento, autorização, rejeição e cancelamento;
- armazenamento de chave de acesso, protocolo e respostas técnicas.

### Gestão e apoio à decisão

- painel geral com gráficos e indicadores;
- filtros por período;
- alertas operacionais;
- relatório gerencial em PDF;
- detalhamento de produção, estoque, embalagens, perdas, vendas, compras e pagamentos;
- interface responsiva para computadores e dispositivos móveis.

---

## Relação entre PCP e os demais módulos

O PCP é o eixo central do projeto. Os demais módulos sustentam ou registram consequências do processo produtivo:

```text
                     ┌─────────────────────┐
                     │       PCP /         │
                     │     PRODUÇÃO        │
                     └─────────┬───────────┘
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                    │
          ▼                    ▼                    ▼
   INSUMOS E ESTOQUE      EMBALAGENS        PRODUTO ACABADO
          │                    │                    │
          └────────────────────┴────────────────────┘
                               │
                               ▼
                    RESFRIAMENTO E LIBERAÇÃO
                               │
                               ▼
                       VENDAS E CLIENTES
                               │
                               ▼
                          FINANCEIRO
                               │
                               ▼
              INDICADORES, ALERTAS E RELATÓRIOS
```

Essa integração permite analisar não apenas **quanto foi produzido**, mas também:

- quais materiais foram consumidos;
- quais embalagens foram utilizadas;
- quanto permaneceu em estoque;
- quanto foi vendido;
- quanto foi perdido;
- qual foi o impacto financeiro;
- quem executou cada operação;
- qual foi o caminho de cada lote.

---

## Arquitetura de dados

O banco utiliza MySQL/MariaDB, mecanismo InnoDB e charset `utf8mb4`.

A estrutura atual possui 18 tabelas:

### Cadastros e acesso

1. `usuario`
2. `parceiro_cliente`

### Materiais, estoque e PCP

3. `insumo`
4. `estoque_insumo`
5. `embalagem`
6. `producao`
7. `insumo_producao`
8. `produto`
9. `estoque_produto`
10. `descarte`

### Comercial e financeiro

11. `mov_financeira`
12. `compra`
13. `compra_embalagem`
14. `venda`
15. `item_venda`
16. `pagamento_funcionario`

### Fiscal

17. `emissao_fiscal_config`
18. `nota_fiscal`

---

## Destaques da modelagem

- `insumo_producao` resolve o relacionamento N:N entre produção e insumo;
- `item_venda` permite vários itens por venda e mantém o lote de origem;
- `producao` concentra os principais dados do PCP;
- `produto` representa o resultado acabado de uma produção;
- `estoque_insumo` e `estoque_produto` registram as posições operacionais;
- `embalagem` controla estoque físico, reserva e disponibilidade;
- `mov_financeira` centraliza entradas e saídas;
- `compra`, `compra_embalagem`, `venda` e `pagamento_funcionario` preservam a origem das movimentações;
- `descarte` permite registrar perdas ligadas a insumos ou lotes;
- `nota_fiscal` registra o ciclo de vida do documento fiscal;
- chaves estrangeiras mantêm a rastreabilidade entre usuários, materiais, lotes, vendas e financeiro.

---

## Competências de Dados aplicadas

### Modelagem e banco de dados

- levantamento do problema de negócio;
- tradução de processos em entidades e relacionamentos;
- modelagem conceitual e lógica;
- normalização até a Quarta Forma Normal;
- criação de chaves primárias e estrangeiras;
- relacionamentos 1:1, 1:N e N:N;
- constraints `CHECK`, `UNIQUE`, `NOT NULL` e `DEFAULT`;
- integridade referencial;
- índices para filtros, validade, etapas e datas;
- documentação de dívida técnica e decisões de compatibilidade.

### SQL e análise

- `INNER JOIN` e `LEFT JOIN`;
- agregações com `SUM`, `COUNT`, `AVG`, `MIN` e `MAX`;
- agrupamentos com `GROUP BY`;
- análises condicionais com `CASE`;
- filtros temporais;
- consultas de estoque mínimo;
- indicadores de produção;
- análise financeira;
- análise de vendas;
- análise de perdas;
- rastreabilidade por lote;
- views para simplificar consultas recorrentes.

### Visualização e informação gerencial

- painel com KPIs;
- gráficos de produção, estoque e financeiro;
- filtros por intervalo;
- relatório detalhado em PDF;
- organização de dados operacionais para tomada de decisão.

---

## Indicadores e análises disponíveis

O projeto permite responder perguntas como:

### PCP

- Quantos lotes estão em cada etapa?
- Quanto foi produzido em determinado período?
- Quais lotes continuam em resfriamento?
- Quais produções estão próximas da validade?
- Quais insumos foram consumidos por lote?
- Quantas embalagens estão reservadas para produções em andamento?

### Estoque

- Quais insumos estão abaixo do mínimo?
- Quais produtos estão disponíveis, em resfriamento ou vencidos?
- Qual é o saldo livre de embalagens?
- Quanto precisa ser reposto?

### Comercial

- Quais produtos foram mais vendidos?
- Quais clientes mais compraram?
- Qual é o ticket médio?
- Qual foi o faturamento por período?

### Financeiro

- Qual foi o total de entradas?
- Qual foi o total de saídas?
- Qual foi o resultado líquido?
- Quanto foi gasto com insumos, embalagens e funcionários?

### Qualidade e perdas

- Quais foram os principais motivos de perda?
- Qual produto ou lote apresentou mais refugos?
- Quantas perdas de insumo ocorreram?
- Qual é o saldo teórico entre produção, venda e perda?

---

## Estrutura do repositório

```text
fabrica-bee-acai-data/
│
├── README.md
│
├── database/
│   ├── schema.sql
│   ├── seed.sql
│   ├── views.sql
│   ├── indexes.sql
│   ├── consultas_analiticas.sql
│   ├── dicionario_de_dados.md
│   └── README.md
│
├── docs/
│   ├── arquitetura.md
│   ├── regras-de-negocio.md
│   ├── normalizacao.md
│   ├── der-atualizado.png
│   └── modelo-logico-atualizado.png
│
├── screenshots/
└── dashboard/
```

---

## Conteúdo dos arquivos SQL

### `schema.sql`

Estrutura consolidada para criação do banco do zero, sem depender do histórico de `ALTER TABLE`.

### `seed.sql`

Dados fictícios e opcionais para demonstração.

### `views.sql`

Camada semântica para estoque, PCP, vendas, financeiro, perdas e rastreabilidade.

### `indexes.sql`

Documentação dos índices utilizados para melhorar buscas e relatórios.

### `consultas_analiticas.sql`

Consultas voltadas a indicadores, exploração dos dados e apoio gerencial.

---

## Como reproduzir a camada de dados

1. Instale MySQL ou MariaDB.
2. Execute `database/schema.sql`.
3. Execute `database/seed.sql`, caso deseje dados fictícios.
4. Execute `database/views.sql`.
5. Explore as consultas de `database/consultas_analiticas.sql`.

> Não execute `indexes.sql` sem verificar se os índices já estão presentes em `schema.sql`.

---

## Origem e evolução

O projeto teve origem acadêmica nas disciplinas de Banco de Dados e Engenharia de Software, utilizando um problema real da empresa como base. A primeira entrega documentou o problema de PCP, o escopo, a modelagem, a normalização e as funcionalidades essenciais. Nesta versão pública, o problema e o escopo permanecem resumidos diretamente no README para evitar duplicação desnecessária.

Após essa etapa, o sistema evoluiu com:

- estoque e compra de embalagens;
- reserva de embalagens por lote;
- conversão de unidades;
- perdas de insumo sem lote obrigatório;
- melhorias no módulo financeiro;
- dados fiscais de clientes;
- configuração de emissão fiscal;
- relatório PDF ampliado;
- dashboard com filtros;
- responsividade;
- consolidação final do schema.

---

## Autoria

Projeto desenvolvido inicialmente por:

- Samuel Zumba;
- Heloisa Guedes;
- Lucas Magalhães;
- Arthur Arruda;
- Gustavo Avanso.

Este repositório de portfólio apresenta a evolução técnica da camada de dados e da documentação do projeto.

---

## Confidencialidade

Não estão publicados:

- código-fonte completo da aplicação;
- credenciais;
- Client Secret;
- documentos fiscais;
- anexos;
- dados pessoais reais;
- registros financeiros reais;
- informações comerciais sensíveis.

O objetivo é demonstrar competências em **PCP, modelagem de dados, SQL, banco de dados, análise e BI**, sem expor a solução operacional integral.

## Separação de responsabilidades

- `database/`: estrutura, views, índices e consultas SQL;
- `docs/`: arquitetura, normalização e regras de negócio;
- `analytics/`: indicadores, leitura gerencial e rastreabilidade das métricas;
- `assets/`: imagens e capturas de tela.


## Competências demonstradas

- Modelagem de Banco de Dados Relacional
- Normalização (1FN a 4FN)
- SQL avançado
- Integridade referencial
- Criação de Views para consultas analíticas
- Índices para otimização de consultas
- Rastreabilidade de produção
- Planejamento e Controle da Produção (PCP)
- Controle de estoque
- Modelagem de indicadores gerenciais
- Documentação técnica
