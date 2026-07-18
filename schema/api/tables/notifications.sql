CREATE TABLE api.notifications (
	notification_id UUID                  PRIMARY KEY DEFAULT gen_random_uuid(),
	user_id         UUID                  NOT NULL,
	type            api.notification_type NOT NULL,
	created_at      TIMESTAMPTZ           NOT NULL DEFAULT now(),
	recipe_id       UUID,
	comment_id      UUID,
	actor_user_id   UUID,

	FOREIGN KEY (user_id)
		REFERENCES users(user_id)
		ON DELETE CASCADE,

	FOREIGN KEY (recipe_id)
		REFERENCES api.recipes(recipe_id)
		ON DELETE CASCADE,

	FOREIGN KEY (comment_id)
		REFERENCES api.recipes_comments(comment_id)
		ON DELETE CASCADE,

	FOREIGN KEY (actor_user_id)
		REFERENCES users(user_id)
		ON DELETE CASCADE
);

ALTER TABLE api.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY self_all_notifications ON api.notifications
	FOR ALL
	TO authenticated
	USING (user_id = auth.user_id())
	WITH CHECK (user_id = auth.user_id());

GRANT SELECT, DELETE ON api.notifications TO authenticated;

CREATE INDEX ON api.notifications(user_id, created_at DESC);
