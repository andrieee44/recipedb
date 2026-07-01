-- THESE NEED TO BE RUN IMPERATIVELY
-- CREATE SCHEMA api;
-- GRANT CONNECT ON DATABASE recipedb TO authenticator, anon, authenticated;
-- GRANT USAGE ON SCHEMA api TO anon, authenticated;
-- ALTER DATABASE recipedb SET app.jwt_secret = 'your-long-random-secret';

CREATE TYPE difficulty_level AS ENUM (
	'Beginner',
	'Easy',
	'Intermediate',
	'Advanced',
	'Expert'
);

-- WARNING VIBE CODED LOGIN, SIGNUP WILL FIX WITH DEDICATED MICROSERVICE
-- PLAN TO USE SELF HOSTED SUPABASE AUTH OR SOMETHING ELSE
-- TODO SETUP A SECOND REVERSE PROXY TO DEAL WITH PORT STARVATION
-- NO DOCKER IS A PAIN
CREATE FUNCTION api.login(email TEXT, password TEXT)
RETURNS JSON AS $$
DECLARE
	_user      RECORD;
	_secret    TEXT := current_setting('app.jwt_secret');
	_alg_id    TEXT := 'sha256';
	_header    TEXT;
	_payload   TEXT;
	_signables TEXT;
	_signature TEXT;
	_token     TEXT;
BEGIN
	-- 1. look up user and check password
	SELECT * INTO _user FROM users WHERE users.email = login.email;
	IF _user IS NULL OR _user.password_hash != crypt(password, _user.password_hash) THEN
		RAISE EXCEPTION 'invalid credentials' USING ERRCODE = '28P01';
	END IF;
	-- 2. build JWT header (constant for HS256/JWT)
	_header := translate(
		encode(convert_to('{"alg":"HS256","typ":"JWT"}', 'utf8'), 'base64'),
		E'+/=\n', '-_'
	);
	-- 3. build JWT payload (claims)
	_payload := translate(
		encode(
			convert_to(
				json_build_object(
					'role', 'authenticated',
					'user_id', _user.user_id,
					'email', _user.email,
					'is_admin', _user.is_admin,
					'iat', extract(epoch FROM now())::INTEGER,
					'exp', extract(epoch FROM now() + INTERVAL '1 DAY')::INTEGER
				)::TEXT,
				'utf8'
			),
			'base64'
		),
		E'+/=\n', '-_'
	);
	-- 4. sign header.payload with HMAC-SHA256
	_signables := _header || '.' || _payload;
	_signature := translate(
		encode(hmac(_signables, _secret, _alg_id), 'base64'),
		E'+/=\n', '-_'
	);
	-- 5. assemble final token
	_token := _signables || '.' || _signature;
	RETURN json_build_object('token', _token);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

CREATE FUNCTION api.signup(email TEXT, password TEXT, first_name TEXT, last_name TEXT, middle_name TEXT DEFAULT NULL)
RETURNS VOID AS $$
DECLARE
	_existing  RECORD;
	_new_user  RECORD;
BEGIN
	-- 1. check for an existing account with this email
	SELECT * INTO _existing FROM users WHERE users.email = signup.email;
	IF _existing IS NOT NULL THEN
		RAISE EXCEPTION 'email already registered' USING ERRCODE = '23505';
	END IF;
	-- 2. basic sanity checks before we hit the DB constraints
	IF password IS NULL OR length(password) < 8 THEN
		RAISE EXCEPTION 'password must be at least 8 characters' USING ERRCODE = '22023';
	END IF;
	IF email IS NULL OR email NOT LIKE '%@%' THEN
		RAISE EXCEPTION 'invalid email' USING ERRCODE = '22023';
	END IF;
	-- 3. insert the new user with a bcrypt-hashed password
	INSERT INTO users (email, first_name, last_name, middle_name, password_hash)
	VALUES (
		signup.email,
		signup.first_name,
		signup.last_name,
		signup.middle_name,
		crypt(signup.password, gen_salt('bf'))
	)
	RETURNING * INTO _new_user;
	-- 4. return void
	RETURN;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, pg_temp;

\i tables/recipes.sql
\i tables/tags.sql
\i tables/favorite_recipes.sql
\i tables/recipes_comments.sql
\i tables/recipes_comments_votes.sql
\i tables/recipes_tags.sql
\i tables/users_recipe_votes.sql
\i functions/
