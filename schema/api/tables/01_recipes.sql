CREATE TABLE api.recipes (
	recipe_id            UUID                 PRIMARY KEY DEFAULT gen_random_uuid(),
	user_id              UUID                 NOT NULL,
	title                VARCHAR(255)         NOT NULL,
	description          TEXT                 NOT NULL,
	difficulty           api.difficulty_level NOT NULL,
	serving              INT                  NOT NULL CHECK (serving >= 1),
	prep_mins            INT                  NOT NULL CHECK (prep_mins >= 1),
	cook_mins            INT                  NOT NULL CHECK (cook_mins >= 1),
	created_at           TIMESTAMPTZ          NOT NULL DEFAULT now(),
	thumbnail_image_hash TEXT,

	FOREIGN KEY (user_id)
		REFERENCES users(user_id)
		ON DELETE CASCADE,

	FOREIGN KEY (thumbnail_image_hash)
		REFERENCES images(hash)
);

ALTER TABLE api.recipes ENABLE ROW LEVEL SECURITY;

CREATE POLICY any_select_recipes ON api.recipes
	FOR SELECT
	TO anon, authenticated
	USING (TRUE);

CREATE POLICY owner_all_recipes ON api.recipes
	FOR ALL
	TO authenticated
	USING (user_id = auth.user_id() OR auth.is_admin())
	WITH CHECK (user_id = auth.user_id() OR auth.is_admin());

GRANT SELECT ON api.recipes TO anon;

GRANT SELECT,
	INSERT (
		user_id,
		title,
		description,
		difficulty,
		serving,
		prep_mins,
		cook_mins,
		thumbnail_image_hash
	),
	UPDATE (
		title,
		description,
		difficulty,
		serving,
		prep_mins,
		cook_mins,
		thumbnail_image_hash
	),
	DELETE
	ON api.recipes TO authenticated;

CREATE INDEX ON api.recipes(created_at DESC);
