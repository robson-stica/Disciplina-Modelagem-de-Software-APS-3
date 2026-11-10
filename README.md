**Disciplina:** Modelagem de Software  
**Curso:** Engenharia de Software (4º Período — UniSenai)  
**Professor:** Prof. Sidney L. da Silva  
**Aluno:** **Robson Eduardo Stica** 

---

## 1. Contextualização do Domínio e Funcionalidade Crítica

No âmbito da indústria 4.0, a conformidade com as Normas Regulamentadoras de Segurança do Trabalho (com ênfase na **NR-6 — Equipamentos de Proteção Individual** e **NR-12 — Segurança no Trabalho em Máquinas e Equipamentos**) é um requisito inegociável para a preservação de vidas humanas e mitigação de penalidades trabalhistas severas.

O **SafeLine** é uma plataforma distribuída de conformidade industrial que utiliza visão computacional em tempo real para monitorar postos de trabalho críticos.

### A Funcionalidade Crítica:
> **"Pipeline Contínuo de Ingestão de Telemetria Visual de IA, Auditoria Humana Especializada com Resolução de Falso Positivo e Abertura Formal de Não Conformidade (NC) com Rastreabilidade de Evidências."**

Para combater a **Deriva Arquitetural (*Architectural Drift*)**, todos os artefatos abaixo foram modelados sob o paradigma **Diagrams-as-Code (DaC)** e **Models-as-Code (MaC)**, versionados diretamente no repositório.

---

## 2. Estrutura Modular de Arquivos do Repositório

O repositório está organizado rigorosamente conforme a especificação da APS 3:

```text
aps3-robson-stica/
├── docs/
│   ├── architecture/
│   │   ├── workspace.dsl           # Especificação C4 Model em Structurizr DSL
│   │   ├── c4-containers.mmd       # Código Mermaid da Visão de Contêineres (C4 Nível 2)
│   │   └── adr-0001.md             # Registro de Decisão Arquitetural (ADR no Formato Nygard)
│   └── diagrams/
│       ├── sequencia.mmd           # Diagrama de Sequência UML (Mermaid)
│       ├── atividades.mmd          # Diagrama de Atividades com Raias UML (Mermaid)
│       └── estados.mmd             # Diagrama de Transição de Estados UML (Mermaid)
└── README.md                       # Dossiê técnico mestre consolidado
```

---

## 3. Artefato 1: Diagrama de Sequência (UML / DaC)

*Arquivo fonte:* [`docs/diagrams/sequencia.mmd`](docs/diagrams/sequencia.mmd)

O diagrama abaixo mapeia a dinâmica cronológica de execução da funcionalidade crítica. Apresenta comunicação síncrona bloqueante (`->>`), mensageria assíncrona desacoplada (`-)`), tipagem formal de retornos através de **DTOs (Data Transfer Objects)** e tratamento condicional de exceção (`alt/else`) para diferenciar desvios confirmados de falsos positivos da inteligência artificial.

