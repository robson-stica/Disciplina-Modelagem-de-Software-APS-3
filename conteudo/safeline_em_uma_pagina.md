# SafeLine em Uma Página: O Que É, O Que Faz e Como Explicar

**Estudante:** Robson Stica  
**Disciplina:** Modelagem de Software (UniSenai) — Prof. Sidney L. da Silva  
**Projeto Selecionado:** Grupo 4 — **Compliance NRs (SafeLine)**  

---

## 1. A História do Projeto em Linguagem Real (Sem jargões)

Imagine uma grande fábrica industrial de Curitiba (metalúrgica, fábrica de carros ou papel e celulose).
Nessa fábrica trabalham centenas de operários operando máquinas pesadas, prensas e esteiras rolantes.

### O Problema do Dono da Fábrica e dos Trabalhadores:
1. Todo operário precisa usar **EPIs (Equipamentos de Proteção Individual)**: óculos, capacete, luvas, bota de bico de aço. A lei que exige isso no Brasil é a **NR-6**.
2. Máquinas cortantes e prensas têm áreas perigosas onde ninguém pode colocar a mão ou o corpo. A lei que exige proteção em máquinas é a **NR-12**.
3. **O problema:** O ser humano se descuida, tira o capacete no calor, tira o óculos porque embaçou, ou entra em área de risco. O Técnico de Segurança do Trabalho não consegue ficar olhando 200 operários ao mesmo tempo. Se houver um acidente, alguém perde um dedo, uma vida, e a empresa toma uma multa milionária do Ministério do Trabalho.

### A Solução do Software SafeLine:
A empresa coloca **câmeras de segurança comuns** apontadas para as linhas de montagem.
O software **SafeLine** fica rodando em um servidor e "assistindo" a essas câmeras o dia todo:
- Uma **Inteligência Artificial (Visão Computacional)** fica olhando cada frame do vídeo.
- Se alguém tira o capacete ou invade uma área proibida, a IA identifica em fração de segundo.
- O sistema tira um "print" (snapshot) da infração com um retângulo vermelho ao redor da cabeça do operário.
- Manda um alerta para o celular ou computador do **Técnico de Segurança do Trabalho**.

---

## 2. A Grande Sacada de Engenharia: Por que o Humano Precisa Validar?

A Inteligência Artificial pode se enganar:
- O operário abaixou a cabeça e o capacete ficou escondido atrás de uma viga de aço;
- Um reflexo de lâmpada fez parecer que ele estava sem óculos de proteção;
- Uma sombra no chão pareceu uma invasão de área.

Se o computador aplicasse uma multa ou advertência automaticamente, isso geraria revolta na fábrica e processos trabalhistas.

**Por isso o SafeLine funciona em 2 etapas:**
1. **A IA gera uma OCORRÊNCIA PENDENTE (Suspeita).**
2. **O Técnico de Segurança (Humano) abre a foto no painel:**
   - **Caso A (Falso Alarme / Engano da IA):** Ele clica em *"Descartar"*. O funcionário não é incomodado e o sistema guarda essa foto para treinar a IA a não errar mais naquele ângulo.
   - **Caso B (Infração Real):** Ele clica em *"Confirmar"*. Aí sim o sistema abre uma **Não Conformidade (NC)** formal, que dispara uma ordem para o Supervisor da fábrica ir até o posto orientar o operário e regularizar a situação.

---

## 3. Onde Entram os 5 Diagramas que Você Fez?

Cada um dos diagramas da sua atividade explica uma parte dessa história para os programadores construírem o sistema:

| Diagrama | O que ele mostra nessa história da fábrica? |
| :--- | :--- |
| **1. Sequência** | A linha do tempo: A câmera vê o operário $\rightarrow$ avisa a IA $\rightarrow$ a IA guarda a foto e joga um aviso na fila do RabbitMQ $\rightarrow$ o servidor avisa o celular do técnico $\rightarrow$ o técnico clica se é infração real ou engano. |
| **2. Atividades (Raias e Fork/Join)** | O passo a passo dividido em colunas (raias): A coluna da IA faz duas coisas ao mesmo tempo (**Fork**): sobe a foto para o servidor de arquivos e manda o alerta na fila. Só depois que os dois acabam (**Join**), o sistema grava no banco de dados. |
| **3. Máquina de Estados** | A "vida" da advertência: Ela nasce como `Pendente`, vai para `Em Análise`, e depois só pode ter dois fins: ou morre como `Descartada` (engano) ou vira `Não Conformidade` (infração confirmada que precisa ser corrigida). |
| **4. C4 Contêineres** | As peças de computador usadas: O painel web em **React**, o cérebro da IA em **Python**, o servidor principal em **Spring Boot (Java)**, o banco de dados **PostgreSQL**, e o correio de mensagens **RabbitMQ**. |
| **5. ADR 0001** | A explicação técnica de por que colocamos o **RabbitMQ** no meio: Se 10 câmeras virem infrações ao mesmo tempo, o servidor não trava porque as mensagens ficam na fila esperando a vez. |

---

## 4. O que você fala em 30 segundos se o professor te perguntar do nada:

> *"Professor, o meu projeto é o **SafeLine**. Ele é um sistema de software para fábricas que se conecta às câmeras de vigilância para fiscalizar se os operários estão usando capacete e óculos (NR-6) e se não estão correndo risco perto de máquinas pesadas (NR-12).  
> A Inteligência Artificial detecta a suspeita de desvio em tempo real, mas quem decide a penalidade é o Técnico de Segurança humano através de uma tela de auditoria, evitando injustiças por falsos positivos. Modelei todo o fluxo de ingestão de vídeo, filas de mensagens, concorrência e o ciclo de vida dessas ocorrências usando Diagrams-as-Code."*
