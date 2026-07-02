CREATE FUNCTION api.user_info(target_id UUID) RETURNS TABLE (
    first_name           VARCHAR,
    last_name            VARCHAR,
    middle_name          VARCHAR,
    profile_picture_hash TEXT

) AS $$
    SELECT first_name, last_name, middle_name, profile_picture_hash
    FROM users
    WHERE user_id = target_id;
$$
    LANGUAGE SQL
    SECURITY DEFINER
    SET search_path = public
    STABLE;

GRANT EXECUTE ON FUNCTION api.user_info TO anon, authenticated;