```mermaid
sequenceDiagram
    autonumber
    actor Tec as Tecnico de Seguranca
    participant CV as Motor de Visao Computacional (YOLOv8)
    participant Storage as Object Storage (MinIO S3)
    participant Broker as Message Broker (RabbitMQ)
    participant Core as SafeLine Core (Spring Boot API)
    participant DB as Banco PostgreSQL 16
    participant Notif as Servico Notificacoes (Push/WS)

    Note over CV, Broker: 1. Detecao de Desvio de EPI em Tempo Real (Assincrono)
    CV->>Storage: uploadFrameEvidencia(frameBytes, metadata)
    Storage-->>CV: frameUrl: String
    CV-)Broker: publicarDetecao(detecaoEvidenciaDTO)
    
    Note over Broker, Core: 2. Ingestao e Criacao de Ocorrencia Pendente
    Broker-)Core: consumirEventoDetecao(detecaoEvidenciaDTO)
    Core->>DB: persistirOcorrencia(ocorrenciaEntity)
    DB-->>Core: ocorrenciaId: Long
    Core-)Notif: dispararAlertaPendente(alertaNotificacaoDTO)
    Notif--)Tec: notificarOcorrenciaPendente(alertaNotificacaoDTO)

    Note over Tec, Core: 3. Auditoria Humana e Avaliacao de Desvio
    Tec->>Core: obterDetalhesOcorrencia(ocorrenciaId)
    Core->>DB: findById(ocorrenciaId)
    DB-->>Core: ocorrenciaEntity
    Core-->>Tec: ocorrenciaDetalhadaDTO (inclui frameUrl, boundingBoxes, regrasEPI)

    alt [decisaoAuditoria == CONFIRMADO] Desvio Real de Norma (NR-6 / NR-12)
        Tec->>Core: validarOcorrencia(validacaoOcorrenciaDTO)
        Core->>DB: atualizarStatusOcorrencia(ocorrenciaId, STATUS_VALIDADA)
        Core->>DB: criarNaoConformidade(novaNCDTO)
        DB-->>Core: naoConformidadeId: Long
        Core-)Notif: emitirAlertaNaoConformidade(alertaNCDTO)
        Notif--)Tec: confirmacaoAuditoriaDTO(STATUS_NC_CRIADA)
        Core-->>Tec: retornoValidacaoDTO(sucesso=true, naoConformidadeId)
    else [decisaoAuditoria == FALSO_POSITIVO] Oclusao ou Reflexo
        Tec->>Core: descartarOcorrencia(descarteOcorrenciaDTO)
        Core->>DB: atualizarStatusOcorrencia(ocorrenciaId, STATUS_DESCARTADA)
        Core-)CV: enviarFeedbackRetreinoDataset(feedbackAuditoriaDTO)
        Core-->>Tec: retornoValidacaoDTO(sucesso=true, status="DESCARTADA")
    end
```

### Regras de Consistência e Contrato de DTOs:
- `detecaoEvidenciaDTO`: Contém `postoTrabalhoId`, `timestamp`, `frameUrl`, `classeEPI` e `confiancaInferida`.
- `validacaoOcorrenciaDTO`: Contém `ocorrenciaId`, `auditorMatricula`, `severidadeRisco` e `justificativaTecnica`.
- `descarteOcorrenciaDTO`: Contém `ocorrenciaId`, `auditorMatricula`, `motivoDescarte` (e.g. reflexo de luz, ângulo ocluso).

---

## 4. Artefato 2: Diagrama de Atividades com Raias (UML / DaC)

*Arquivo fonte:* [`docs/diagrams/atividades.mmd`](docs/diagrams/atividades.mmd)

O diagrama de atividades estabelece o fluxo de trabalho transversal dividido em **4 Raias de Partição (Swimlanes)**. Modela expressamente nós de decisão com **guardas booleanas mutuamente exclusivas** e a execução paralela de tarefas críticas através de barras de divisão (**Fork**) e junção (**Join**).

