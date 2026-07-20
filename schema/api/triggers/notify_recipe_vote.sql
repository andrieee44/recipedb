CREATE FUNCTION api.notify_recipe_vote() RETURNS TRIGGER
AS $$
	BEGIN
		INSERT INTO api.notifications (user_id, type, actor_user_id, recipe_id)
		SELECT user_id, 'recipe_voted', NEW.user_id, NEW.recipe_id
		FROM api.recipes
		WHERE recipe_id = NEW.recipe_id
			AND user_id != NEW.user_id
			AND (TG_OP = 'INSERT' OR OLD.upvote IS DISTINCT FROM NEW.upvote);

		RETURN NEW;
	END;
$$
	LANGUAGE PLPGSQL
	SECURITY DEFINER
	SET search_path = public;

CREATE TRIGGER trg_notify_recipe_vote
	AFTER INSERT OR UPDATE ON api.recipes_votes
	FOR EACH ROW
	EXECUTE FUNCTION api.notify_recipe_vote();
