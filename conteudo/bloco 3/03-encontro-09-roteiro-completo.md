# Encontro 09: Diagramas de Atividades e Transição de Estados — Modelagem de Fluxos de Processo e Ciclos de Vida Reativos

**Unidade Curricular:** Modelagem de Software (4º Período – Engenharia de Software)  
**Carga Horária:** 4 horas-relógio (19:00 às 22:00)  
**Docente:** Sidney L. da Silva  
**Instituição:** UniSenai Paraná (Campus CIC / Campus da Indústria)  
**Metodologia:** Aula Teórico-Prática / Aprendizagem Baseada em Projetos (ABProj) / *Model Storming* com *Diagrams-as-Code* (Mermaid)

---

## 1. Conexão Pedagógica & Jornada de Aprendizagem

### Da Estrutura e Interação aos Processos de Negócio e Estados Críticos
Ao longo do semestre letivo de Modelagem de Software, desenvolvemos a capacidade analítica sob as três grandes perspectivas da Engenharia de Software clássica e ágil:

1. **Perspectiva Funcional (Encontro 04):** Mapeamos as fronteiras do software e a entrega de valor aos atores externos por meio dos **Diagramas de Casos de Uso**.
2. **Perspectiva Estrutural (Encontros 06 e 07):** Projetamos a organização lógica e estática ("o que o sistema é") através de **Diagramas de Classes, Interfaces, Dependências e Inversão de Controle**.
3. **Perspectiva Comportamental / Interação (Encontro 08):** Analisamos a dinâmica temporal e a orquestração síncrona e assíncrona de mensagens entre instâncias em execução com o **Diagrama de Sequência**.

```mermaid
flowchart LR
    UC["Casos de Uso<br><b>Visão Funcional</b><br>(O que o sistema faz)"] --> CL["Classes & Interfaces<br><b>Visão Estrutural</b><br>(O que o sistema é)"]
    CL --> SQ["Sequência<br><b>Visão de Interação</b><br>(Troca cronológica)"]
    SQ --> AT["Atividades & Estados<br><b>Visão Comportamental Avançada</b><br>(Processos e Ciclos de Vida)"]
```

Contudo, sistemas de nível corporativo e industrial não se limitam a invocações diretas de métodos. Eles incorporam **processos de negócio concorrentes** (que atravessam operadores humanos, dispositivos de IoT, filas de mensageria e serviços de terceiros) e **entidades de negócio de alta criticidade** cujo estado interno precisa ser protegido de transições inválidas ou corrupção lógica ao longo do tempo.

Neste **Encontro 09**, consolidamos a **Perspectiva Comportamental / Dinâmica** com dois modelos complementares da UML 2.x:
* **Diagrama de Atividades:** Projetado para mapear fluxos de trabalho (*workflows*), processos de negócio ponta a ponta, ramificações condicionais e processamento concorrente/paralelo (*fork/join*).
* **Diagrama de Transição de Estados (*State Machine*):** Projetado para descrever a evolução temporal, eventos disparadores (*triggers*), condições de guarda e efeitos colaterais no ciclo de vida de uma entidade do domínio.

---

## 2. Momento Motivacional: "Ver" vs. "Enxergar" no Comportamento Complexo

Modelar não é desenhar caixas de forma arbitrária; modelar é **abstrair a realidade de forma disciplinada para resolver um problema de negócio específico**.

### A. No Fluxo de Trabalho (Atividades)
* **O programador iniciante apenas "Vê" (Execução Estritamente Sequencial):** Diante de um processo de reserva ou compra, ele implementa todo o código de forma bloqueante: primeiro debita créditos, aguarda a resposta, depois verifica a telemetria do sensor físico, espera a confirmação e só então responde à interface web.
* **O engenheiro de software experiente "Enxerga" (Concorrência e Divisão de Papéis):** Ao desenhar o **Diagrama de Atividades com Raias (*Swimlanes*)**, ele identifica que tarefas independentes (como bloquear créditos temporários e consultar o sensor IoT de hardware) podem rodar **em paralelo (`fork/join`)**, reduzindo drasticamente o tempo de resposta da transação. Ele também atribui com exatidão a responsabilidade de cada etapa entre o Ator, o Back-End e o Hardware.

### B. No Ciclo de Vida da Entidade (Máquina de Estados)
* **O programador iniciante apenas "Vê" (Status como Strings Soltas):** Ele cria uma coluna `status VARCHAR(30)` na tabela do banco de dados e altera seu valor livremente nos métodos: `pedido.setStatus("CANCELADO")`.
  * *O desastre em produção:* Por falta de validação formal do ciclo de vida, uma requisição concorrente ou falha de interface pode alterar o status de um pedido já `"FINALIZADO"` ou `"ENTREGUE"` de volta para `"PROCESSANDO"`, gerando cobrança duplicada ou nova expedição indevida da mercadoria.
