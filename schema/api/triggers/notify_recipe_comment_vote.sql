CREATE FUNCTION api.notify_recipe_comment_vote() RETURNS TRIGGER
AS $$
	BEGIN
		INSERT INTO api.notifications (user_id, type, actor_user_id)
		SELECT user_id, 'recipe_comment_voted', NEW.user_id
		FROM api.recipes_comments
		WHERE comment_id = NEW.comment_id
			AND user_id != NEW.user_id
			AND (TG_OP = 'INSERT' OR OLD.upvote IS DISTINCT FROM NEW.upvote);

		RETURN NEW;
	END;
$$
	LANGUAGE PLPGSQL
	SECURITY DEFINER
	SET search_path = public;

CREATE TRIGGER trg_notify_recipe_comment_vote
	AFTER INSERT OR UPDATE ON api.recipes_comments_votes
	FOR EACH ROW
	EXECUTE FUNCTION api.notify_recipe_comment_vote();
