# Diagramas de Atividades e Transição de Estados — Modelagem de Fluxos de Processo e Ciclos de Vida Reativos

## 1. Conexão Pedagógica
Completando a Perspectiva Comportamental:
- **Diagrama de Atividades:** Mapeia *workflows* (fluxos de trabalho), concorrência e paralelismo entre múltiplos atores e sistemas.
- **Diagrama de Transição de Estados (*State Machine*):** Mapeia o ciclo de vida rigoroso de uma entidade individual crítica, protegendo-a contra corrupção lógica de estados.

---

## 2. Diagrama de Atividades UML
Descreve a sequência de passos operacionais, decisões e concorrência de processos.

### Elementos Técnicos:
- **Nó Inicial `(o)` e Nó Final `((o))`:** Pontos de início e parada total.
- **Raias de Partição (*Swimlanes*):** Dividem quem é o responsável (ex.: Ator Humano, Backend, Hardware IoT).
- **Barra de Fork:** Divide um fluxo de entrada em múltiplos ramos executados **em paralelo**.
- **Barra de Join:** Atua como barreira de sincronização — só avança após **todos** os ramos concorrentes terminarem.
- **Nó de Decisão:** Losango com **Condições de Guarda `[expressão booleana]`** mutuamente exclusivas (ex.: `[saldo > 0]` vs `[saldo <= 0]`).

---

## 3. Diagrama de Transição de Estados (*State Machine*)
Descreve os estados discretos pelos quais uma entidade passa ao longo do tempo.

### A Sintaxe Formal Rigorosa de Transição:
$$\text{EventoGatilho} \ [\text{CondiçãoDeGuarda}] \ / \ \text{AçãoDeEfeito}()$$

- **Gatilho (*Trigger*):** O estímulo que dispara a mudança de estado (ex.: `submeterLaudo()`).
- **Guarda (*Guard*):** Condição booleana entre colchetes `[laudoValido == true]`.
- **Ação/Efeito (*Effect*):** Efeito colateral imediato da transição `/ registrarLogAuditoria()`.

### Compartimento de Ações Internas do Estado:
- `entry /`: Ação atômica executada no momento exato em que o objeto **entra** no estado.
- `do /`: Atividade contínua ou duradoura executada enquanto o objeto **permanece** no estado.
- `exit /`: Ação atômica executada no instante em que o objeto **abandona** o estado.

---

## 4. Síntese Comparativa dos 4 Modelos Comportamentais
| Diagrama | Pergunta Chave de Projeto | Foco Primário |
| :--- | :--- | :--- |
| **Casos de Uso** | *O que o sistema entrega para cada ator externo?* | Intenção de negócio e escopo de valor. |
| **Sequência** | *Como as classes e microsserviços trocam chamadas no tempo?* | Troca cronológica de mensagens e DTOs. |
| **Atividades** | *Como o fluxo de ponta a ponta é orquestrado entre áreas?* | Workflows, concorrência (Fork/Join) e raias. |
| **Transição de Estados** | *Quais regras protegem os dados e estados de uma entidade?* | Ciclo de vida, gatilhos, guardas e ações de efeito. |
