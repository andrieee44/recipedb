CREATE TABLE users (
	user_id              UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
	email                VARCHAR(320)  NOT NULL UNIQUE,
	first_name           VARCHAR(255)  NOT NULL,
	last_name            VARCHAR(255)  NOT NULL,
	password_hash        TEXT          NOT NULL,
	is_admin             BOOLEAN       NOT NULL DEFAULT FALSE,
	middle_name          VARCHAR(255),
	profile_picture_hash TEXT,

	FOREIGN KEY (profile_picture_hash)
		REFERENCES images(hash)
);
