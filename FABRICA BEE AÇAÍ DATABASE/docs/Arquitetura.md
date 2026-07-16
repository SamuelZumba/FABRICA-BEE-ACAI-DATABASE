# Arquitetura de Dados e Fluxos

## Visão geral

A arquitetura foi organizada para colocar o PCP no centro e conectar os demais domínios ao ciclo de produção.

```text
Interface responsiva
        ↓
Aplicação PHP / regras de negócio
        ↓
Transações e validações
        ↓
Banco MySQL/MariaDB
        ↓
Views e consultas analíticas
        ↓
Dashboard e relatório gerencial
```

## Domínios

### Identidade e acesso

- `usuario`

### Parceiros

- `parceiro_cliente`

### Materiais

- `insumo`
- `estoque_insumo`
- `embalagem`

### PCP

- `producao`
- `insumo_producao`
- `produto`
- `estoque_produto`
- `descarte`

### Compras, vendas e financeiro

- `compra`
- `compra_embalagem`
- `venda`
- `item_venda`
- `pagamento_funcionario`
- `mov_financeira`

### Fiscal

- `emissao_fiscal_config`
- `nota_fiscal`

## Fluxo principal do PCP

```text
1. Verificar materiais
2. Repor insumos/embalagens, quando necessário
3. Abrir lote
4. Reservar embalagem
5. Adicionar e consumir insumos
6. Atualizar etapa produtiva
7. Baixar embalagem
8. Iniciar resfriamento
9. Bloquear venda
10. Liberar produto acabado
11. Disponibilizar em estoque
12. Vender e atualizar financeiro
13. Consolidar indicadores
```

## Fluxo de compra de insumo

```text
Fornecedor
   ↓
Compra
   ├── atualiza insumo
   ├── atualiza estoque_insumo
   └── cria mov_financeira = Saida
```

## Fluxo de compra de embalagem

```text
Fornecedor
   ↓
Compra de embalagem
   ├── atualiza embalagem
   └── cria mov_financeira = Saida
```

## Fluxo de produção

```text
Usuário
   ↓
Produção/lote
   ├── seleciona embalagem
   ├── reserva embalagem
   ├── relaciona insumos
   ├── baixa estoque de insumos
   ├── acompanha etapas
   ├── baixa embalagem
   ├── controla resfriamento
   └── gera produto acabado
```

## Fluxo de venda

```text
Cliente
   ↓
Venda
   ↓
Itens da venda
   ├── identificam produto
   └── preservam lote de origem
   ↓
Baixa de estoque do produto
   ↓
Movimentação financeira = Entrada
   ↓
Nota fiscal opcional
```

## Fluxo de perda

```text
Refugo/descarte de produto
   ├── exige lote
   └── reduz produto/produção

Perda de insumo
   ├── exige insumo
   ├── lote é opcional
   └── reduz estoque do insumo
```

## Camada analítica

Views e consultas fornecem:

- produção por etapa;
- consumo de insumos;
- disponibilidade de embalagens;
- estoque mínimo;
- vencimentos;
- vendas e ticket médio;
- resultado financeiro;
- motivos de perda;
- rastreabilidade de lotes.
