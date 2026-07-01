CREATE FUNCTION auth.owns_recipe(target_recipe_id UUID) RETURNS BOOLEAN
AS $$
	SELECT EXISTS (
		SELECT 1
		FROM api.recipes AS r
		WHERE r.recipe_id = target_recipe_id
			AND r.user_id = auth.user_id()
	)
$$
	LANGUAGE SQL
	STABLE;

GRANT EXECUTE ON FUNCTION auth.owns_recipe TO authenticated;
