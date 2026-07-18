CREATE TABLE api.recipes_votes (
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

ALTER TABLE api.recipes_votes ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_select_recipes_votes ON api.recipes_votes
	FOR SELECT
	TO anon, authenticated
	USING (TRUE);

CREATE POLICY self_all_recipes_votes ON api.recipes_votes
	FOR ALL
	TO authenticated
	USING (user_id = auth.user_id())
	WITH CHECK (user_id = auth.user_id());

GRANT SELECT ON api.recipes_votes TO anon;

GRANT SELECT, INSERT, UPDATE (upvote), DELETE
	ON api.recipes_votes TO authenticated;
