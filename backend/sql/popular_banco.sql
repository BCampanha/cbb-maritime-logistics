-- =====================================================
-- SUPABASE / POSTGRESQL
-- POPULAR BANCO: CBB MARITIME
-- =====================================================

-- =====================================================
-- EMPRESAS 
-- =====================================================
INSERT INTO empresas (id_empresa, nome, cnpj, categoria) VALUES
('amazon',       'Amazon Serviços de Varejo do Brasil Ltda', '15.436.940/0001-03', 'Varejo'),
('cea',          'C&A Modas S.A.',                           '45.242.914/0001-05', 'Varejo'),
('samsung',      'Samsung Eletrônica da Amazônia Ltda',      '00.280.273/0001-37', 'Tecnologia'),
('nestlé',       'Nestlé Brasil Ltda',                       '60.409.075/0001-52', 'Alimentos'),
('volkswagen',   'Volkswagen do Brasil Indústria de Veículos Ltda', '59.104.422/0001-50', 'Automotivo'),
('renner',       'Lojas Renner S.A.',                        '92.754.738/0001-62', 'Varejo');

-- =====================================================
-- USUARIOS
-- =====================================================
INSERT INTO usuarios (usuario, senha_hash, tipo) VALUES
('admin',      'admin123', 'ADMIN');

-- =====================================================
-- NAVIOS
-- =====================================================
INSERT INTO navios (id_navio, nome_navio, bandeira, observacoes) VALUES
(1,  'Ever Given',        'Panamá',       'Navio porta-contêiner de grande porte'),
(2,  'MSC Gülsün',        'Panamá',       'Um dos maiores navios do mundo'),
(3,  'CMA CGM Marco Polo','França',       'Linha Europa-Ásia'),
(4,  'Maersk Skarstind',  'Dinamarca',    'Serviço AE-1'),
(5,  'HMM Algeciras',     'Coreia do Sul','Ultra large container vessel'),
(6,  'ONE Innovation',    'Japão',        'Linha transpacífica'),
(7,  'Cosco Shipping Universe', 'China',  'Rota China-Brasil'),
(8,  'Yang Ming Warranty','Taiwan',       'Serviço TP-12'),
(9,  'Evergreen Ever Ace','Taiwan',       'Linha AEX'),
(10, 'PIL Providence',    'Singapura',    'Rota intrarregional');

-- =====================================================
-- VIAGENS
-- =====================================================
INSERT INTO viagens (id_viagem, pais_origem, porto_origem, pais_destino, porto_destino, previsao_chegada_inicial, id_navio) VALUES
(1,  'China',       'Shangai',       'Brasil', 'Santos',       '2025-02-10', 1),
(2,  'China',       'Ningbo',        'Brasil', 'Santos',       '2025-02-20', 2),
(3,  'Alemanha',    'Hamburgo',      'Brasil', 'Rio de Janeiro','2025-03-05', 3),
(4,  'EUA',         'Los Angeles',   'Brasil', 'Paranaguá',    '2025-03-18', 4),
(5,  'China',       'Shenzhen',      'Brasil', 'Santos',       '2025-04-02', 5),
(6,  'Japão',       'Tóquio',        'Brasil', 'Rio Grande',   '2025-04-15', 6),
(7,  'China',       'Guangzhou',     'Brasil', 'Santos',       '2025-05-01', 7),
(8,  'Coreia do Sul','Busan',        'Brasil', 'Itajaí',       '2025-05-20', 8),
(9,  'Países Baixos','Roterdã',      'Brasil', 'Santos',       '2025-06-10', 9),
(10, 'China',       'Tianjin',       'Brasil', 'Santos',       '2025-06-25', 10),
(11, 'China',       'Shangai',       'Brasil', 'Santos',       '2025-07-08', 1),
(12, 'EUA',         'Nova York',     'Brasil', 'Rio de Janeiro','2025-07-22', 3),
(13, 'China',       'Qingdao',       'Brasil', 'Paranaguá',    '2025-08-05', 2),
(14, 'França',      'Marselha',      'Brasil', 'Santos',       '2025-08-18', 4),
(15, 'China',       'Shangai',       'Brasil', 'Santos',       '2025-09-01', 7);