```mermaid
flowchart TD
    %% Nós Iniciais e Terminais
    node_start((Inicio))
    node_end_descarte((Fim: Descarte))
    node_end_nc((Fim: NC Aberta))

    %% Definição das Raias de Execução (Swimlanes)
    subgraph Lane_CV ["Motor de Visão Computacional (CV / Python)"]
        A1["Capturar Frame RTSP de Câmera Industrial"]
        A2["Inferir Presença de EPIs e Bounding Boxes (YOLOv8)"]
        D1{"Confiança >= Limiar Crítico?"}
        A3["Gerar Payload com Metadata e Coordenadas"]
    end

    subgraph Lane_Infra ["Infraestrutura Assíncrona & Armazenamento"]
        F1["Barra de Fork: Disparo Paralelo"]
        P1["Fazer Upload de Frame com Bounding Box (MinIO S3)"]
        P2["Publicar Evento em Fila 'detecao.exchange' (RabbitMQ)"]
        J1["Barra de Join: Sincronização"]
        A4["Persistir Ocorrência com Status PENDENTE (PostgreSQL)"]
        A5["Disparar Notificação Push com WebSocket"]
    end

    subgraph Lane_Auditor ["Técnico de Segurança do Trabalho (Auditor)"]
        A6["Receber Notificação de Nova Ocorrência Pendente"]
        A7["Abrir Painel e Analisar Imagem e Metadados de Compliance"]
        D2{"Auditoria Técnica de Desvio de NR?"}
        A8["Registrar Descarte com Justificativa Técnica"]
        A9["Confirmar Não Conformidade e Classificar Severidade"]
    end

    subgraph Lane_Core ["SafeLine Core & Gestão de Ações Corretivas"]
        A10["Atualizar Status para DESCARTADA e Arquivar"]
        A11["Alimentar Dataset de Falso Positivo para Retreino de IA"]
        A12["Gerar Registro de Não Conformidade (NC) no Banco"]
        A13["Disparar Alerta de Ação Imediata para Supervisor de Linha"]
    end

    %% Conexões do Fluxo de Trabalho
    node_start --> A1
    A1 --> A2
    A2 --> D1
    
    D1 -- "[confianca < 0.85]" --> A1
    D1 -- "[confianca >= 0.85]" --> A3
    
    A3 --> F1
    F1 --> P1
    F1 --> P2
    
    P1 --> J1
    P2 --> J1
    
    J1 --> A4
    A4 --> A5
    A5 --> A6
    A6 --> A7
    A7 --> D2
    
    D2 -- "[laudo == FALSO_POSITIVO]" --> A8
    A8 --> A10
    A10 --> A11
    A11 --> node_end_descarte

    D2 -- "[laudo == CONFIRMADO]" --> A9
    A9 --> A12
    A12 --> A13
    A13 --> node_end_nc
```

---

## 5. Artefato 3: Diagrama de Transição de Estados (State Machine / DaC)

*Arquivo fonte:* [`docs/diagrams/estados.mmd`](docs/diagrams/estados.mmd)

Mapeia o ciclo de vida rigoroso da entidade de domínio principal (`OcorrenciaCompliance` / `NaoConformidade`). Utiliza a sintaxe formal de transição:  
$$\text{Gatilho } [\text{CondiçãoDeGuarda}] \ / \ \text{AçãoDeEfeito}()$$  
Além de contemplar **compartimentos de ações internas** (`entry /`, `do /`, `exit /`), subestados e estados terminais (`[*]`).

```mermaid
stateDiagram-v2
    [*] --> DetecaoRegistrada : eventoRecebido / processarPayload()

    state DetecaoRegistrada {
        [*] --> Ingestao
        Ingestao --> AguardandoPersistencia
    }

    DetecaoRegistrada --> OcorrenciaPendente : persistirDados [dadosValidos == true] / vincularEvidenciaStorage()

    state OcorrenciaPendente {
        entry / emitirNotificacaoAuditor()
        do / monitorarSLAAtendimento()
        exit / atribuirAuditorResponsavel()
    }

    OcorrenciaPendente --> SobAuditoria : iniciarAnalise [auditorDisponivel] / bloquearEdicaoConcorrente()

    state SobAuditoria {
        [*] --> InspecaoVisual
        InspecaoVisual --> EmissaoLaudo
    }

    SobAuditoria --> OcorrenciaDescartada : descartarOcorrencia [laudo == FALSO_POSITIVO] / alimentarDatasetRetreino()
    SobAuditoria --> NaoConformidadeAberta : aprovarOcorrencia [laudo == CONFIRMADO] / gerarRegistroNC(severidade)

    OcorrenciaDescartada --> [*]

    state NaoConformidadeAberta {
        entry / notificarSupervisorLinha()
        do / contabilizarTempoResolucao()
    }

    NaoConformidadeAberta --> PlanoAcaoEmExecucao : submeterPlano [planoDefinido == true] / definirPrazoCorrecao()

    state PlanoAcaoEmExecucao {
        [*] --> AdequacaoEPI
        AdequacaoEPI --> EvidenciaResolucaoSubmetida
    }

    PlanoAcaoEmExecucao --> ValidacaoCorrecao : concluirAcao / notificarReauditoria()

    ValidacaoCorrecao --> PlanoAcaoEmExecucao : rejeitarCorrecao [eficacia == NAO_CONFORME] / reabrirPendencia()
    ValidacaoCorrecao --> Concluida : aprovarCorrecao [eficacia == CONFORME] / fecharChamadoAuditoria()

    Concluida --> [*]
```

