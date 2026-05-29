-- =====================================================
-- LIMPEZA / AJUSTES INICIAIS
-- =====================================================

-- Tabela descartada porque os indicadores agora são calculados direto das tabelas.
DROP TABLE IF EXISTS kpis_dashboard;

-- Garante que as novas colunas existam na tabela processos.
ALTER TABLE processos
ADD COLUMN IF NOT EXISTS status VARCHAR(30) DEFAULT 'em_andamento',
ADD COLUMN IF NOT EXISTS data_fim_processo DATE,
ADD COLUMN IF NOT EXISTS status_faturamento VARCHAR(30) DEFAULT 'pendente';

-- Garante que as novas colunas existam na tabela viagens.
ALTER TABLE viagens
ADD COLUMN IF NOT EXISTS data_saida DATE,
ADD COLUMN IF NOT EXISTS data_chegada_real DATE,
ADD COLUMN IF NOT EXISTS distancia_km NUMERIC(10,2),
ADD COLUMN IF NOT EXISTS status VARCHAR(30) DEFAULT 'em_curso';

-- Tabela genérica usada para documentos, ocorrências, containers e armazenagem.
CREATE TABLE IF NOT EXISTS eventos_processo (
    id_evento SERIAL PRIMARY KEY,
    id_processo INTEGER NOT NULL REFERENCES processos(id_processo) ON DELETE CASCADE,
    tipo_evento VARCHAR(50) NOT NULL,
    subtipo VARCHAR(50),
    status VARCHAR(30),
    quantidade INTEGER DEFAULT 1,
    valor NUMERIC(12,2),
    data_evento DATE,
    descricao TEXT
);

-- Limpa dados antigos para evitar duplicidade ao rodar o script novamente.
TRUNCATE TABLE
    eventos_processo,
    custos_extras,
    processos,
    cotacoes_cliente,
    mercadorias,
    etapas_viagem,
    viagens,
    navios,
    empresas
RESTART IDENTITY CASCADE;

TRUNCATE TABLE usuarios RESTART IDENTITY CASCADE;

-- =====================================================
-- EMPRESAS
-- Apenas 3 clientes, com nomes comerciais resumidos.
-- =====================================================

INSERT INTO empresas (id_empresa, nome, cnpj, categoria) VALUES
('amazon', 'Amazon', '15.436.940/0001-03', 'Varejo'),
('cea',    'C&A',    '45.242.914/0001-05', 'Varejo'),
('magalu', 'Magalu', '47.960.950/0001-21', 'Varejo');

-- =====================================================
-- USUÁRIOS
-- =====================================================

INSERT INTO usuarios (usuario, senha_hash, tipo) VALUES
('admin', 'admin123', 'ADMIN');

-- =====================================================
-- NAVIOS
-- =====================================================

INSERT INTO navios (id_navio, nome_navio, bandeira, observacoes) VALUES
(1, 'Ever Given',              'Panamá',    'Navio porta-contêiner de grande porte'),
(2, 'MSC Gülsün',              'Panamá',    'Operação com alto volume de carga'),
(3, 'CMA CGM Marco Polo',      'França',    'Linha Europa-Ásia'),
(4, 'Maersk Skarstind',        'Dinamarca', 'Rota Américas'),
(5, 'Cosco Shipping Universe', 'China',     'Rota China-Brasil'),
(6, 'Evergreen Ever Ace',      'Taiwan',    'Linha transpacífica');

-- =====================================================
-- VIAGENS
-- Distribuição de países para ranking:
-- China = 4, Índia = 3, EUA = 2, demais = 1.
-- =====================================================

INSERT INTO viagens (
    id_viagem,
    pais_origem,
    porto_origem,
    pais_destino,
    porto_destino,
    previsao_chegada_inicial,
    id_navio,
    data_saida,
    data_chegada_real,
    distancia_km,
    status
) VALUES
-- Amazon: perfil financeiro crítico, com rotas saindo da China
(1,  'China',         'Shangai',       'Brasil', 'Santos',         '2025-02-10', 1, '2025-01-15', '2025-02-12', 19400, 'finalizada'),
(2,  'China',         'Ningbo',        'Brasil', 'Santos',         '2025-03-15', 2, '2025-02-20', '2025-03-20', 19200, 'finalizada'),
(3,  'China',         'Shenzhen',      'Brasil', 'Santos',         '2025-05-01', 5, '2025-04-05', NULL,         18800, 'em_curso'),
(4,  'China',         'Guangzhou',     'Brasil', 'Santos',         '2025-07-12', 5, '2025-06-15', NULL,         19000, 'programada'),

