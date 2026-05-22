
-- =====================================================
-- INSERÇÃO DE DADOS EXEMPLO
-- =====================================================

-- =====================================================
-- INSERT: empresa
-- =====================================================

INSERT INTO empresas (
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

INSERT INTO navios (
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

INSERT INTO viagens (
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

INSERT INTO etapas_viagem (
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

INSERT INTO mercadorias (
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

INSERT INTO cotacoes_cliente (
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

INSERT INTO processos (
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
