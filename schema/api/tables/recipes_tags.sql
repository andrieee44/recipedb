CREATE TABLE api.recipes_tags (
	recipe_id UUID NOT NULL,
	tag_id    UUID NOT NULL,

	PRIMARY KEY (recipe_id, tag_id),

	FOREIGN KEY (recipe_id)
		REFERENCES api.recipes(recipe_id)
		ON DELETE CASCADE,

	FOREIGN KEY (tag_id)
		REFERENCES api.tags(tag_id)
		ON DELETE CASCADE
);

ALTER TABLE api.recipes_tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY any_select_recipes_tags ON api.recipes_tags
	FOR SELECT
	TO anon, authenticated
	USING (TRUE);

CREATE POLICY owner_all_recipes_tags ON api.recipes_tags
	FOR ALL
	TO authenticated
	USING (auth.owns_recipe(recipe_id) OR auth.is_admin())
	WITH CHECK (auth.owns_recipe(recipe_id) OR auth.is_admin());

GRANT SELECT ON api.recipes_tags TO anon;
GRANT SELECT, INSERT, DELETE ON api.recipes_tags TO authenticated;