* **O engenheiro de software experiente "Enxerga" (Máquina de Estados Finita - FSM):** Ele modela o **Diagrama de Transição de Estados**. Ele documenta quais eventos provocam mudanças, estabelece **condições de guarda** e define claramente os **Estados Terminais**. Se o sistema receber um comando de cancelamento sobre uma entidade finalizada, a transição é barrada na camada de domínio com uma exceção de integridade (`InvalidStateTransitionException`).

---

## 3. Exemplo Prático em Mermaid: Diagrama de Atividades com Raias (FabLab Manager)

```mermaid
flowchart TD
    subgraph Aluno ["Raia 1: Aluno UniSenai (Ator)"]
        A_Start([Nó Inicial]) --> A_Req[Solicitar Reserva de Impressora 3D]
        A_View[Visualizar Comprovante com QR Code] --> A_EndSuccess(((Nó Final de Atividade)))
        A_Err[Visualizar Notificação de Recusa] --> A_EndFail(((Nó Final de Atividade)))
    end

    subgraph Backend ["Raia 2: Sistema FabLab Manager (Back-End)"]
        A_Req --> B_Check{Possui Saldo de Créditos?}
        B_Check -- "[Não: Saldo <= 0]" --> B_MsgSaldo[Registrar Recusa por Inadimplência]
        B_MsgSaldo --> A_Err
        
        B_Check -- "[Sim: Saldo > 0]" --> B_Fork[=== Barra de Fork: Início Paralelo ===]
        
        B_Fork --> B_Bloq[Bloquear Créditos Temporariamente]
        B_Fork --> B_Sensor[Consultar Status Telemétrico do Hardware]
        
        B_Bloq --> B_Join[=== Barra de Join: Sincronização ===]
        B_Sensor --> B_Join
        
        B_Join --> B_Avail{Equipamento Operacional?}
        B_Avail -- "[Não: Manutenção/Ocupado]" --> B_Estorno[Estornar Créditos Bloqueados]
        B_Estorno --> A_Err
        
        B_Avail -- "[Sim: Disponível]" --> B_Conf[Gravar Reserva e Gerar Token Criptográfico]
        B_Conf --> A_View
    end

    subgraph Hardware ["Raia 3: Controlador IoT (Lab FabLab)"]
        B_Conf --> H_Relay[Ativar Relé de Liberação de Energia]
        H_Relay --> H_Log[Registrar Início de Sessão na EEPROM]
    end
```

---

## 4. Exemplo Prático em Mermaid: Máquina de Estados v2 (LoteDeResiduo)

```mermaid
stateDiagram-v2
    [*] --> Rascunho : criarAnuncio()

    Rascunho --> EmAnaliseCompliance : submeterParaAprovacao() / validarLaudoAmbiental()
    
    state EmAnaliseCompliance {
        entry / notificarAuditorFiep()
        do / verificarDocumentacaoFiscal()
        exit / registrarResultadoTriagem()
    }

    EmAnaliseCompliance --> Rejeitado : reprovarLaudo[laudoIrregular == true] / registrarMotivo()
    EmAnaliseCompliance --> Publicado : aprovarLaudo[laudoValido == true] / publicarNoCatalogo()

    Publicado --> EmNegociacao : receberPropostaComercial()
    
    state EmNegociacao {
        [*] --> AnaliseProposta
        AnaliseProposta --> AguardandoEscrow : aceitarTermos()
        AguardandoEscrow --> EscrowGarantido : confirmarDepositoGarantia() / bloquearValor()
    }

    EmNegociacao --> Vendido : confirmarTransferenciaCustodia() / liberarPagamentoEscrow()
    EmNegociacao --> Publicado : desistirOuRecusarProposta()

    Vendido --> Finalizado : emitirCertificadoDestinacaoFinal()
    
    Rejeitado --> [*]
    Finalizado --> [*]
```

---

## 5. Preview do Modelo C4 (Níveis 1, 2 e 3)
No próximo encontro, encerraremos a visão microscópica de classes e métodos para dar o salto definitivo em direção à **Arquitetura de Software Macro Corporativa**. 

Aplicaremos o **Modelo C4 concebido por Simon Brown**, utilizando as metáforas de zoom estruturado (estilo Google Maps) para modelar os diagramas de **Contexto (L1)**, **Contêineres (L2)** e **Componentes (L3)** de sistemas modernos orientados a microsserviços, nuvem e contêineres Docker.

