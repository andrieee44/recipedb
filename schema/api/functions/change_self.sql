CREATE FUNCTION api.change_self(
    new_first_name  VARCHAR DEFAULT NULL,
    new_last_name   VARCHAR DEFAULT NULL,
    new_middle_name VARCHAR DEFAULT NULL
) RETURNS VOID
AS $$
    UPDATE public.users
    SET first_name  = COALESCE(new_first_name, first_name),
        last_name   = COALESCE(new_last_name, last_name),
        middle_name = COALESCE(new_middle_name, middle_name)
    WHERE user_id = auth.user_id();
$$
    LANGUAGE SQL
    SECURITY DEFINER
    SET search_path = public;

GRANT EXECUTE ON FUNCTION api.change_self TO authenticated;