-- C&A: perfil documental, com Índia como país forte
(5,  'Índia',         'Mumbai',        'Brasil', 'Santos',         '2025-04-10', 3, '2025-03-15', '2025-04-09', 15100, 'finalizada'),
(6,  'Índia',         'Chennai',       'Brasil', 'Santos',         '2025-05-05', 3, '2025-04-08', NULL,         14800, 'em_curso'),
(7,  'Índia',         'Mundra',        'Brasil', 'Itajaí',         '2025-06-10', 6, '2025-05-15', NULL,         15300, 'em_curso'),
(10, 'Vietnã',        'Ho Chi Minh',   'Brasil', 'Itajaí',         '2025-08-05', 6, '2025-07-10', NULL,         18300, 'programada'),

-- Magalu: perfil operacional crítico, com atrasos e ocorrências
(8,  'EUA',           'Los Angeles',   'Brasil', 'Paranaguá',      '2025-03-18', 4, '2025-03-01', '2025-03-28',  9600, 'finalizada'),
(9,  'EUA',           'Houston',       'Brasil', 'Santos',         '2025-05-12', 4, '2025-04-18', NULL,          8400, 'em_curso'),
(11, 'Alemanha',      'Hamburgo',      'Brasil', 'Rio de Janeiro', '2025-06-01', 3, '2025-05-05', NULL,          9900, 'em_curso'),
(12, 'Coreia do Sul', 'Busan',         'Brasil', 'Itajaí',         '2025-07-01', 6, '2025-06-05', NULL,         18500, 'em_curso');

-- =====================================================
-- ETAPAS DE VIAGEM
-- =====================================================

INSERT INTO etapas_viagem (id_viagem, numero_etapa, local_etapa, data_etapa, hora_etapa) VALUES
-- Amazon
(1, 1, 'Estreito de Malaca', '2025-01-18', '08:00'),
(1, 2, 'Canal de Suez',      '2025-01-28', '14:30'),
(1, 3, 'Santos',             '2025-02-12', '07:00'),

(2, 1, 'Estreito de Malaca', '2025-02-23', '10:00'),
(2, 2, 'Canal de Suez',      '2025-03-05', '09:00'),
(2, 3, 'Santos',             '2025-03-20', '06:30'),

(3, 1, 'Estreito de Malaca', '2025-04-08', '11:00'),
(3, 2, 'Canal de Suez',      '2025-04-20', '13:00'),
(3, 3, 'Atlântico',          '2025-04-27', '09:00'),

(4, 1, 'Estreito de Malaca', '2025-06-18', '09:30'),
(4, 2, 'Canal de Suez',      '2025-06-30', '16:00'),
(4, 3, 'Atlântico',          '2025-07-08', '08:00'),

-- C&A
(5, 1, 'Oceano Índico',      '2025-03-18', '10:00'),
(5, 2, 'Canal de Suez',      '2025-03-30', '08:30'),
(5, 3, 'Santos',             '2025-04-09', '07:00'),

(6, 1, 'Oceano Índico',      '2025-04-12', '07:00'),
(6, 2, 'Canal de Suez',      '2025-04-24', '11:00'),
(6, 3, 'Atlântico',          '2025-05-01', '09:30'),

(7, 1, 'Oceano Índico',      '2025-05-18', '10:00'),
(7, 2, 'Canal de Suez',      '2025-05-30', '08:30'),
(7, 3, 'Atlântico',          '2025-06-06', '07:00'),

(10, 1, 'Singapura',         '2025-07-14', '07:00'),
(10, 2, 'Canal de Suez',     '2025-07-26', '11:00'),
(10, 3, 'Atlântico',         '2025-08-02', '09:30'),

-- Magalu
(8, 1, 'Canal do Panamá',    '2025-03-07', '15:00'),
(8, 2, 'Atlântico',          '2025-03-18', '10:00'),
(8, 3, 'Paranaguá',          '2025-03-28', '07:30'),

(9, 1, 'Canal do Panamá',    '2025-04-26', '12:00'),
(9, 2, 'Atlântico',          '2025-05-05', '14:00'),
(9, 3, 'Santos',             '2025-05-12', '08:00'),

(11, 1, 'Atlântico Norte',   '2025-05-11', '09:00'),
(11, 2, 'Atlântico',         '2025-05-23', '14:00'),
(11, 3, 'Rio de Janeiro',    '2025-05-31', '07:30'),

