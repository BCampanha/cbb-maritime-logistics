-- =====================================================
-- PERMISSÕES
-- Permite que a chave anon leia os dados das tabelas usadas no dashboard
-- Não é seguro/confidencial, mas decidimos usar nesse projeto com dados fictícios
-- =====================================================

GRANT USAGE ON SCHEMA public TO anon;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;

ALTER TABLE empresas ENABLE ROW LEVEL SECURITY;
ALTER TABLE navios ENABLE ROW LEVEL SECURITY;
ALTER TABLE viagens ENABLE ROW LEVEL SECURITY;
ALTER TABLE etapas_viagem ENABLE ROW LEVEL SECURITY;
ALTER TABLE mercadorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE cotacoes_cliente ENABLE ROW LEVEL SECURITY;
ALTER TABLE processos ENABLE ROW LEVEL SECURITY;
ALTER TABLE custos_extras ENABLE ROW LEVEL SECURITY;
ALTER TABLE eventos_processo ENABLE ROW LEVEL SECURITY;

-- Policies: permite apenas leitura pública dos dados fictícios
CREATE POLICY "Leitura publica empresas"
ON empresas FOR SELECT
TO anon;

CREATE POLICY "Leitura publica navios"
ON navios FOR SELECT
TO anon;

CREATE POLICY "Leitura publica viagens"
ON viagens FOR SELECT
TO anon;

CREATE POLICY "Leitura publica etapas_viagem"
ON etapas_viagem FOR SELECT
TO anon;

CREATE POLICY "Leitura publica mercadorias"
ON mercadorias FOR SELECT
TO anon;

CREATE POLICY "Leitura publica cotacoes_cliente"
ON cotacoes_cliente FOR SELECT
TO anon;

CREATE POLICY "Leitura publica processos"
ON processos FOR SELECT
TO anon;

CREATE POLICY "Leitura publica custos_extras"
ON custos_extras FOR SELECT
TO anon;

CREATE POLICY "Leitura publica eventos_processo"
ON eventos_processo FOR SELECT
TO anon;;