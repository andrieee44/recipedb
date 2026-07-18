CREATE FUNCTION api.notify_insert_recipe_comment() RETURNS TRIGGER
AS $$
	BEGIN
		INSERT INTO api.notifications (user_id, type, comment_id)
		SELECT r.user_id, 'recipe_comment_new', NEW.comment_id
		FROM api.recipes AS r
		WHERE r.recipe_id = NEW.recipe_id
			AND r.user_id != NEW.user_id
			AND NOT EXISTS (
				SELECT 1
				FROM api.recipes_comments AS rc
				WHERE rc.comment_id = NEW.parent_comment_id
					AND rc.user_id = r.user_id
			);

		INSERT INTO api.notifications (user_id, type, comment_id)
		SELECT user_id, 'recipe_comment_reply', NEW.comment_id
		FROM api.recipes_comments
		WHERE comment_id = NEW.parent_comment_id AND user_id != NEW.user_id;

		RETURN NEW;
	END;
$$
	LANGUAGE PLPGSQL
	SECURITY DEFINER
	SET search_path = public;

CREATE TRIGGER trg_notify_insert_recipe_comment
	AFTER INSERT ON api.recipes_comments
	FOR EACH ROW
	EXECUTE FUNCTION api.notify_insert_recipe_comment();