(12, 1, 'Estreito de Malaca','2025-06-09', '09:00'),
(12, 2, 'Canal de Suez',     '2025-06-21', '14:00'),
(12, 3, 'Atlântico',         '2025-06-29', '07:30');

-- =====================================================
-- MERCADORIAS
-- =====================================================

INSERT INTO mercadorias (id_mercadoria, peso, volume, altura, empilhavel, categoria) VALUES
(1,  18500.00, 67.20, 2.59, true,  'GERAL'),
(2,  22000.00, 72.00, 2.59, false, 'PERIGOSA'),
(3,  14200.00, 33.20, 2.59, true,  'REFRIGERADA'),
(4,  9800.00,  67.20, 2.59, true,  'GERAL'),
(5,  31000.00, 72.00, 2.59, false, 'GERAL'),
(6,  7500.00,  33.20, 2.59, true,  'PERIGOSA'),
(7,  19200.00, 67.20, 2.59, true,  'REFRIGERADA'),
(8,  25400.00, 67.20, 2.59, false, 'GERAL'),
(9,  12700.00, 33.20, 2.59, true,  'GERAL'),
(10, 28900.00, 72.00, 2.59, true,  'GERAL'),
(11, 16300.00, 67.20, 2.59, false, 'PERIGOSA'),
(12, 8900.00,  33.20, 2.59, true,  'REFRIGERADA');

-- =====================================================
-- COTAÇÕES / VALORES FATURADOS
-- =====================================================

INSERT INTO cotacoes_cliente (numerario_cotacao, moeda, taxa, tipo_taxa) VALUES
(1001, 'BRL', 320000.00, 'CIF'),
(1002, 'BRL', 180000.00, 'FOB'),
(1003, 'BRL', 450000.00, 'CIF'),
(1004, 'BRL', 390000.00, 'FOB'),
(1005, 'BRL', 210000.00, 'CIF'),
(1006, 'BRL', 165000.00, 'FOB'),
(1007, 'BRL', 250000.00, 'CIF'),
(1008, 'BRL', 135000.00, 'FOB'),
(1009, 'BRL', 275000.00, 'CIF'),
(1010, 'BRL', 310000.00, 'CIF'),
(1011, 'BRL', 195000.00, 'FOB'),
(1012, 'BRL', 225000.00, 'CIF');

-- =====================================================
-- PROCESSOS
-- Amazon: custos altos.
-- C&A: documentos pendentes.
-- Magalu: atrasos e ocorrências.
-- =====================================================

INSERT INTO processos (
    id_processo,
    data_inicio_processo,
    id_viagem,
    id_mercadoria,
    id_empresa,
    numerario_cotacao,
    status,
    data_fim_processo,
    status_faturamento
) VALUES
-- Amazon
(1,  '2025-01-02', 1,  1,  'amazon', 1001, 'finalizado',   '2025-02-14', 'pago'),
(2,  '2025-02-05', 2,  2,  'amazon', 1002, 'finalizado',   '2025-03-23', 'pendente'),
(3,  '2025-04-01', 3,  3,  'amazon', 1003, 'em_andamento', NULL,         'vencido'),
(4,  '2025-06-01', 4,  4,  'amazon', 1004, 'futuro',       NULL,         'pendente'),

-- C&A
(5,  '2025-03-05', 5,  5,  'cea',    1005, 'finalizado',   '2025-04-11', 'pago'),
(6,  '2025-04-05', 6,  6,  'cea',    1006, 'em_andamento', NULL,         'pendente'),
(7,  '2025-05-01', 7,  7,  'cea',    1007, 'em_andamento', NULL,         'pendente'),
(8,  '2025-07-01', 10, 8,  'cea',    1008, 'futuro',       NULL,         'pendente'),

-- Magalu
(9,  '2025-02-25', 8,  9,  'magalu', 1009, 'finalizado',   '2025-03-31', 'vencido'),
(10, '2025-04-10', 9,  10, 'magalu', 1010, 'em_andamento', NULL,         'pendente'),
(11, '2025-05-01', 11, 11, 'magalu', 1011, 'em_andamento', NULL,         'pendente'),
(12, '2025-06-01', 12, 12, 'magalu', 1012, 'em_andamento', NULL,         'vencido');

