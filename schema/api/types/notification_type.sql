CREATE TYPE api.notification_type AS ENUM (
	'follower_new',
	'following_recipe_new',
	'recipe_comment_new',
	'recipe_comment_reply',
	'recipe_comment_voted',
	'recipe_new',
	'recipe_voted'
);
