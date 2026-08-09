class_name GameScoring

# Note finale = base aléatoire (1-10) bonus d'affinité thème/genre (0-4).
# Un couple très compatible peut grimper la note ; un couple mauvais reste sur la base.
func get_game_note(game: Game) -> int:
	var base := randi() % 10 + 1
	var affinity := game.game_theme.genre_affinity.get_affinity(game.game_genre)
	return clampi(base + affinity, 1, 10)