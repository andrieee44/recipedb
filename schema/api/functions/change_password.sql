CREATE FUNCTION api.change_password(new_password TEXT) RETURNS VOID
AS $$
    UPDATE public.users
    SET password_hash = crypt(new_password, gen_salt('bf'))
    WHERE user_id = auth.user_id();
$$
    LANGUAGE SQL
    SECURITY DEFINER
    SET search_path = public;

GRANT EXECUTE ON FUNCTION api.change_password TO authenticated;
