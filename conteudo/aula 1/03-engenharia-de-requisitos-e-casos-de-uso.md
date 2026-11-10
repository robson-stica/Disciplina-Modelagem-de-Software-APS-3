# Engenharia de Requisitos e a Construção de Diagramas de Caso de Uso

## 1. Conexão com a Jornada: O Contrato Funcional
- **Objetivo:** Transformar as políticas de domínio em funcionalidades tangíveis para o usuário.
- **Evolução Natural:** No encontro anterior, "enxergamos" regras como a de Overbooking. Hoje, modelamos como o sistema interage com o usuário para executar essa regra.
- **A Ponte de Valor:** Se a modelagem de software é a ponte entre a abstração e o código, o Diagrama de Caso de Uso é o "Contrato de Intenções" que garante que o desenvolvedor construa o que o cliente realmente precisa.
- **Link com o 2º Período:** Revisitamos a importância de evitar o desperdício lógico (JBGE - *Just Barely Good Enough*), focando no que traz maior ROI (Retorno sobre Investimento).

---

## 2. O Ecossistema UML e a Perspectiva Funcional
- **Objetivo:** Situar o aluno no padrão industrial da UML e na classificação correta dos modelos.
- **O Lugar do Caso de Uso na UML:**
  - A UML (*Unified Modeling Language*) é a linguagem padrão universal para especificar, visualizar e documentar artefatos de software.
  - **Classificação:** O Diagrama de Caso de Uso pertence à categoria de **Diagramas Comportamentais (*Behavioral Diagrams*)**.
  - **Por que comportamental?** Porque ele descreve como o sistema se comporta e interage com entidades externas (usuários ou outros sistemas) para entregar valor.
- **A Perspectiva Funcional:**
  - Diagrama de Classes (Estrutural): mostra *"o que o sistema é"*.
  - Diagrama de Caso de Uso (Funcional/Comportamental): mostra *"o que o sistema faz"*.

---

## 3. Construindo o Diagrama de Caso de Uso: Elementos e Regras
- **Objetivo:** Detalhar a sintaxe técnica e as boas práticas de construção (Habilidade H42).

### Componentes Essenciais:
1. **Atores:** Representam papéis (personas ou sistemas externos). O ator não é a pessoa física, mas o papel que desempenha.
2. **Casos de Uso:** Representados por elipses, descrevem tarefas discretas que entregam um resultado perceptível ao ator (Sempre verbos no infinitivo: *"Reservar Máquina"*, *"Consultar Saldo"*).
3. **Fronteira do Sistema (*Subject*):** Retângulo que delimita a responsabilidade do software vs ambiente externo.

### Relacionamentos e Semântica Técnica:
- **Associação:** Linha simples indicando comunicação direta entre ator e caso de uso.
- **`<< include >>`:** Indica que um caso de uso é obrigatoriamente parte de outro (reúso mandatário de funcionalidade).
- **`<< extend >>`:** Indica comportamento opcional ou condicional (extensão de fluxo sob certas regras).
- **Generalização:** Herança de comportamento entre atores ou entre casos de uso.

### Passo a Passo para uma Construção de Sucesso:
1. Identifique os Atores (Quem interage? Quem recebe o dado final?).
2. Determine os Casos de Uso (Qual o objetivo do ator?).
3. Defina as Fronteiras (O que o sistema faz vs o que consome de APIs externas).

---

## 4. Atividade Prática: Model Storming dos 8 Projetos
- **Objetivo:** Aplicar a teoria nos cenários industriais reais definidos para as equipes.
- **Model Storming:** Prática ágil de modelagem JIT (*Just-in-Time*). Debater no quadro/papel as fronteiras antes de documentar.
- **Modernidade (Diagrams-as-Code):** Incentivo ao uso de ferramentas como Mermaid ou PlantUML para versionamento direto no Git.
- **Mapeamento de Habilidades:**
  - **H23:** Desenvolver escopo baseado em requisitos apurados.
  - **H42:** Estruturar artefatos e diagramas que descrevem interações com usuários.
