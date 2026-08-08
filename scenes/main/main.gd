extends Node

const WEEKS_PER_YEAR := 52
const WEEK_DURATION_SECONDS := 0.2
var months: Array[Month] = [
	Month.new("January", 5),
	Month.new("February", 4),
	Month.new("March", 4),
	Month.new("April", 4),
	Month.new("May", 5),
	Month.new("June", 4),
	Month.new("July", 4),
	Month.new("August", 5),
	Month.new("September", 4),
	Month.new("October", 5),
	Month.new("November", 4),
	Month.new("December", 4)
]

var game_themes: Array[GameTheme] = [
	GameTheme.new("Fantasy"),
	GameTheme.new("Science Fiction"),
	GameTheme.new("Medieval"),
	GameTheme.new("Cyberpunk"),
	GameTheme.new("Space"),
	GameTheme.new("Western"),
	GameTheme.new("Pirates"),
	GameTheme.new("Zombies"),
	GameTheme.new("Post-Apocalyptic"),
	GameTheme.new("Superheroes"),
	GameTheme.new("Espionage"),
	GameTheme.new("Crime"),
	GameTheme.new("Military"),
	GameTheme.new("Mythology"),
	GameTheme.new("Prehistory"),
	GameTheme.new("Steampunk"),
	GameTheme.new("School Life"),
	GameTheme.new("Business"),
	GameTheme.new("Ancient Egypt"),
	GameTheme.new("Underwater")
]

var platforms: Array[Platform] = [
	Platform.new("Magnavox Odyssey"),
	Platform.new("Fairchild Channel F"),
	Platform.new("Atari 2600"),
	Platform.new("Commodore PET"),
	Platform.new("Apple II"),
	Platform.new("TRS-80"),
	Platform.new("Magnavox Odyssey²"),
	Platform.new("Intellivision"),
	Platform.new("Atari 400"),
	Platform.new("Atari 800"),
	Platform.new("TI-99/4"),
	Platform.new("Sinclair ZX80"),
	Platform.new("Commodore VIC-20"),
	Platform.new("Sinclair ZX81"),
	Platform.new("IBM PC"),
	Platform.new("BBC Micro"),
	Platform.new("ZX Spectrum"),
	Platform.new("Commodore 64"),
	Platform.new("ColecoVision"),
	Platform.new("Atari 5200")
]

var genres: Array[Genre] = [
	Genre.new("Action"),
	Genre.new("Adventure"),
	Genre.new("RPG"),
	Genre.new("Strategy"),
	Genre.new("Simulation"),
	Genre.new("Casual"),
]

var current_week := 1
var weeks_count_for_month := 1
var current_month := months[0]
var current_month_index:= 0
var current_year := 1
var studio_money := 10_000
# Exprimé en semaine
var game_development_duration := 12
# TO-DO : plus tard ces variables changeront dans le temps en fonction de divers paramétre
var rent_cost := 500
var life_cost := 250
var create_game_menu_open := false
var finished_games : Array[Game]
var game_in_development : Game

@onready var date_label: Label = $UI/UIRoot/HUD/HBoxContainer/DateLabel
@onready var money_label: Label = $UI/UIRoot/HUD/HBoxContainer/MoneyLabel
@onready var game_clock: Timer = $GameClock
@onready var action_menu: PopupPanel = $UI/UIRoot/ActionMenu
@onready var create_game_modal: PopupPanel = $UI/UIRoot/CreateGameModal
@onready var game_name_input: LineEdit = $UI/UIRoot/CreateGameModal/MarginContainer/VBoxContainer/GameNameInput
@onready var game_theme_select: OptionButton = $UI/UIRoot/CreateGameModal/MarginContainer/VBoxContainer/ThemeSelect
@onready var game_genre_select: OptionButton = $UI/UIRoot/CreateGameModal/MarginContainer/VBoxContainer/GenreSelect
@onready var game_platform_select: OptionButton = $UI/UIRoot/CreateGameModal/MarginContainer/VBoxContainer/PlatformSelect
@onready var game_modal_error_message: Label = $UI/UIRoot/CreateGameModal/MarginContainer/VBoxContainer/ErrorMessage
@onready var create_game_button: Button = $UI/UIRoot/ActionMenu/MarginContainer/VBoxContainer/CreateGameButton
@onready var game_over_modal: PopupPanel = $UI/UIRoot/GameOverModal
@onready var game_over_modal_label: Label = $UI/UIRoot/GameOverModal/MarginContainer/VBoxContainer/GameOverMessage

