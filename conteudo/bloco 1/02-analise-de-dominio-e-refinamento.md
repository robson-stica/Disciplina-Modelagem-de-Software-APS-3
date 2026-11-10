# Análise de Domínio e Refinamento de Abstrações

## 1. Conexão com a Jornada: Do Código ao Domínio
- **Objetivo:** Linkar o conhecimento de POO com a necessidade de abstração de alto nível.
- No 3º período, vocês aprenderam a criar classes, objetos e métodos em Java/C++. Agora, no 4º período, o desafio não é apenas "como codificar", mas "o que modelar" para resolver problemas reais da indústria.

### O Problema Mais Difícil da Computação
- **Dar nome às coisas:** Por que "Usuário" é um termo vago e perigoso em um sistema real?
- **Ver vs. Enxergar:** No código, vemos atributos; no domínio, enxergamos regras de negócio, impostos e fluxos operacionais.
- **Abstração não é apenas herança:** `Animal -> Cachorro` é um exemplo acadêmico. Na vida real, trabalhamos com abstrações como "Política de Overbooking" ou "Gateway de Pagamento".

---

## 2. Fundamentação: Análise de Domínio e Regras de Negócio
- **Objetivo:** Compreender que o domínio dita a forma do software.
- **O que é o Domínio?** É o "mundo" onde o software opera (ex: Varejo, Saúde, Manufatura).
- **Competência C12:** Analisar modelos para possibilitar sua aplicação no desenvolvimento.
- **Habilidade H39:** Classificar diferentes modelos e suas características.

### Refinando Abstrações: O Exemplo do Overbooking
- **Cenário Simples:** Uma classe `Viagem` que adiciona `Mercadorias`.
- **Regra de Negócio:** A indústria de transporte permite aceitar 10% a mais da capacidade (overbooking) para compensar cancelamentos.
- **Refinamento:** Em vez de um `if` perdido no código, criamos uma abstração chamada `OverbookingPolicy` (Padrão Strategy). Isso separa a Regra da Implementação.

---

## 3. Classificação de Modelos: Do Conceitual ao Físico
- **Objetivo:** Diferenciar as óticas de modelagem conforme a Habilidade H40.

### As Três Camadas de Abstração:
1. **Modelo Conceitual:** Visão de alto nível. O que existe? (Clientes, Pedidos, Produtos). Sem detalhes técnicos, apenas significado de negócio.
2. **Modelo Lógico:** A estrutura detalhada. Atributos, chaves e tipos, independente da tecnologia de banco de dados.
3. **Modelo Físico:** A implementação real. Tabelas, índices e constraints em um banco específico (PostgreSQL, MongoDB).

### Por que abstrair?
Sistemas modernos são complexos demais para serem modelados apenas em nível de código. A modelagem permite que o engenheiro não precise se preocupar com detalhes de plataforma o tempo todo (*Model-Driven Engineering*).

---

## 4. Atividade Prática: Workshop "The Domain Hunt"
- **Objetivo:** Praticar a extração de abstrações de um domínio industrial.
- **O Desafio FabLab da Indústria:**
  - Entrada: *"Precisamos gerenciar o uso das máquinas laser e impressoras 3D pelos alunos"*.
  - Identificar o Concreto: Máquina, Aluno.
  - Identificar o Abstrato/Domínio: Reserva, Crédito de Uso, Manutenção Preventiva, Fila de Prioridade.
  - Nomear tecnicamente refletindo a Regra, não apenas o dado.
- **Dica de Carreira:** *"Sua versão 1.0 de tudo vai ser sempre ruim. A modelagem emerge da experiência e do erro."*

