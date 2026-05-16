GRANT SELECT ON empresa TO anon;

CREATE POLICY "Permitir leitura pública da tabela empresa"
ON empresa
FOR SELECT
TO anon
USING (true);