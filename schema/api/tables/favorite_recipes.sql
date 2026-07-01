CREATE TABLE api.favorite_recipes (
    user_id   UUID NOT NULL,
    recipe_id UUID NOT NULL,

    PRIMARY KEY (user_id, recipe_id),

	FOREIGN KEY (user_id)
		REFERENCES users(user_id)
		ON DELETE CASCADE,

	FOREIGN KEY (recipe_id)
		REFERENCES api.recipes(recipe_id)
		ON DELETE CASCADE
);

ALTER TABLE api.favorite_recipes ENABLE ROW LEVEL SECURITY;

CREATE POLICY self_all_favorite_recipes ON api.favorite_recipes
	FOR ALL
	TO authenticated
	USING (user_id = auth.user_id())
	WITH CHECK (user_id = auth.user_id());

GRANT SELECT, INSERT, UPDATE, DELETE ON api.favorite_recipes TO authenticated;
