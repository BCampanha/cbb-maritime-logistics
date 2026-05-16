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

-- =====================================================
-- INSERÇÃO DE DADOS EXEMPLO
-- =====================================================

-- =====================================================
-- INSERT: empresa
-- =====================================================

INSERT INTO empresa (
    id_empresa,
    nome,
    cnpj,
    categoria
)
VALUES
(
    'EMP001',
    'CBB Maritime',
    '11.111.111/0001-11',
    'Agente de Carga'
),
(
    'EMP002',
    'MSC Shipping',
    '22.222.222/0001-22',
    'Armador'
),
(
    'EMP003',
    'Maersk Logistics',
    '33.333.333/0001-33',
    'Cliente'
);

-- =====================================================
-- INSERT: navio
-- =====================================================

INSERT INTO navio (
    nome_navio,
    bandeira,
    observacoes
)
VALUES
(
    'MSC Aurora',
    'Libéria',
    'Navio cargueiro internacional'
),
(
    'Ocean Titan',
    'Panamá',
    'Capacidade para contêineres refrigerados'
);

-- =====================================================
-- INSERT: viagem
-- =====================================================

INSERT INTO viagem (
    id_viagem,
    pais_origem,
    porto_origem,
    pais_destino,
    porto_destino,
    previsao_chegada_inicial,
    id_navio
)
VALUES
(
    1001,
    'China',
    'Shanghai',
    'Brasil',
    'Santos',
    '2026-06-20',
    1
),
(
    1002,
    'Estados Unidos',
    'Miami',
    'Brasil',
    'Rio de Janeiro',
    '2026-07-05',
    2
);

-- =====================================================
-- INSERT: etapa_viagem
-- =====================================================

INSERT INTO etapa_viagem (
    id_viagem,
    numero_etapa,
    local_etapa,
    data_etapa,
    hora_etapa
)
VALUES
(
    1001,
    1,
    'Singapura',
    '2026-06-01',
    '08:30:00'
),
(
    1001,
    2,
    'Cidade do Cabo',
    '2026-06-10',
    '14:15:00'
),
(
    1002,
    1,
    'Cartagena',
    '2026-06-25',
    '11:45:00'
);

-- =====================================================
-- INSERT: mercadoria
-- =====================================================

INSERT INTO mercadoria (
    id_mercadoria,
    peso,
    volume,
    altura,
    empilhavel,
    categoria
)
VALUES
(
    501,
    2500.75,
    33.40,
    2.50,
    TRUE,
    'Eletrônicos'
),
(
    502,
    1200.00,
    18.20,
    1.80,
    FALSE,
    'Medicamentos'
);

-- =====================================================
-- INSERT: cotacao_cliente
-- =====================================================

INSERT INTO cotacao_cliente (
    numerario_cotacao,
    moeda,
    taxa,
    tipo_taxa
)
VALUES
(
    9001,
    'USD',
    15000.00,
    'Frete Internacional'
),
(
    9002,
    'BRL',
    3500.00,
    'Taxa Portuária'
);

-- =====================================================
-- INSERT: processo
-- =====================================================

INSERT INTO processo (
    id_processo,
    data_inicio_processo,
    id_viagem,
    id_mercadoria,
    id_empresa,
    numerario_cotacao
)
VALUES
(
    7001,
    '2026-05-25',
    1001,
    501,
    'EMP001',
    9001
),
(
    7002,
    '2026-06-15',
    1002,
    502,
    'EMP003',
    9002
);

-- =====================================================
-- INSERT: custos_extras
-- =====================================================

INSERT INTO custos_extras (
    id_processo,
    id_viagem,
    avarias,
    lavagem_container,
    armazenagem,
    dta,
    demurrage_dias,
    demurrage_custo
)
VALUES
(
    7001,
    1001,
    850.00,
    250.00,
    1200.00,
    400.00,
    3,
    950.00
),
(
    7002,
    1002,
    0.00,
    180.00,
    980.00,
    350.00,
    1,
    300.00
);

-- =====================================================
-- CONSULTA TESTE
-- =====================================================

SELECT * FROM empresa;
SELECT * FROM navio;
SELECT * FROM viagem;
SELECT * FROM mercadoria;
SELECT * FROM cotacao_cliente;
SELECT * FROM processo;
SELECT * FROM custos_extras;