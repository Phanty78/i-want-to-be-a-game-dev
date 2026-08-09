class_name Game

var game_name : String
var game_theme : GameTheme
var game_genre : Genre
var game_platform : Platform
var game_remaining_development_time : int
var game_score : int
var game_critic : String

func _init(new_name: String, 
		   new_theme: GameTheme, 
		   new_genre : Genre, 
		   new_platform: Platform, 
		   new_remaining_development_time: int) -> void:
	game_name = new_name
	game_theme = new_theme
	game_genre = new_genre
	game_platform = new_platform
	game_remaining_development_time = new_remaining_development_time
