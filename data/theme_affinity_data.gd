class_name ThemeAffinityData

# Échelle d'affinité : 0 = aucune, 4 = parfaite
const SCORE_NONE := 0
const SCORE_LOW := 1
const SCORE_MEDIUM := 2
const SCORE_HIGH := 3
const SCORE_PERFECT := 4

# Peuple le champ genre_affinity de chaque thème.
# 20 thèmes × 6 genres = 120 couples.
static func setup(themes: Array[GameTheme], genres: Array[Genre]) -> void:
	# Table : nom_du_thème -> { nom_du_genre -> score 0-4 }
	var data : Dictionary = {
		"Fantasy": {"Action": SCORE_HIGH, "Adventure": SCORE_PERFECT, "RPG": SCORE_PERFECT, "Strategy": SCORE_HIGH, "Simulation": SCORE_MEDIUM, "Casual": SCORE_MEDIUM},
		"Science Fiction": {"Action": SCORE_PERFECT, "Adventure": SCORE_PERFECT, "RPG": SCORE_HIGH, "Strategy": SCORE_HIGH, "Simulation": SCORE_HIGH, "Casual": SCORE_MEDIUM},
		"Medieval": {"Action": SCORE_MEDIUM, "Adventure": SCORE_HIGH, "RPG": SCORE_PERFECT, "Strategy": SCORE_PERFECT, "Simulation": SCORE_MEDIUM, "Casual": SCORE_LOW},
		"Cyberpunk": {"Action": SCORE_PERFECT, "Adventure": SCORE_HIGH, "RPG": SCORE_PERFECT, "Strategy": SCORE_HIGH, "Simulation": SCORE_MEDIUM, "Casual": SCORE_MEDIUM},
		"Space": {"Action": SCORE_HIGH, "Adventure": SCORE_PERFECT, "RPG": SCORE_HIGH, "Strategy": SCORE_PERFECT, "Simulation": SCORE_PERFECT, "Casual": SCORE_MEDIUM},
		"Western": {"Action": SCORE_PERFECT, "Adventure": SCORE_PERFECT, "RPG": SCORE_MEDIUM, "Strategy": SCORE_MEDIUM, "Simulation": SCORE_LOW, "Casual": SCORE_MEDIUM},
		"Pirates": {"Action": SCORE_HIGH, "Adventure": SCORE_PERFECT, "RPG": SCORE_HIGH, "Strategy": SCORE_HIGH, "Simulation": SCORE_MEDIUM, "Casual": SCORE_MEDIUM},
		"Zombies": {"Action": SCORE_PERFECT, "Adventure": SCORE_HIGH, "RPG": SCORE_MEDIUM, "Strategy": SCORE_HIGH, "Simulation": SCORE_MEDIUM, "Casual": SCORE_LOW},
		"Post-Apocalyptic": {"Action": SCORE_PERFECT, "Adventure": SCORE_HIGH, "RPG": SCORE_HIGH, "Strategy": SCORE_HIGH, "Simulation": SCORE_MEDIUM, "Casual": SCORE_LOW},
		"Superheroes": {"Action": SCORE_PERFECT, "Adventure": SCORE_HIGH, "RPG": SCORE_HIGH, "Strategy": SCORE_MEDIUM, "Simulation": SCORE_LOW, "Casual": SCORE_HIGH},
		"Espionage": {"Action": SCORE_HIGH, "Adventure": SCORE_HIGH, "RPG": SCORE_HIGH, "Strategy": SCORE_PERFECT, "Simulation": SCORE_HIGH, "Casual": SCORE_MEDIUM},
		"Crime": {"Action": SCORE_HIGH, "Adventure": SCORE_HIGH, "RPG": SCORE_HIGH, "Strategy": SCORE_HIGH, "Simulation": SCORE_MEDIUM, "Casual": SCORE_MEDIUM},
		"Military": {"Action": SCORE_PERFECT, "Adventure": SCORE_MEDIUM, "RPG": SCORE_HIGH, "Strategy": SCORE_PERFECT, "Simulation": SCORE_HIGH, "Casual": SCORE_LOW},
		"Mythology": {"Action": SCORE_HIGH, "Adventure": SCORE_PERFECT, "RPG": SCORE_PERFECT, "Strategy": SCORE_HIGH, "Simulation": SCORE_MEDIUM, "Casual": SCORE_MEDIUM},
		"Prehistory": {"Action": SCORE_HIGH, "Adventure": SCORE_HIGH, "RPG": SCORE_MEDIUM, "Strategy": SCORE_MEDIUM, "Simulation": SCORE_MEDIUM, "Casual": SCORE_LOW},
		"Steampunk": {"Action": SCORE_HIGH, "Adventure": SCORE_HIGH, "RPG": SCORE_HIGH, "Strategy": SCORE_HIGH, "Simulation": SCORE_MEDIUM, "Casual": SCORE_MEDIUM},
		"School Life": {"Action": SCORE_MEDIUM, "Adventure": SCORE_MEDIUM, "RPG": SCORE_HIGH, "Strategy": SCORE_MEDIUM, "Simulation": SCORE_HIGH, "Casual": SCORE_PERFECT},
		"Business": {"Action": SCORE_LOW, "Adventure": SCORE_LOW, "RPG": SCORE_MEDIUM, "Strategy": SCORE_PERFECT, "Simulation": SCORE_PERFECT, "Casual": SCORE_HIGH},
		"Ancient Egypt": {"Action": SCORE_MEDIUM, "Adventure": SCORE_PERFECT, "RPG": SCORE_HIGH, "Strategy": SCORE_HIGH, "Simulation": SCORE_MEDIUM, "Casual": SCORE_MEDIUM},
		"Underwater": {"Action": SCORE_HIGH, "Adventure": SCORE_PERFECT, "RPG": SCORE_HIGH, "Strategy": SCORE_MEDIUM, "Simulation": SCORE_HIGH, "Casual": SCORE_MEDIUM},
	}

	# Vérifie que chaque thème a bien ses données (bug de config sinon).
	for theme in themes:
		assert(data.has(theme.theme_name), "Missing affinity data for theme: %s" % theme.theme_name)

	# Remplit l'objet GenreAffinity de chaque thème.
	for theme in themes:
		var theme_data : Dictionary = data[theme.theme_name]
		for genre in genres:
			var score : int = theme_data.get(genre.genre_name, SCORE_NONE)
			theme.genre_affinity.set_affinity(genre, score)