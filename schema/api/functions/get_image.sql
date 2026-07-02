CREATE FUNCTION api.get_image(image_hash TEXT)
RETURNS "application/octet-stream"
AS $$
    SELECT data
    FROM images
    WHERE hash = image_hash;
$$
    LANGUAGE SQL
    SECURITY DEFINER
    SET search_path = public
    STABLE;

GRANT EXECUTE ON FUNCTION api.get_image TO anon, authenticated;
