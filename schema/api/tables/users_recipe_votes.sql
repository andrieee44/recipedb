CREATE TABLE api.users_recipe_votes (
	user_id   UUID    NOT NULL,
	recipe_id UUID    NOT NULL,
	upvote    BOOLEAN NOT NULL,

	PRIMARY KEY (user_id, recipe_id),

	FOREIGN KEY (user_id)
		REFERENCES users(user_id)
		ON DELETE CASCADE,

	FOREIGN KEY (recipe_id)
		REFERENCES api.recipes(recipe_id)
		ON DELETE CASCADE
);

ALTER TABLE api.users_recipe_votes ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_select_users_recipe_votes ON api.users_recipe_votes
	FOR SELECT
	TO anon, authenticated
	USING (TRUE);

CREATE POLICY self_all_users_recipe_votes ON api.users_recipe_votes
	FOR ALL
	TO authenticated
	USING (user_id = auth.user_id())
	WITH CHECK (user_id = auth.user_id());

GRANT SELECT ON api.users_recipe_votes TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON api.users_recipe_votes
	TO authenticated;