-- =====================================================
-- CUSTOS EXTRAS
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
) VALUES
-- Amazon: valores mais altos
(1, 1,  8500.00, 1200.00, 15600.00, 3200.00,  8,  9600.00),
(2, 2,     0.00,  800.00,  7200.00, 1500.00,  3,  3600.00),
(3, 3, 12300.00, 1500.00, 22400.00, 4800.00, 12, 14400.00),
(4, 4, 18500.00, 2200.00, 34800.00, 7200.00, 15, 18000.00),

-- C&A: custos moderados
(5, 5,  1200.00,  600.00,  5400.00, 1200.00, 2, 2400.00),
(6, 6,     0.00,  450.00,  4200.00,  900.00, 1, 1200.00),
(7, 7,  2600.00,  700.00,  8400.00, 1700.00, 4, 4800.00),
(8, 10,    0.00,  500.00,  5000.00, 1000.00, 1, 1200.00),

-- Magalu: custos por atraso e ocorrência
(9,  8,  6700.00,  950.00, 16800.00, 3500.00,  8,  9600.00),
(10, 9,  9200.00, 1300.00, 19600.00, 4100.00, 10, 12000.00),
(11, 11, 11500.00, 1600.00, 23800.00, 5000.00, 11, 13200.00),
(12, 12, 15300.00, 2000.00, 31600.00, 6600.00, 14, 16800.00);

-- =====================================================
-- EVENTOS: DOCUMENTOS
-- C&A tem o pior perfil documental.
-- =====================================================

INSERT INTO eventos_processo
(id_processo, tipo_evento, subtipo, status, quantidade, valor, data_evento, descricao)
VALUES
-- Amazon
(1, 'documento', 'invoice',               'processado', 1, NULL, '2025-01-04', 'Invoice processada'),
(1, 'documento', 'packing_list',          'processado', 1, NULL, '2025-01-05', 'Packing list processado'),
(1, 'documento', 'conhecimento_embarque', 'processado', 1, NULL, '2025-01-07', 'Conhecimento de embarque processado'),
(2, 'documento', 'invoice',               'processado', 1, NULL, '2025-02-08', 'Invoice processada'),
(2, 'documento', 'packing_list',          'processado', 1, NULL, '2025-02-09', 'Packing list processado'),
(2, 'documento', 'certificado_origem',    'em_analise', 1, NULL, '2025-02-10', 'Certificado de origem em análise'),
(3, 'documento', 'invoice',               'processado', 1, NULL, '2025-04-02', 'Invoice processada'),
(3, 'documento', 'packing_list',          'processado', 1, NULL, '2025-04-03', 'Packing list processado'),
(4, 'documento', 'invoice',               'processado', 1, NULL, '2025-06-02', 'Invoice processada'),
(4, 'documento', 'conhecimento_embarque', 'pendente',   1, NULL, '2025-06-03', 'Conhecimento de embarque pendente'),

-- C&A
(5, 'documento', 'invoice',               'processado', 1, NULL, '2025-03-06', 'Invoice processada'),
(5, 'documento', 'packing_list',          'em_analise', 1, NULL, '2025-03-07', 'Packing list em análise'),
(5, 'documento', 'certificado_origem',    'pendente',   1, NULL, '2025-03-08', 'Certificado de origem pendente'),
(6, 'documento', 'invoice',               'em_analise', 1, NULL, '2025-04-06', 'Invoice em análise'),
(6, 'documento', 'packing_list',          'pendente',   1, NULL, '2025-04-07', 'Packing list pendente'),
(6, 'documento', 'conhecimento_embarque', 'pendente',   1, NULL, '2025-04-08', 'Conhecimento de embarque pendente'),
(7, 'documento', 'invoice',               'processado', 1, NULL, '2025-05-02', 'Invoice processada'),
(7, 'documento', 'packing_list',          'pendente',   1, NULL, '2025-05-03', 'Packing list pendente'),
(7, 'documento', 'certificado_origem',    'pendente',   1, NULL, '2025-05-04', 'Certificado de origem pendente'),
(8, 'documento', 'invoice',               'pendente',   1, NULL, '2025-07-02', 'Invoice pendente'),
(8, 'documento', 'packing_list',          'pendente',   1, NULL, '2025-07-03', 'Packing list pendente'),
(8, 'documento', 'conhecimento_embarque', 'pendente',   1, NULL, '2025-07-04', 'Conhecimento de embarque pendente'),