func _ready() -> void:
	setup_theme_options()
	setup_platform_options()
	setup_genre_options()
	setup_theme_affinities()
	game_clock.start(WEEK_DURATION_SECONDS)
	update_hud()

func setup_theme_affinities() -> void:
	ThemeAffinityData.setup(game_themes, genres)

func _on_game_clock_timeout() -> void:
	current_week += 1
	
	update_current_month()

	if current_week > WEEKS_PER_YEAR:
		current_week = 1
		current_year += 1
	
	if game_in_development != null:
		game_in_development.game_remaining_development_time -= 1
		print(game_in_development.game_remaining_development_time)
		if game_in_development.game_remaining_development_time <= 0:
			release_game()
			finished_games.append(game_in_development)
			game_in_development = null
			create_game_button.disabled = false
	
	if studio_money <= 0:
		game_clock.stop()
		display_bankrupcy_modal()
	update_hud()

func update_date_label() -> void:
	date_label.text = "Year %d - Month %s - Week %d" % [
		current_year,
		current_month.month_name,
		weeks_count_for_month
	]

func update_money_label() -> void:
	money_label.text = "Money: %d €" % studio_money

func update_hud() -> void:
	update_date_label()
	update_money_label()

func get_monthly_studio_cost() -> int:
	return rent_cost + life_cost

func update_current_month() -> void:
	weeks_count_for_month += 1
	if weeks_count_for_month > current_month.duration_in_weeks:
		studio_money -= get_monthly_studio_cost()
		weeks_count_for_month = 1
		current_month_index+= 1
		if current_month_index> 11:
			current_month = months[0]
			current_month_index= 0
		else :
			current_month = months[current_month_index]

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if not action_menu.visible:
				open_action_menu()

func open_action_menu() -> void:
	game_clock.paused = true
	action_menu.popup_centered(Vector2i(320, 160))

func _on_action_menu_popup_hide() -> void:
	if not create_game_menu_open:
		game_clock.paused = false

func _on_create_game_button_pressed() -> void:
	if not game_in_development:
		create_game_menu_open = true
		action_menu.visible = false
		create_game_modal.popup_centered(Vector2i(500, 400))
		
func _on_create_game_modal_popup_hide() -> void:
	create_game_menu_open = false
	game_clock.paused = false

func setup_theme_options() -> void:
	for theme in game_themes:
		game_theme_select.add_item(theme.theme_name)

func setup_genre_options() -> void:
	for genre in genres:
		game_genre_select.add_item(genre.genre_name)

func setup_platform_options() -> void:
	for platform in platforms:
		game_platform_select.add_item(platform.platform_name)

func get_validated_game_name() -> String:
	var text_to_validate = game_name_input.text
	text_to_validate = text_to_validate.strip_edges()
	if text_to_validate.is_empty() :
		return ''
	return text_to_validate

func create_game() -> Game:
	var game_name := get_validated_game_name()
	var genre : Genre
	var theme : GameTheme
	var platform : Platform
	var error_messages : PackedStringArray
	if game_name.is_empty():
		error_messages.append("Your game must have a name.")
	if game_theme_select.selected == -1:
		error_messages.append("You must select a theme.")
	else:
		theme = game_themes[game_theme_select.selected]
	if game_genre_select.selected == -1:
		error_messages.append("You must select a genre.")
	else:
		genre = genres[game_genre_select.selected]
	if game_platform_select.selected == -1:
		error_messages.append("You must select a platform.")
	else:
		platform = platforms[game_platform_select.selected]
	if error_messages.is_empty():
		return Game.new(game_name,theme,genre,platform,game_development_duration)
	game_modal_error_message.text = "\n".join(error_messages)
	return null

func _on_create_button_pressed() -> void:
	var game := create_game()
	if game:
		create_game_button.disabled = true
		game_in_development = game
		game_modal_error_message.text = ""
		game_name_input.text = ""
		create_game_modal.visible = false

func release_game() -> void:
	var game_note := get_game_note(game_in_development)
	print("Game released with note: %d" % game_note)
	studio_money += 1000 * game_note
	print("Game release you gained %d $" % (1000 * game_note))

# Note finale = base aléatoire (1-10) bonus d'affinité thème/genre (0-4).
# Un couple très compatible peut grimper la note ; un couple mauvais reste sur la base.
func get_game_note(game: Game) -> int:
	var base := randi() % 10 + 1
	var affinity := game.game_theme.genre_affinity.get_affinity(game.game_genre)
	return clampi(base + affinity, 1, 10)

func display_bankrupcy_modal() -> void:
	if studio_money <= 0:
		game_over_modal_label.text = "Game Over! You ran out of money."
	game_over_modal.popup_centered(Vector2i(320, 160))
