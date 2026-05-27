-- =====================================================
-- CONSULTAS TESTE
-- =====================================================

SELECT * FROM empresas;
SELECT * FROM navios;
SELECT * FROM viagens;
SELECT * FROM mercadorias;
SELECT * FROM cotacoes_cliente;
SELECT * FROM processos;
SELECT * FROM custos_extras;

-- =====================================================
-- Consultar policies
-- =====================================================
SELECT *
FROM pg_policies;

-- =====================================================
-- Mais alguma consultas
-- =====================================================

-- SELECT id_empresa, nome FROM empresas;
-- SELECT id_empresa, status, COUNT(*) FROM processos GROUP BY id_empresa, status ORDER BY id_empresa, status;
-- SELECT tipo_evento, status, COUNT(*) FROM eventos_processo GROUP BY tipo_evento, status ORDER BY tipo_evento, status;
-- SELECT p.id_empresa, SUM(c.demurrage_dias) AS dias_demurrage, SUM(c.demurrage_custo) AS custo_demurrage
-- FROM processos p
-- JOIN custos_extras c ON c.id_processo = p.id_processo
-- GROUP BY p.id_empresa
-- ORDER BY p.id_empresa;