-- Magalu
(9,  'documento', 'invoice',              'processado', 1, NULL, '2025-02-26', 'Invoice processada'),
(9,  'documento', 'packing_list',         'processado', 1, NULL, '2025-02-27', 'Packing list processado'),
(10, 'documento', 'invoice',              'processado', 1, NULL, '2025-04-11', 'Invoice processada'),
(10, 'documento', 'packing_list',         'em_analise', 1, NULL, '2025-04-12', 'Packing list em análise'),
(11, 'documento', 'invoice',              'processado', 1, NULL, '2025-05-02', 'Invoice processada'),
(11, 'documento', 'certificado_origem',   'processado', 1, NULL, '2025-05-03', 'Certificado de origem processado'),
(12, 'documento', 'invoice',              'em_analise', 1, NULL, '2025-06-02', 'Invoice em análise'),
(12, 'documento', 'packing_list',         'pendente',   1, NULL, '2025-06-03', 'Packing list pendente');

-- =====================================================
-- EVENTOS: OCORRÊNCIAS
-- Magalu tem mais atrasos e ocorrências abertas.
-- =====================================================

INSERT INTO eventos_processo
(id_processo, tipo_evento, subtipo, status, quantidade, valor, data_evento, descricao)
VALUES
-- Amazon
(1,  'ocorrencia', 'avaria',   'resolvida', 1,  8500.00, '2025-01-22', 'Avaria identificada e resolvida'),
(3,  'ocorrencia', 'avaria',   'aberta',    1, 12300.00, '2025-04-18', 'Avaria em análise'),
(4,  'ocorrencia', 'avaria',   'aberta',    1, 18500.00, '2025-06-20', 'Avaria de alto impacto registrada'),
(4,  'ocorrencia', 'atraso',   'aberta',    1, NULL,     '2025-06-25', 'Atraso por congestionamento portuário'),

-- C&A
(5,  'ocorrencia', 'avaria',   'resolvida', 1, 1200.00,  '2025-03-30', 'Avaria de baixo impacto resolvida'),
(7,  'ocorrencia', 'atraso',   'aberta',    1, NULL,     '2025-05-20', 'Atraso leve em etapa intermediária'),

-- Magalu
(9,  'ocorrencia', 'atraso',   'resolvida', 1, NULL,     '2025-03-18', 'Atraso na chegada ao porto'),
(9,  'ocorrencia', 'avaria',   'aberta',    1,  6700.00, '2025-03-24', 'Avaria em conferência'),
(10, 'ocorrencia', 'atraso',   'aberta',    1, NULL,     '2025-05-12', 'Atraso por retenção operacional'),
(10, 'ocorrencia', 'extravio', 'aberta',    1, NULL,     '2025-05-14', 'Extravio parcial de volume'),
(11, 'ocorrencia', 'avaria',   'aberta',    1, 11500.00, '2025-05-17', 'Avaria reportada pelo terminal'),
(11, 'ocorrencia', 'atraso',   'aberta',    1, NULL,     '2025-05-19', 'Atraso na liberação documental'),
(12, 'ocorrencia', 'atraso',   'aberta',    1, NULL,     '2025-06-28', 'Atraso previsto na chegada'),
(12, 'ocorrencia', 'extravio', 'aberta',    1, NULL,     '2025-06-29', 'Extravio em investigação');

-- =====================================================
-- EVENTOS: CONTAINERS
-- =====================================================

INSERT INTO eventos_processo
(id_processo, tipo_evento, subtipo, status, quantidade, valor, data_evento, descricao)
VALUES
-- Amazon
(1,  'container', 'dry',       'ativo', 2, NULL, '2025-01-15', 'Containers do processo'),
(2,  'container', 'reefer',    'ativo', 1, NULL, '2025-02-20', 'Container refrigerado'),
(3,  'container', 'dry',       'ativo', 2, NULL, '2025-04-05', 'Containers do processo'),
(4,  'container', 'dry',       'ativo', 2, NULL, '2025-06-15', 'Containers do processo'),

-- C&A
(5,  'container', 'dry',       'ativo', 1, NULL, '2025-03-15', 'Container do processo'),
(6,  'container', 'dry',       'ativo', 1, NULL, '2025-04-08', 'Container do processo'),
(7,  'container', 'dry',       'ativo', 1, NULL, '2025-05-15', 'Container do processo'),
(8,  'container', 'dry',       'ativo', 1, NULL, '2025-07-10', 'Container do processo'),

