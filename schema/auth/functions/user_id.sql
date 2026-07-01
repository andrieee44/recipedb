CREATE FUNCTION auth.user_id() RETURNS UUID
AS $$
	SELECT (
		current_setting('request.jwt.claims', true)::JSON->>'user_id'
	)::UUID
$$
	LANGUAGE SQL
	STABLE;

GRANT EXECUTE ON FUNCTION auth.user_id TO anon, authenticated;
