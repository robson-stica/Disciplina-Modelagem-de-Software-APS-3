# Modelagem Ágil e Diagrams-as-Code — Práticas Ágeis, JBGE e Arquitetura Versionada em Git

## 1. Conexão Pedagógica & A Evolução da Documentação
- **O Dilema:** Em ambientes ágeis modernos com entregas contínuas, documentação estática pesada vira burocracia inútil.
- **A Solução:** **Modelagem Ágil (Agile Modeling - AM)** criada por Scott Ambler combinada com **Diagrams-as-Code (DaC)** e **Models-as-Code (MaC)**.

```text
+-----------------------------------------------------------------------------------+
|                        A EVOLUÇÃO DA GESTÃO DA DOCUMENTAÇÃO                       |
|                                                                                   |
|  [Waterfall / BDUF]     ---> Documentação Extensa Up-Front (Artefatos Mortos)      |
|  [Agile Clássico]       ---> Extremo sem Modelagem ("Código é a Documentação")   |
|  [Modelagem Ágil + DaC] ---> Modelagem JIT + Artefatos no Git (Documentação Viva)  |
+-----------------------------------------------------------------------------------+
```

---

## 2. "Ver" vs. "Enxergar" — Combate ao Architectural Drift
- **Iniciante ("Ver" o desenho isolado):** Desenha no Visio, Draw.io ou Lucidchart, exporta em `.png` e cola no Word/Wiki. Semanas depois, o código muda, ninguém atualiza a imagem e a documentação mente (Deriva Arquitetural).
- **Engenheiro ("Enxergar" o modelo como código):** O diagrama é escrito em texto (`.mmd`, `.puml`, `.dsl`) salvo na pasta `/docs/architecture/` do Git. Quando a arquitetura muda, o diagrama é alterado no mesmo **Pull Request (PR)** da mudança de código, mantendo documentação viva e auditável.

---

## 3. Práticas Chave da Modelagem Ágil (Scott Ambler)
- **JBGE (*Just Barely Good Enough*):** O modelo deve ter apenas o nível de detalhe estritamente necessário para sua finalidade imediata. Refinamento estético excessivo é desperdício (*waste*).
- **Model Storming (JIT - *Just-in-Time*):** Reuniões rápidas de 5 a 15 minutos entre 2 ou 3 desenvolvedores em frente a um quadro ou arquivo Markdown para resolver uma dúvida pontual de design durante a Sprint.
- **SSOT (*Single Source of Truth*):** Cada decisão arquitetural deve estar registrada em um único lugar no repositório.
- **Document Continuously & Document Late:** Escrever a documentação definitiva apenas quando o design estiver estabilizado.

---

## 4. Diagrams-as-Code (DaC) vs. Models-as-Code (MaC)
- **Diagrams-as-Code (DaC):** Foco no gráfico individual (arquivos `.mmd` ou `.puml`). Excelente para READMEs e visualização rápida no GitHub.
- **Models-as-Code (MaC):** Foco no modelo unificado de dados (arquivo `.dsl`). Declara o ecossistema uma única vez e gera automaticamente todas as visões C4 (L1, L2, L3) de forma sincronizada sem redundância.
