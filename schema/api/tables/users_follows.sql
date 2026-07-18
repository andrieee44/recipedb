CREATE TABLE api.users_follows (
    user_id          UUID NOT NULL,
    followed_user_id UUID NOT NULL CHECK (followed_user_id != user_id),

    PRIMARY KEY (user_id, followed_user_id),

	FOREIGN KEY (user_id)
		REFERENCES users(user_id)
		ON DELETE CASCADE,

	FOREIGN KEY (followed_user_id)
		REFERENCES users(user_id)
		ON DELETE CASCADE
);

ALTER TABLE api.users_follows ENABLE ROW LEVEL SECURITY;

CREATE POLICY all_select_users_follows ON api.users_follows
	FOR SELECT
	TO anon, authenticated
	USING (TRUE);

CREATE POLICY self_all_users_follows ON api.users_follows
	FOR ALL
	TO authenticated
	USING (user_id = auth.user_id())
	WITH CHECK (user_id = auth.user_id());

GRANT SELECT ON api.users_follows TO anon;
GRANT SELECT, INSERT, DELETE ON api.users_follows TO authenticated;

CREATE INDEX ON api.users_follows(followed_user_id);