-- =====================================================
-- ETAPAS DE VIAGEM (escalas por viagem)
-- =====================================================
INSERT INTO etapas_viagem (id_viagem, numero_etapa, local_etapa, data_etapa, hora_etapa) VALUES
-- Viagem 1: Shangai -> Santos (via Malaca, Suez, Atlântico)
(1, 1, 'Estreito de Malaca',      '2025-01-18', '08:00'),
(1, 2, 'Canal de Suez',           '2025-01-28', '14:30'),
(1, 3, 'Santos',                  '2025-02-10', '07:00'),
-- Viagem 2: Ningbo -> Santos
(2, 1, 'Estreito de Malaca',      '2025-01-26', '10:00'),
(2, 2, 'Canal de Suez',           '2025-02-05', '09:00'),
(2, 3, 'Santos',                  '2025-02-20', '06:30'),
-- Viagem 3: Hamburgo -> Rio
(3, 1, 'Atlântico Norte',         '2025-02-20', '12:00'),
(3, 2, 'Rio de Janeiro',          '2025-03-05', '08:00'),
-- Viagem 4: Los Angeles -> Paranaguá
(4, 1, 'Canal do Panamá',         '2025-03-02', '15:00'),
(4, 2, 'Paranaguá',               '2025-03-18', '07:30'),
-- Viagem 5: Shenzhen -> Santos
(5, 1, 'Estreito de Malaca',      '2025-03-12', '11:00'),
(5, 2, 'Canal de Suez',           '2025-03-22', '13:00'),
(5, 3, 'Santos',                  '2025-04-02', '09:00'),
-- Viagem 6: Tóquio -> Rio Grande
(6, 1, 'Pacífico Central',        '2025-03-28', '06:00'),
(6, 2, 'Canal do Panamá',         '2025-04-04', '14:00'),
(6, 3, 'Rio Grande',              '2025-04-15', '10:00'),
-- Viagem 7: Guangzhou -> Santos
(7, 1, 'Estreito de Malaca',      '2025-04-08', '09:30'),
(7, 2, 'Canal de Suez',           '2025-04-18', '16:00'),
(7, 3, 'Santos',                  '2025-05-01', '08:00'),
-- Viagem 8: Busan -> Itajaí
(8, 1, 'Estreito de Malaca',      '2025-04-28', '07:00'),
(8, 2, 'Canal de Suez',           '2025-05-08', '11:00'),
(8, 3, 'Itajaí',                  '2025-05-20', '09:30'),
-- Viagem 9: Roterdã -> Santos
(9, 1, 'Atlântico',               '2025-05-28', '14:00'),
(9, 2, 'Santos',                  '2025-06-10', '08:00'),
-- Viagem 10: Tianjin -> Santos
(10, 1, 'Estreito de Malaca',     '2025-06-03', '10:00'),
(10, 2, 'Canal de Suez',          '2025-06-13', '08:30'),
(10, 3, 'Santos',                 '2025-06-25', '07:00'),
-- Viagem 11
(11, 1, 'Estreito de Malaca',     '2025-06-16', '09:00'),
(11, 2, 'Canal de Suez',          '2025-06-26', '12:00'),
(11, 3, 'Santos',                 '2025-07-08', '08:00'),
-- Viagem 12
(12, 1, 'Atlântico Norte',        '2025-07-08', '11:00'),
(12, 2, 'Rio de Janeiro',         '2025-07-22', '09:00'),
-- Viagem 13
(13, 1, 'Estreito de Malaca',     '2025-07-14', '08:00'),
(13, 2, 'Canal de Suez',          '2025-07-24', '15:00'),
(13, 3, 'Paranaguá',              '2025-08-05', '07:30'),
-- Viagem 14
(14, 1, 'Atlântico',              '2025-08-04', '13:00'),
(14, 2, 'Santos',                 '2025-08-18', '08:00'),
-- Viagem 15
(15, 1, 'Estreito de Malaca',     '2025-08-09', '09:00'),
(15, 2, 'Canal de Suez',          '2025-08-19', '14:00'),
(15, 3, 'Santos',                 '2025-09-01', '07:30');

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
(12, 8900.00,  33.20, 2.59, true,  'REFRIGERADA'),
(13, 33000.00, 72.00, 2.59, true,  'GERAL'),
(14, 21500.00, 67.20, 2.59, false, 'GERAL'),
(15, 11200.00, 33.20, 2.59, true,  'PERIGOSA'),
(16, 27800.00, 72.00, 2.59, true,  'REFRIGERADA'),
(17, 15600.00, 67.20, 2.59, false, 'GERAL'),
(18, 9200.00,  33.20, 2.59, true,  'GERAL'),
(19, 24100.00, 67.20, 2.59, true,  'PERIGOSA'),
(20, 18700.00, 72.00, 2.59, false, 'GERAL');

-- =====================================================
-- COTAÇÕES CLIENTE
-- =====================================================
INSERT INTO cotacoes_cliente (numerario_cotacao, moeda, taxa, tipo_taxa) VALUES
(1001, 'USD', 320000.00, 'CIF'),
(1002, 'USD', 180000.00, 'FOB'),
(1003, 'EUR', 210000.00, 'CIF'),
(1004, 'USD', 450000.00, 'CIF'),
(1005, 'USD', 390000.00, 'FOB'),
(1006, 'USD', 275000.00, 'CIF'),
(1007, 'EUR', 315000.00, 'FOB'),
(1008, 'USD', 520000.00, 'CIF'),
(1009, 'USD', 195000.00, 'FOB'),
(1010, 'USD', 410000.00, 'CIF'),
(1011, 'EUR', 280000.00, 'FOB'),
(1012, 'USD', 350000.00, 'CIF'),
(1013, 'USD', 225000.00, 'FOB'),
(1014, 'EUR', 480000.00, 'CIF'),
(1015, 'USD', 165000.00, 'FOB');

