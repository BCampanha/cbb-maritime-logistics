-- =====================================================
-- GRANT/POLICIES - SELECT
-- =====================================================

GRANT SELECT ON empresa TO anon;

CREATE POLICY "Permitir leitura pública empresa"
ON empresa
FOR SELECT
TO anon
USING (true);