-- Magalu
(9,  'container', 'dry',       'ativo', 2, NULL, '2025-03-01', 'Containers do processo'),
(10, 'container', 'dry',       'ativo', 2, NULL, '2025-04-18', 'Containers do processo'),
(11, 'container', 'dangerous', 'ativo', 1, NULL, '2025-05-05', 'Container de carga perigosa'),
(12, 'container', 'reefer',    'ativo', 1, NULL, '2025-06-05', 'Container refrigerado');

-- =====================================================
-- EVENTOS: ARMAZENAGEM
-- subtipo = dias    -> quantidade representa dias.
-- subtipo = armazem -> descrição representa o armazém.
-- =====================================================

INSERT INTO eventos_processo
(id_processo, tipo_evento, subtipo, status, quantidade, valor, data_evento, descricao)
VALUES
-- Amazon
(1, 'armazenagem', 'dias',    'finalizado', 8,  15600.00, '2025-02-12', 'Dias de armazenagem'),
(1, 'armazenagem', 'armazem', 'finalizado', 1,  NULL,     '2025-02-12', 'Armazém Santos 1'),
(2, 'armazenagem', 'dias',    'finalizado', 3,   7200.00, '2025-03-20', 'Dias de armazenagem'),
(2, 'armazenagem', 'armazem', 'finalizado', 1,  NULL,     '2025-03-20', 'Armazém Santos 2'),
(3, 'armazenagem', 'dias',    'ativo',      12, 22400.00, '2025-05-01', 'Dias de armazenagem'),
(3, 'armazenagem', 'armazem', 'ativo',      1,  NULL,     '2025-05-01', 'Armazém Santos 1'),
(4, 'armazenagem', 'dias',    'programado', 15, 34800.00, '2025-07-12', 'Dias de armazenagem previstos'),
(4, 'armazenagem', 'armazem', 'programado', 1,  NULL,     '2025-07-12', 'Armazém Santos 3'),

-- C&A
(5, 'armazenagem', 'dias',    'finalizado', 2,   5400.00, '2025-04-09', 'Dias de armazenagem'),
(5, 'armazenagem', 'armazem', 'finalizado', 1,  NULL,     '2025-04-09', 'Armazém Santos 4'),
(6, 'armazenagem', 'dias',    'ativo',      1,   4200.00, '2025-05-05', 'Dias de armazenagem'),
(6, 'armazenagem', 'armazem', 'ativo',      1,  NULL,     '2025-05-05', 'Armazém Santos 4'),
(7, 'armazenagem', 'dias',    'ativo',      4,   8400.00, '2025-06-10', 'Dias de armazenagem'),
(7, 'armazenagem', 'armazem', 'ativo',      1,  NULL,     '2025-06-10', 'Armazém Itajaí 1'),
(8, 'armazenagem', 'dias',    'programado', 1,   5000.00, '2025-08-05', 'Dias de armazenagem previstos'),
(8, 'armazenagem', 'armazem', 'programado', 1,  NULL,     '2025-08-05', 'Armazém Santos 5'),

-- Magalu
(9,  'armazenagem', 'dias',    'finalizado', 8,  16800.00, '2025-03-28', 'Dias de armazenagem'),
(9,  'armazenagem', 'armazem', 'finalizado', 1,  NULL,     '2025-03-28', 'Armazém Paranaguá 1'),
(10, 'armazenagem', 'dias',    'ativo',      10, 19600.00, '2025-05-12', 'Dias de armazenagem'),
(10, 'armazenagem', 'armazem', 'ativo',      1,  NULL,     '2025-05-12', 'Armazém Santos 6'),
(11, 'armazenagem', 'dias',    'ativo',      11, 23800.00, '2025-06-01', 'Dias de armazenagem'),
(11, 'armazenagem', 'armazem', 'ativo',      1,  NULL,     '2025-06-01', 'Armazém Rio 1'),
(12, 'armazenagem', 'dias',    'ativo',      14, 31600.00, '2025-07-01', 'Dias de armazenagem'),
(12, 'armazenagem', 'armazem', 'ativo',      1,  NULL,     '2025-07-01', 'Armazém Itajaí 2');

-- =====================================================
-- AJUSTE DAS SEQUENCES
-- Necessário porque alguns IDs foram inseridos manualmente.
-- =====================================================

SELECT setval('navios_id_navio_seq', COALESCE((SELECT MAX(id_navio) FROM navios), 1), true);
SELECT setval('usuarios_id_usuario_seq', COALESCE((SELECT MAX(id_usuario) FROM usuarios), 1), true);
SELECT setval('eventos_processo_id_evento_seq', COALESCE((SELECT MAX(id_evento) FROM eventos_processo), 1), true);