-- =====================================================
-- PROCESSOS
-- =====================================================
INSERT INTO processos (id_processo, data_inicio_processo, id_viagem, id_mercadoria, id_empresa, numerario_cotacao) VALUES
(1,  '2025-01-02', 1,  1,  'amazon',    1001),
(2,  '2025-01-05', 1,  2,  'amazon',    1002),
(3,  '2025-01-10', 2,  3,  'cea',       1003),
(4,  '2025-01-15', 2,  4,  'cea',       1004),
(5,  '2025-01-20', 3,  5,  'samsung',   1005),
(6,  '2025-02-01', 3,  6,  'samsung',   1006),
(7,  '2025-02-05', 4,  7,  'nestlé',    1007),
(8,  '2025-02-10', 4,  8,  'nestlé',    1008),
(9,  '2025-02-15', 5,  9,  'volkswagen',1009),
(10, '2025-02-20', 5,  10, 'volkswagen',1010),
(11, '2025-03-01', 6,  11, 'renner',    1011),
(12, '2025-03-05', 6,  12, 'renner',    1012),
(13, '2025-03-10', 7,  13, 'amazon',    1013),
(14, '2025-03-15', 7,  14, 'amazon',    1014),
(15, '2025-03-20', 8,  15, 'cea',       1015),
(16, '2025-04-01', 8,  16, 'cea',       1001),
(17, '2025-04-05', 9,  17, 'samsung',   1002),
(18, '2025-04-10', 9,  18, 'samsung',   1003),
(19, '2025-04-15', 10, 19, 'nestlé',    1004),
(20, '2025-04-20', 10, 20, 'nestlé',    1005),
(21, '2025-05-01', 11, 1,  'volkswagen',1006),
(22, '2025-05-05', 12, 3,  'renner',    1007),
(23, '2025-05-10', 13, 5,  'amazon',    1008),
(24, '2025-05-15', 14, 7,  'cea',       1009),
(25, '2025-05-20', 15, 9,  'samsung',   1010);

-- =====================================================
-- CUSTOS EXTRAS
-- =====================================================
INSERT INTO custos_extras (id_processo, id_viagem, avarias, lavagem_container, armazenagem, dta, demurrage_dias, demurrage_custo) VALUES
(1,  1,  8500.00,  1200.00, 15600.00, 3200.00, 8,  9600.00),
(2,  1,  0.00,     800.00,  7200.00,  1500.00, 3,  3600.00),
(3,  2,  12300.00, 1500.00, 22400.00, 4800.00, 12, 14400.00),
(4,  2,  3200.00,  900.00,  9800.00,  2100.00, 5,  6000.00),
(5,  3,  0.00,     600.00,  5400.00,  1200.00, 2,  2400.00),
(6,  3,  7800.00,  1100.00, 18200.00, 3900.00, 9,  10800.00),
(7,  4,  4500.00,  750.00,  11000.00, 2400.00, 6,  7200.00),
(8,  4,  18700.00, 2200.00, 34800.00, 7200.00, 15, 18000.00),
(9,  5,  2100.00,  500.00,  6800.00,  1400.00, 3,  3600.00),
(10, 5,  9200.00,  1300.00, 19600.00, 4100.00, 10, 12000.00),
(11, 6,  0.00,     400.00,  4200.00,  900.00,  1,  1200.00),
(12, 6,  5600.00,  850.00,  13200.00, 2800.00, 7,  8400.00),
(13, 7,  14200.00, 1800.00, 28400.00, 6000.00, 13, 15600.00),
(14, 7,  1200.00,  600.00,  8600.00,  1800.00, 4,  4800.00),
(15, 8,  6700.00,  950.00,  16800.00, 3500.00, 8,  9600.00),
(16, 8,  0.00,     700.00,  6200.00,  1300.00, 2,  2400.00),
(17, 9,  3800.00,  650.00,  9400.00,  2000.00, 4,  4800.00),
(18, 9,  11500.00, 1600.00, 23800.00, 5000.00, 11, 13200.00),
(19, 10, 900.00,   450.00,  5600.00,  1100.00, 2,  2400.00),
(20, 10, 7300.00,  1050.00, 17400.00, 3600.00, 8,  9600.00),
(21, 11, 4100.00,  700.00,  10800.00, 2200.00, 5,  6000.00),
(22, 12, 0.00,     550.00,  5000.00,  1000.00, 1,  1200.00),
(23, 13, 9800.00,  1400.00, 21200.00, 4400.00, 10, 12000.00),
(24, 14, 2600.00,  600.00,  8400.00,  1700.00, 4,  4800.00),
(25, 15, 15300.00, 2000.00, 31600.00, 6600.00, 14, 16800.00);