class_name GenreAffinity

var affinities : Dictionary[Genre, int] = {}

func set_affinity(genre: Genre, score: int) -> void:
	assert(score >= 0 and score <= 4, "Affinity score must be between 0 and 4")
	affinities[genre] = score

func get_affinity(genre: Genre) -> int:
	assert(affinities.has(genre), "Genre %s has no affinity " % genre.genre_name)
	return affinities[genre]
