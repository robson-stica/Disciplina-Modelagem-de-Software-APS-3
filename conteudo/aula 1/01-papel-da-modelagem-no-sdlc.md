# O Papel da Modelagem no SDLC (Software Development Life Cycle)

## 1. Boas-vindas e Contrato Pedagógico
- **Objetivo:** Alinhar expectativas, cronograma e sistema de avaliação.
- **Competências e Habilidades:**
  - **C12:** Analisar e criar modelos relacionados ao desenvolvimento de software.
  - **H40:** Diferenciar, sob diferentes óticas, modelos de sistemas de software construídos.
- **Link com o 2º Período:** Revisitaremos os fundamentos da Engenharia de Software para entender como a modelagem evita falhas que custam caro no futuro.

### Sistema de Avaliação
- **APS (Projetos):** 20%
- **Atividades Individuais:** 40% (Incluindo a nota individual da apresentação no seminário).
- **Atividades em Equipe:** 10% (Trabalho escrito consolidado).
- **Avaliações (Provas):** 20%
- **Apresentações/Seminários:** 5%
- **Documentos Técnico-Científicos:** 5%

---

## 2. Momento Motivacional: Ver X Enxergar
- **Objetivo:** Provocar a reflexão sobre a necessidade de abstração técnica.
- **Modelagem não é apenas desenho:**
  - O problema: 75% dos sistemas falham não por código ruim, mas por falhas de concepção e comunicação.
  - Filosofia Técnica: Modelar é representar o mundo real de forma abstrata.
  - Vocabulário Comum: A modelagem nos dá as palavras (classes, estados, fluxos) para que desenvolvedores e stakeholders falem a mesma língua.
- **Dinâmica "O Telefone Sem Fio do Requisito":** Como um requisito mal modelado no início do SDLC se torna um monstro no final do ciclo.

---

## 3. Fundamentação Teórica: Modelagem e o SDLC
- **Objetivo:** Situar a modelagem dentro das 7 fases do ciclo de vida de software.

### As 7 Fases do SDLC e a Modelagem:
1. **Planejamento:** Definir escopo e viabilidade.
2. **Análise:** Onde a modelagem de requisitos brilha (Diagramas de Caso de Uso).
3. **Design (Desenho):** Criação da arquitetura lógica e física (Diagramas de Classes e C4).
4. **Desenvolvimento (Codificação):** O modelo serve como a "planta baixa" para o código.
5. **Testes:** Verificação se o construído condiz com o modelado.
6. **Implantação:** Colocação em produção.
7. **Manutenção:** Modelos atualizados facilitam a evolução do software sem "drift" arquitetural.

### Modelagem Tradicional (Waterfall) X Ágil:
- **Waterfall:** Modelagem exaustiva e rígida antes do código.
- **Agile:** Modelagem iterativa, incremental e "apenas o suficiente" (JBGE - *Just Barely Good Enough*).
- **Modernidade:** Em 2026, usamos **Diagrams-as-Code (Mermaid/PlantUML)** para que o modelo viva dentro do repositório Git.

---

## 4. Atividade Prática e Interativa
- **Objetivo:** Aplicar o conceito de "Zoom" do Modelo C4 para entender contextos.
- **Workshop Relâmpago: Contexto do Sistema**
  - Desafio: Em grupos, escolham um app comum (ex: Uber, iFood).
  - Tarefa: Criar um Diagrama de Contexto (C4 Nível 1) simplificado no quadro branco ou papel.
  - Foco: Quem são os usuários? Quais sistemas externos (GPS, Pagamento) interagem com o app?
  - Conexão POO (3º Período): Como essas interações de alto nível se transformarão nas classes e objetos codificados em Java/C++?
