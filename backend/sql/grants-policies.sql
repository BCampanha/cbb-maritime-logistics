-- =====================================================
-- GRANT/POLICIES - SELECT
-- =====================================================

GRANT SELECT ON empresas, custos_extras, processos TO anon;
GRANT SELECT ON kpis_dashboard TO anon;
GRANT INSERT ON kpis_dashboard TO anon;
GRANT UPDATE ON kpis_dashboard TO anon;

ALTER TABLE kpis_dashboard DISABLE ROW LEVEL SECURITY;

CREATE POLICY "Permitir leitura pública empresas"
ON empresas
FOR SELECT
TO anon
USING (true);

CREATE POLICY "Permitir leitura pública custos_extras"
ON custos_extras
FOR SELECT
TO anon
USING (true);

CREATE POLICY "Permitir leitura pública processos"
ON processos
FOR SELECT
TO anon
USING (true);