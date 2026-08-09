class_name GameCritics

static func get_game_critic(score : int) -> String:
	assert(score >= 0 and score <= 11, "Score must be between 0 and 11")
	if score <= 3:
		return "Not bad for propping up a piece of furniture"
	if score <= 5:
		return "So-so..."
	if score <= 7:
		return "Not bad"
	if score <= 9:
		return "A mist!"
	return "A new benchmark in the genre!"