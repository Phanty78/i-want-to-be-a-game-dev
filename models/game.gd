class_name Game

var game_name : String
var game_theme : GameTheme
var game_genre : Genre
var game_platform : Platform

func _init(new_name: String, new_theme: GameTheme, new_genre : Genre, new_platform: Platform) -> void:
	game_name = new_name
	game_theme = new_theme
	game_genre = new_genre
	game_platform = new_platform
