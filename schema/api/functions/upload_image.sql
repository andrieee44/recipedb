CREATE FUNCTION api.upload_image(image_data BYTEA) RETURNS TEXT
AS $$
    DECLARE
        computed_hash TEXT := encode(digest(image_data, 'sha256'), 'hex');
    BEGIN
        INSERT INTO images (hash, data)
        VALUES (computed_hash, image_data)
        ON CONFLICT (hash) DO NOTHING;

        RETURN computed_hash;
    END;
$$
    LANGUAGE PLPGSQL
    SECURITY DEFINER;
