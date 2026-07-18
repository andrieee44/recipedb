CREATE TABLE api.recipes_ingredients (
    recipe_ingredient_id UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    recipe_id            UUID    NOT NULL,
    name                 TEXT    NOT NULL,
    unit                 TEXT    NOT NULL,
    amount               NUMERIC NOT NULL CHECK (amount > 0),

	UNIQUE (recipe_id, name),

	FOREIGN KEY (recipe_id)
		REFERENCES api.recipes(recipe_id)
		ON DELETE CASCADE
);

ALTER TABLE api.recipes_ingredients ENABLE ROW LEVEL SECURITY;

CREATE POLICY any_select_recipes_ingredients ON api.recipes_ingredients
	FOR SELECT
	TO anon, authenticated
	USING (TRUE);

CREATE POLICY owner_all_recipes_ingredients ON api.recipes_ingredients
	FOR ALL
	TO authenticated
	USING (auth.owns_recipe(recipe_id) OR auth.is_admin())
	WITH CHECK (auth.owns_recipe(recipe_id) OR auth.is_admin());

GRANT SELECT ON api.recipes_ingredients TO anon;

GRANT SELECT,
	INSERT (recipe_id, name, unit, amount),
	UPDATE (name, unit, amount),
	DELETE
	ON api.recipes_ingredients TO authenticated;
