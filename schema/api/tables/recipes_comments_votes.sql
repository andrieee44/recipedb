CREATE TABLE api.recipes_comments_votes (
	user_id    UUID    NOT NULL,
	comment_id UUID    NOT NULL,
	upvote     BOOLEAN NOT NULL,

	PRIMARY KEY (user_id, comment_id),

	FOREIGN KEY (user_id)
		REFERENCES users(user_id)
		ON DELETE CASCADE,

	FOREIGN KEY (comment_id)
		REFERENCES api.recipes_comments(comment_id)
		ON DELETE CASCADE
);

ALTER TABLE api.recipes_comments_votes ENABLE ROW LEVEL SECURITY;

CREATE POLICY any_select_recipes_comments_votes ON api.recipes_comments_votes
	FOR SELECT
	TO anon, authenticated
	USING (TRUE);

CREATE POLICY self_all_recipes_comments_votes ON api.recipes_comments_votes
	FOR ALL
	TO authenticated
	USING (user_id = auth.user_id())
	WITH CHECK (user_id = auth.user_id());

GRANT SELECT ON api.recipes_comments_votes TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON api.recipes_comments_votes
	TO authenticated;
