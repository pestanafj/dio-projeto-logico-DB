```mermaid
erDiagram
    // Entidades
    entity "Produto" as produto {
        +ID (PK)
        --
        Nome
        Descrição
        Preço
    }
    entity "Fornecedor" as fornecedor {
        +ID (PK)
        --
        Nome
        Endereço
        Contato
    }
    entity "Entrada de Estoque" as entradaEstoque {
        +ID (PK)
        Data
        Quantidade
        +Produto_ID (FK)
    }
    entity "Saída de Estoque" as saidaEstoque {
        +ID (PK)
        Data
        Quantidade
        +Produto_ID (FK)
    }

    // Relacionamentos
    produto -- entradaEstoque : "Possui" 
    produto -- saidaEstoque : "Possui"
    fornecedor -- produto : "Fornece"

    // Chaves Primárias e Estrangeiras
    produto {
        +ID
    }
    entradaEstoque {
        +ID
        Produto_ID
    }
    saidaEstoque {
        +ID
        Produto_ID
    }
    fornecedor {
        +ID
    }
```
