CREATE TABLE api.recipes (
	recipe_id            UUID             PRIMARY KEY DEFAULT gen_random_uuid(),
	user_id              UUID             NOT NULL,
	title                VARCHAR(255)     NOT NULL,
	content              TEXT             NOT NULL,
	thumbnail_image_hash TEXT             NOT NULL,
	difficulty           difficulty_level NOT NULL,

	FOREIGN KEY (user_id)
		REFERENCES users(user_id)
		ON DELETE CASCADE
);

ALTER TABLE api.recipes ENABLE ROW LEVEL SECURITY;

CREATE POLICY any_select_recipes ON api.recipes
	FOR SELECT
	TO anon, authenticated
	USING (TRUE);

CREATE POLICY owner_all_recipes ON api.recipes
	FOR ALL
	TO authenticated
	USING (user_id = auth.user_id() OR auth.is_admin())
	WITH CHECK (user_id = auth.user_id() OR auth.is_admin());

GRANT SELECT ON api.recipes TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON api.recipes TO authenticated;
