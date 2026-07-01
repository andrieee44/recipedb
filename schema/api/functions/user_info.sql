CREATE FUNCTION api.user_info(target_id UUID) RETURNS TABLE (
    first_name  VARCHAR,
    last_name   VARCHAR,
    middle_name VARCHAR
) AS $$
    SELECT user_id, first_name, last_name
    FROM users
    WHERE user_id = target_id;
$$
    LANGUAGE SQL
    SECURITY DEFINER
    SET search_path = public
    STABLE;

GRANT EXECUTE ON FUNCTION api.user_info TO anon, authenticated;
