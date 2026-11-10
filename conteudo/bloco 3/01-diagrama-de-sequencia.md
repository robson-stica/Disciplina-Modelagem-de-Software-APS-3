# Categorias de Diagramas da UML e a Orquestração Dinâmica com o Diagrama de Sequência

## 1. Do "Estatismo das Estruturas" para a "Dinâmica da Execução"
- As classes e atributos modelados anteriormente são plantas baixas inanimadas. Para o software funcionar, os objetos precisam **trocar mensagens ao longo do tempo**.
- Transição da Perspectiva Estática para a **Perspectiva Comportamental / Dinâmica**.

### As Duas Grandes Famílias da UML 2.x:
| Diagramas Estruturais (Visão Estática / "At Rest") | Diagramas Comportamentais (Visão Dinâmica / "In Motion") |
| :--- | :--- |
| **Foco:** Organização lógica e física sem variável tempo. | **Foco:** Comportamento temporal e troca de mensagens. |
| Diagrama de Classes, Diagrama de Objetos, Componentes, Implantação, Pacotes, Estrutura Composta, Perfil. | **Diagrama de Sequência**, Casos de Uso, Atividades, Transição de Estados, Comunicação, Interação Geral, Tempo (*Timing*). |

---

## 2. A Armadilha da "Classe Deus" (*God Class*) e o Acoplamento Temporal
- **Iniciante:** Cria uma tela que chama uma classe monstro síncrona que processa pagamento, atualiza banco, gera PDF e emite nota fiscal tudo na mesma thread bloqueante. Se um serviço externo oscilar por 5 segundos, o sistema inteiro trava.
- **Engenheiro:** No Diagrama de Sequência, identifica onde há chamadas bloqueantes (`->>`) e substitui por **mensageria assíncrona orientada a eventos** (`-)`), desacoplando o tempo de resposta através de brokers como RabbitMQ ou Kafka.

---

## 3. Elementos Gráficos do Diagrama de Sequência
1. **Linha de Vida (*Lifeline*):** Linha vertical tracejada descendente que representa a existência de uma instância/objeto no tempo.
2. **Barra de Ativação (*Focus of Control*):** Retângulo sobre a linha de vida indicando processamento ativo de thread/CPU.
3. **Tipos de Mensagens:**
   - **Síncrona (`->>`):** Chamada bloqueante (o remetente espera a resposta).
   - **Assíncrona (`-)`):** Disparo de evento não bloqueante (*fire-and-forget*).
   - **Retorno (`-->>`):** Devolução explícita de controle/dados (DTO).
4. **Fragmentos Combinados:**
   - `alt`: Condicional mutuamente exclusiva (*if / else*).
   - `opt`: Condicional simples opcional (*if* sem *else*).
   - `loop`: Laço de repetição (*for / while*).
   - `par`: Execução em paralelo concorrente em múltiplas threads.

---

## 4. A Regra de Ouro da Sinergia entre Classes e Sequência
> **"Toda mensagem enviada para uma Linha de Vida B no Diagrama de Sequência DEVE obrigatoriamente corresponder a um Método Público declarado na Classe B no Diagrama de Classes."**

Se a sequência dispara `validarOcorrencia(dto)`, a classe receptora deve possuir `+validarOcorrencia(dto: ValidacaoDTO): RetornoDTO` no diagrama de classes.

