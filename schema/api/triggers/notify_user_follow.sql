CREATE FUNCTION api.notify_insert_user_follow() RETURNS TRIGGER
AS $$
	BEGIN
		INSERT INTO api.notifications (user_id, type, actor_user_id)
		VALUES (NEW.followed_user_id, 'follower_new', NEW.user_id);

		RETURN NEW;
	END;
$$
	LANGUAGE PLPGSQL
	SECURITY DEFINER
	SET search_path = public;

CREATE TRIGGER trg_notify_insert_user_follow
	AFTER INSERT ON api.users_follows
	FOR EACH ROW
	EXECUTE FUNCTION api.notify_insert_user_follow();
