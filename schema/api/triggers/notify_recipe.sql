CREATE FUNCTION api.notify_insert_recipe() RETURNS TRIGGER
AS $$
	BEGIN
		INSERT INTO api.notifications (user_id, type, recipe_id)
		VALUES (NEW.user_id, 'recipe_new', NEW.recipe_id);

		INSERT INTO api.notifications (user_id, type, recipe_id)
		SELECT user_id, 'following_recipe_new', NEW.recipe_id
		FROM api.users_follows
		WHERE followed_user_id = NEW.user_id;

		RETURN NEW;
	END;
$$
	LANGUAGE PLPGSQL
	SECURITY DEFINER
	SET search_path = public;

CREATE TRIGGER trg_notify_insert_recipe
	AFTER INSERT ON api.recipes
	FOR EACH ROW
	EXECUTE FUNCTION api.notify_insert_recipe();
