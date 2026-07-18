CREATE TABLE api.recipes_comments (
	comment_id        UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
	recipe_id         UUID        NOT NULL,
	user_id           UUID        NOT NULL,
	content           TEXT        NOT NULL,
	created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
	parent_comment_id UUID,

	UNIQUE (comment_id, recipe_id),

	FOREIGN KEY (recipe_id)
		REFERENCES api.recipes(recipe_id)
		ON DELETE CASCADE,

	FOREIGN KEY (user_id)
		REFERENCES users(user_id)
		ON DELETE CASCADE,

	FOREIGN KEY (parent_comment_id, recipe_id)
		REFERENCES api.recipes_comments(comment_id, recipe_id)
		ON DELETE SET NULL (parent_comment_id)
);

ALTER TABLE api.recipes_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY any_select_recipes_comments ON api.recipes_comments
	FOR SELECT
	TO anon, authenticated
	USING (TRUE);

CREATE POLICY owner_all_recipes_comments ON api.recipes_comments
	FOR ALL
	TO authenticated
	USING (user_id = auth.user_id() OR auth.is_admin())
	WITH CHECK (user_id = auth.user_id() OR auth.is_admin());

GRANT SELECT ON api.recipes_comments TO anon;

GRANT SELECT,
	INSERT (recipe_id, user_id, content, parent_comment_id),
	UPDATE (content),
	DELETE
	ON api.recipes_comments TO authenticated;

CREATE INDEX ON api.recipes_comments(recipe_id, created_at DESC);
CREATE INDEX ON api.recipes_comments(parent_comment_id);
