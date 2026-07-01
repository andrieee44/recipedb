CREATE FUNCTION auth.is_admin() RETURNS BOOLEAN
AS $$
	SELECT COALESCE(
		(current_setting('request.jwt.claims')::JSON->>'is_admin')::BOOLEAN,
		FALSE
	)
$$
	LANGUAGE SQL
	STABLE;

GRANT EXECUTE ON FUNCTION auth.is_admin TO anon, authenticated;
