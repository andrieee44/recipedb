CREATE TABLE api.tags (
	tag_id UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
	name   VARCHAR(255) NOT NULL
);

ALTER TABLE api.tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY any_select_tags ON api.tags
	FOR SELECT
	TO anon, authenticated
	USING (true);

CREATE POLICY admin_all_tags ON api.tags
	FOR ALL
	TO authenticated
	USING (auth.is_admin())
	WITH CHECK (auth.is_admin());

GRANT SELECT ON api.tags TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON api.tags TO authenticated;
