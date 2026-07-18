CREATE TABLE api.recipes_steps (
    recipe_step_id UUID   PRIMARY KEY DEFAULT gen_random_uuid(),
    recipe_id      UUID   NOT NULL,
    step           TEXT   NOT NULL,
    description    TEXT   NOT NULL,

	FOREIGN KEY (recipe_id)
		REFERENCES api.recipes(recipe_id)
		ON DELETE CASCADE
);

ALTER TABLE api.recipes_steps ENABLE ROW LEVEL SECURITY;

CREATE POLICY any_select_recipes_steps ON api.recipes_steps
	FOR SELECT
	TO anon, authenticated
	USING (TRUE);

CREATE POLICY owner_all_recipes_steps ON api.recipes_steps
	FOR ALL
	TO authenticated
	USING (auth.owns_recipe(recipe_id) OR auth.is_admin())
	WITH CHECK (auth.owns_recipe(recipe_id) OR auth.is_admin());

GRANT SELECT ON api.recipes_steps TO anon;

GRANT SELECT,
	INSERT (recipe_id, step, description),
	UPDATE (step, description),
	DELETE
	ON api.recipes_steps TO authenticated;
