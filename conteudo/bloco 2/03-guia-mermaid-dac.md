# Guia de Referência Rápida — Mermaid.js (Diagrams-as-Code)

- **Documentação Oficial:** [Mermaid.js Getting Started](https://mermaid.ai/open-source/intro/getting-started.html)
- **Repositório GitHub Oficial:** [github.com/mermaid-js/mermaid](https://github.com/mermaid-js/mermaid)

---

## 1. O que é o Mermaid.js?
O **Mermaid.js** é uma ferramenta de código aberto baseada em JavaScript que utiliza definições de texto inspiradas no Markdown para gerar diagramas, gráficos e modelos complexos dinamicamente no navegador ou no GitHub.

No paradigma **Diagrams-as-Code (DaC)**, o Mermaid elimina a necessidade de desenhar imagens manuais, permitindo versionar arquitetura e comportamento de software como código no Git.

---

## 2. Tipos Principais de Diagramas e Palavras-Chave

### A. Diagrama de Sequência (`sequenceDiagram`)
```mermaid
sequenceDiagram
    autonumber
    actor User as Usuário
    participant API as Backend Core
    participant DB as Banco PostgreSQL

    User->>API: POST /login (síncrono)
    API->>DB: findByUsername()
    DB-->>API: Dados do Usuário
    API--)User: Token JWT (retorno assíncrono / evento)
```
- Conectores:
  - `->>` : Chamada síncrona com ponta cheia
  - `-->>`: Resposta pontilhada síncrona
  - `-)`  : Chamada assíncrona (fire-and-forget)
  - `alt / else / end`: Condicionais de execução
  - `loop / end`: Laços de repetição

---

### B. Diagrama de Classes (`classDiagram`)
```mermaid
classDiagram
    direction TB
    class IService {
        <<interface>>
        +executar() void
    }
    class ConcreteService {
        -String config
        +executar() void
    }
    IService <|.. ConcreteService : Realização
```
- Modificadores: `+` público, `-` privado, `#` protegido, `~` pacote.
- Relações: `<|--` Herança, `<|..` Realização, `*--` Composição, `o--` Agregação, `-->` Associação, `..>` Dependência.

---

### C. Diagrama de Transição de Estados (`stateDiagram-v2`)
```mermaid
stateDiagram-v2
    [*] --> Criado : evento / acao()
    Criado --> Processando : iniciar [valido == true]
    
    state Processando {
        entry / ligarTimer()
        do / executarCalculo()
        exit / desligarTimer()
    }
    
    Processando --> Finalizado
    Finalizado --> [*]
```

---

### D. Fluxogramas e Atividades com Raias (`flowchart TD / TB / LR`)
```mermaid
flowchart TD
    subgraph Lane1 ["Raia 1: Usuário"]
        A[Início] --> B[Submeter Pedido]
    end
    subgraph Lane2 ["Raia 2: Sistema"]
        B --> C{Aprovado?}
        C -- "[Sim]" --> D[Concluir]
        C -- "[Não]" --> E[Rejeitar]
    end
```
- Fork e Join: nós intermediários de bifurcação e sincronização para modelar paralelismo.
