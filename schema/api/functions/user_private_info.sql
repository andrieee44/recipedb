CREATE FUNCTION api.user_private_info() RETURNS TABLE (
    email       VARCHAR,
    is_admin    BOOLEAN
) AS $$
    SELECT email, is_admin
    FROM users
    WHERE user_id = auth.user_id();
$$
    LANGUAGE SQL
    SECURITY DEFINER
    SET search_path = public
    STABLE;

GRANT EXECUTE ON FUNCTION api.user_private_info TO authenticated;
