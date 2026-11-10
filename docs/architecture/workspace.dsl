workspace "SafeLine" "Sistema de Monitoramento de Conformidade de Segurança (NRs)" {

    model {
        tecnico = person "Técnico de Segurança" "Audita evidências visuais e laudos de conformidade de EPI." "User"
        supervisor = person "Supervisor de Produção" "Executa planos de ação e correção de Não Conformidades." "User"
        vms = softwaresystem "Sistema VMS / Câmeras" "Fornece streams de vídeo RTSP industriais." "External"

        safeLine = softwaresystem "SafeLine" "Plataforma de auditoria e monitoramento de conformidade de EPI com IA." {
            spa = container "Web Single Page Application" "Interface de auditoria visual e governança." "React, TypeScript" "Web Browser"
            gateway = container "API Gateway" "Roteamento reverso, TLS e segurança." "Spring Cloud Gateway"
            cvEngine = container "Motor de Visão Computacional" "Detecção de EPI e cálculo de conformidade." "Python 3.11, YOLOv8"
            broker = container "Message Broker" "Buffer assíncrono para eventos de detecção e alertas." "RabbitMQ"
            coreApi = container "SafeLine Core API" "Regras de negócio, auditoria de ocorrências e gestão de NC." "Spring Boot 3.3, Java 21"
            storage = container "Object Storage" "Armazenamento seguro de evidências visuais." "MinIO S3" "Database"
            db = container "Database Relacional" "Persistência transacional de postos, ocorrências e NCs." "PostgreSQL 16" "Database"
            notifService = container "Serviço de Notificações" "Disparo em tempo real para auditores." "Node.js, WebSocket"
        }

        tecnico -> spa "Realiza auditorias e valida detecções" "HTTPS"
        supervisor -> spa "Submete planos de ação de NCs" "HTTPS"
        spa -> gateway "Requisições de API" "HTTPS/REST"
        gateway -> coreApi "Encaminha chamadas" "HTTP/REST"

        vms -> cvEngine "Stream de vídeo das linhas" "RTSP"
        cvEngine -> storage "Armazena frame com bounding box" "S3 API"
        cvEngine -> broker "Publica evento de desvio detectado" "AMQP"

        broker -> coreApi "Consome detecções" "AMQP"
        coreApi -> db "Persiste e consulta ocorrências e NCs" "JDBC"
        coreApi -> storage "Gera URLs pré-assinadas" "S3 API"
        coreApi -> broker "Publica alertas pendentes" "AMQP"

        broker -> notifService "Consome fila de notificações" "AMQP"
        notifService -> spa "Envia alertas em tempo real" "WebSocket"
    }

    views {
        container safeLine "Containers" {
            include *
            autoLayout lr
        }

        theme default
    }
}

