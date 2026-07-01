CREATE FUNCTION api.self_info() RETURNS TABLE (
    email       VARCHAR,
    first_name  VARCHAR,
    last_name   VARCHAR,
    is_admin    BOOLEAN,
    middle_name VARCHAR
) AS $$
    SELECT email, first_name, last_name, is_admin, middle_name
    FROM users
    WHERE user_id = auth.user_id();
$$
    LANGUAGE SQL
    SECURITY DEFINER
    SET search_path = public
    STABLE;

GRANT EXECUTE ON FUNCTION api.self_info TO authenticated;