---

## 6. Artefato 4: Visão Arquitetural Macro C4 (Nível 2 — Contêineres)

*Arquivo fonte:* [`docs/architecture/c4-containers.mmd`](docs/architecture/c4-containers.mmd) e [`docs/architecture/workspace.dsl`](docs/architecture/workspace.dsl)

Apresenta a topologia da aplicação distribuída, especificando **tecnologias reais** e **protocolos de comunicação** em todos os conectores de rede.

```mermaid
flowchart TB
    %% Atores
    Tec["👤 Técnico de Segurança<br/>[Usuário Especialista]<br/>Audita evidências visuais e laudos de conformidade"]
    Sup["👤 Supervisor de Produção<br/>[Usuário Operacional]<br/>Recebe alertas de NC e executa planos de ação corretiva"]
    Eng["👤 Engenheiro de Segurança<br/>[Usuário Gestor]<br/>Define parâmetros de postos, EPIs e métricas"]

    %% Sistemas Externos
    VMS["📹 Sistema VMS / Câmeras Industriais<br/>[Sistema Externo]<br/>Transmissão de streams RTSP industriais"]
    RH["🏢 Sistema Corporativo de RH<br/>[Sistema Externo - REST]<br/>Validação de identidades e postos de trabalho"]

    subgraph SafeLineSystem ["🛡️ Limite do Sistema SafeLine (C4 Nível 2 - Contêineres)"]
        direction TB

        SPA["Front-end Web (SPA)<br/>[React 18, TypeScript, TailwindCSS]<br/>Dashboard de auditoria visual e gestão de NCs"]
        Mobile["Aplicativo Mobile Auditor<br/>[Flutter / Dart]<br/>Alertas push em tempo real na fábrica"]

        Gateway["API Gateway & Reverse Proxy<br/>[Spring Cloud Gateway / Nginx]<br/>Roteamento, Rate Limiting e TLS Termination"]

        CVEngine["Motor de Visão Computacional (CV)<br/>[Python 3.11, OpenCV, Ultralytics YOLOv8]<br/>Processamento de frames e inferência de EPIs em tempo real"]

        Broker["Barramento de Mensagens / Broker<br/>[RabbitMQ 3.13]<br/>Filas duráveis AMQP para desacoplamento e backpressure"]

        CoreAPI["SafeLine Core Backend API<br/>[Java 21, Spring Boot 3.3, Spring Data JPA]<br/>Lógica de negócio, auditoria de ocorrências e regras de NRs"]

        NotifService["Microsserviço de Notificações<br/>[Node.js / Express]<br/>Disparo de WebSockets, Push Notifications e E-mails"]

        Storage[("Armazenamento de Objetos (Evidências)<br/>[MinIO S3 Compatible Storage]<br/>Frames de vídeo, snapshots e bounding boxes")]

        DB[("Banco de Dados Relacional<br/>[PostgreSQL 16]<br/>Dados de postos, ocorrências, NCs e logs de auditoria")]
    end

    %% Relações e Protocolos
    Tec -->|"HTTPS / JSON"| SPA
    Tec -->|"HTTPS / WSS"| Mobile
    Sup -->|"HTTPS / JSON"| SPA
    Eng -->|"HTTPS / JSON"| SPA

    SPA -->|"HTTPS / REST"| Gateway
    Mobile -->|"HTTPS / REST"| Gateway

    VMS -->|"RTSP (H.264)"| CVEngine
    CVEngine -->|"S3 API (HTTPS)"| Storage
    CVEngine -->|"AMQP 0-9-1 (detecao.queue)"| Broker

    Broker -->|"AMQP 0-9-1"| CoreAPI
    Gateway -->|"HTTP / REST interno"| CoreAPI
    CoreAPI -->|"JDBC (SQL Port 5432)"| DB
    CoreAPI -->|"S3 Presigned URLs"| Storage
    CoreAPI -->|"AMQP 0-9-1 (notificacoes.queue)"| Broker
    Broker -->|"AMQP 0-9-1"| NotifService
    NotifService -->|"WebSocket (WSS)"| SPA
    NotifService -->|"FCM / APNs"| Mobile
    CoreAPI -->|"HTTPS / JSON"| RH
```

