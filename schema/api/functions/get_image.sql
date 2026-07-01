CREATE FUNCTION api.get_image(image_hash TEXT) RETURNS "application/octet-stream"
AS $$
    SELECT data
    FROM images
    WHERE hash = image_hash;
$$
    LANGUAGE SQL
    STABLE;

GRANT EXECUTE ON FUNCTION api.get_image TO anon, authenticated;
