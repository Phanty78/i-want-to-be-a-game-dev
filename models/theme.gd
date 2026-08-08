class_name GameTheme

var theme_name : String
var genre_affinity : GenreAffinity

func _init(new_name: String) -> void:
	theme_name = new_name
	genre_affinity = GenreAffinity.new()