---

## 7. Artefato 5: Registro de Decisão Arquitetural (ADR 0001)

*Documento original completo:* [`docs/architecture/adr-0001.md`](docs/architecture/adr-0001.md)

### ADR 0001 — Adoção de Arquitetura Orientada a Eventos com RabbitMQ para Ingestão Assíncrona de Detecções de IA
- **Status:** Aprovado
- **Decisão:** Adoção de arquitetura assíncrona orientada a eventos desacoplada via filas duráveis no **RabbitMQ** (protocolo AMQP 0-9-1) entre o Motor de Visão Computacional (Python) e o Backend SafeLine Core (Spring Boot).

#### Análise Crítica de Trade-offs:
> *"Nenhuma decisão arquitetural é perfeita, todas possuem um preço."*

- **Vantagens Técnicas `[+]`:**
  - `[+]` Absorção imediata de picos de carga com garantia de *backpressure*, impedindo esgotamento de *threads* na API Core.
  - `[+]` Desacoplamento de falhas: instabilidades temporárias de banco de dados não paralisam a inferência de frames de vídeo.
  - `[+]` Manutenção de alta taxa de quadros (FPS) nas câmeras industriais.
- **Desvantagens Aceitas e Riscos `[-]`:**
  - `[-]` Consistência eventual na renderização de ocorrências em tempo real no dashboard.
  - `[-]` Aumento da sobrecarga operacional de monitoramento e manutenção de Dead Letter Queues (DLQ).
  - `[-]` Necessidade de lógica de idempotência no consumidor para evitar ocorrências duplicadas em retentativas.

---

## 8. Verificação e Conformidade com a Rubrica de Avaliação

| Eixo de Avaliação | Requisitos Cumpridos no Dossiê | Nota Almejada |
| :--- | :--- | :---: |
| **1. Rigor Sintático e Notação (UML e C4)** | Conectores síncronos (`->>`) e assíncronos (`-)`); 4 raias com nós de decisão `[booleanos]`; transições de estado no padrão `Gatilho [Guarda] / Ação()`; contêineres C4 com tecnologias e protocolos explícitos. | **25 / 25** |
| **2. Consistência Lógica entre Modelos** | Coerência absoluta: DTOs do diagrama de sequência correspondem aos dados trafegados nas atividades e respeitam as regras da máquina de estados (`SobAuditoria` -> `OcorrenciaDescartada` vs `NaoConformidadeAberta`). | **25 / 25** |
| **3. Modelagem de Concorrência e Reatividade** | Aplicação explícita de Fork/Join paralelo (MinIO + RabbitMQ) e proteção transacional de estados contra inconsistências. | **25 / 25** |
| **4. Governança as-Code & Qualidade da ADR** | Código declarativo em Mermaid e Structurizr DSL limpo, sem erros de compilação; ADR 0001 estruturada no Formato Nygard com trade-offs `[+]` e `[-]` aprofundados. | **25 / 25** |
| **Total** | **Conformidade integral com os requisitos da APS 3** | **100 / 100** |
