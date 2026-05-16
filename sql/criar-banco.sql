-- =====================================================
-- SUPABASE / POSTGRESQL
-- BANCO DE DADOS: CBB MARITIME
-- Beatriz Campanha, Beatriz Albuquerque, Caroline
-- =====================================================

-- =====================================================
-- TABELA: empresa
-- =====================================================
CREATE TABLE empresa (
    id_empresa VARCHAR(50) PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    categoria VARCHAR(50) NOT NULL
);

-- =====================================================
-- TABELA: navio
-- =====================================================
CREATE TABLE navio (
    id_navio SERIAL PRIMARY KEY,
    nome_navio VARCHAR(100) NOT NULL,
    bandeira VARCHAR(50),
    observacoes VARCHAR(200)
);

-- =====================================================
-- TABELA: viagem
-- =====================================================
CREATE TABLE viagem (
    id_viagem INTEGER PRIMARY KEY,
    pais_origem VARCHAR(100),
    porto_origem VARCHAR(100),
    pais_destino VARCHAR(100),
    porto_destino VARCHAR(100),
    previsao_chegada_inicial DATE,
    id_navio INTEGER,

    CONSTRAINT fk_viagem
        FOREIGN KEY (id_navio)
        REFERENCES navio(id_navio)
        ON DELETE CASCADE
);

-- =====================================================
-- TABELA: etapa_viagem
-- =====================================================
CREATE TABLE etapa_viagem (
    id_viagem INTEGER NOT NULL,
    numero_etapa INTEGER NOT NULL,
    local_etapa VARCHAR(150),
    data_etapa DATE,
    hora_etapa TIME,

    PRIMARY KEY (id_viagem, numero_etapa),

    CONSTRAINT fk_etapa_viagem
        FOREIGN KEY (id_viagem)
        REFERENCES viagem(id_viagem)
        ON DELETE CASCADE
);

-- =====================================================
-- TABELA: mercadoria
-- =====================================================
CREATE TABLE mercadoria (
    id_mercadoria INTEGER PRIMARY KEY,
    peso NUMERIC(10,2),
    volume NUMERIC(10,2),
    altura NUMERIC(10,2),
    empilhavel BOOLEAN,
    categoria VARCHAR(20)
);

-- =====================================================
-- TABELA: cotacao_cliente
-- =====================================================
CREATE TABLE cotacao_cliente (
    numerario_cotacao INTEGER PRIMARY KEY,
    moeda VARCHAR(20),
    taxa NUMERIC(12,2),
    tipo_taxa VARCHAR(50)
);

-- =====================================================
-- TABELA: processo
-- =====================================================
CREATE TABLE processo (
    id_processo INTEGER PRIMARY KEY,
    data_inicio_processo DATE,
    id_viagem INTEGER NOT NULL,
    id_mercadoria INTEGER NOT NULL,
    id_empresa VARCHAR(50) NOT NULL,
    numerario_cotacao INTEGER NOT NULL,

    CONSTRAINT fk_processo_viagem
        FOREIGN KEY (id_viagem)
        REFERENCES viagem(id_viagem),

    CONSTRAINT fk_processo_mercadoria
        FOREIGN KEY (id_mercadoria)
        REFERENCES mercadoria(id_mercadoria),

    CONSTRAINT fk_processo_empresa
        FOREIGN KEY (id_empresa)
        REFERENCES empresa(id_empresa),

    CONSTRAINT fk_processo_cotacao
        FOREIGN KEY (numerario_cotacao)
        REFERENCES cotacao_cliente(numerario_cotacao)
);

-- =====================================================
-- TABELA: custos_extras
-- =====================================================
CREATE TABLE custos_extras (
    id_processo INTEGER NOT NULL,
    id_viagem INTEGER NOT NULL,
    avarias NUMERIC(12,2),
    lavagem_container NUMERIC(12,2),
    armazenagem NUMERIC(12,2),
    dta NUMERIC(12,2),
    demurrage_dias INTEGER,
    demurrage_custo NUMERIC(12,2),

    PRIMARY KEY (id_processo, id_viagem),

    CONSTRAINT fk_custos_processo
        FOREIGN KEY (id_processo)
        REFERENCES processo(id_processo)
        ON DELETE CASCADE
);
