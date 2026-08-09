extends Node

var themes : Array[GameTheme] = ThemeData.create_themes()
var platforms : Array[Platform] = PlatformsData.create_platforms()
var genres : Array[Genre] = GenresData.create_genres()

var studio = Studio.new()
var game_calendar = GameCalendar.new()
var scoring = GameScoring.new()
var critics = GameCritics.new()

# Exprimé en semaine
var game_development_duration := 12
# TO-DO : plus tard ces variables changeront dans le temps en fonction de divers paramétre
var create_game_menu_open := false

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
@onready var game_released_modal: PopupPanel = $UI/UIRoot/GameReleasedModal
@onready var game_released_label: Label = $UI/UIRoot/GameReleasedModal/MarginContainer/VBoxContainer/GameRealeasedLabel
@onready var score_released_label: Label = $UI/UIRoot/GameReleasedModal/MarginContainer/VBoxContainer/ScoreLabel
@onready var game_released_critic_label: Label = $UI/UIRoot/GameReleasedModal/MarginContainer/VBoxContainer/CriticLabel
@onready var game_released_money_label: Label = $UI/UIRoot/GameReleasedModal/MarginContainer/VBoxContainer/MoneyGainLabel

func _ready() -> void:
	setup_theme_options()
	setup_platform_options()
	setup_genre_options()
	setup_theme_affinities()
	game_clock.start(game_calendar.WEEK_DURATION_SECONDS)
	update_hud()

func setup_theme_affinities() -> void:
	ThemeAffinityData.setup(themes, genres)

func _on_game_clock_timeout() -> void:
	game_calendar.advance_week()
	pay_monthly_studio_cost()
	game_calendar.advance_month()
	
	if studio.game_in_development != null:
		studio.game_in_development.game_remaining_development_time -= 1
		print(studio.game_in_development.game_remaining_development_time)
		if studio.game_in_development.game_remaining_development_time <= 0:
			release_game()
			studio.finished_games.append(studio.game_in_development)
			studio.game_in_development = null
			create_game_button.disabled = false
	
	if studio.money <= 0:
		game_clock.stop()
		display_bankrupcy_modal()
	update_hud()

func update_date_label() -> void:
	date_label.text = "Year %d - Month %s - Week %d" % [
		game_calendar.current_year,
		game_calendar.current_month.month_name,
		game_calendar.weeks_count_for_month
	]

func update_money_label() -> void:
	money_label.text = "Money: %d €" % studio.money

func update_hud() -> void:
	update_date_label()
	update_money_label()

func pay_monthly_studio_cost() -> void:
	# Ici le plus 1 permet d'anticiper. Car la valeur réelle ne change que lors de l'appel de la fonction advance_month
	if game_calendar.weeks_count_for_month + 1 > game_calendar.current_month.duration_in_weeks:
		studio.money -= studio.get_monthly_studio_cost()

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
	if not studio.game_in_development:
		create_game_menu_open = true
		action_menu.visible = false
		create_game_modal.popup_centered(Vector2i(500, 400))
		
func _on_create_game_modal_popup_hide() -> void:
	create_game_menu_open = false
	game_clock.paused = false

func setup_theme_options() -> void:
	for theme in themes:
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
		theme = themes[game_theme_select.selected]
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
		studio.game_in_development = game
		game_modal_error_message.text = ""
		game_name_input.text = ""
		create_game_modal.visible = false

func release_game() -> void:
	var game_note := scoring.get_game_note(studio.game_in_development)
	var game_critic := critics.get_game_critic(game_note)
	game_released_critic_label.text = game_critic
	game_released_label.text = "Your game %s has been released!" % studio.game_in_development.game_name
	score_released_label.text = "Score: %d/10" % game_note
	studio.money += 1000 * game_note
	game_released_money_label.text = "You earned %d $" % (1000 * game_note)
	game_clock.paused = true
	game_released_modal.popup_centered(Vector2i(500, 400))

func display_bankrupcy_modal() -> void:
	if studio.money <= 0:
		game_over_modal_label.text = "Game Over! You ran out of money."
	game_over_modal.popup_centered(Vector2i(320, 160))

func reset_game() -> void:
	game_calendar.current_week = 1
	game_calendar.weeks_count_for_month = 1
	game_calendar.current_month = game_calendar.months[0]
	game_calendar.current_month_index = 0
	game_calendar.current_year = 1
	studio.money = 10_000
	studio.game_in_development = null
	studio.finished_games.clear()
	game_clock.start(game_calendar.WEEK_DURATION_SECONDS)
	update_hud()

func _on_new_game_button_pressed() -> void:
	reset_game()
	game_over_modal.visible = false

func _on_game_released_modal_popup_hide() -> void:
	game_clock.paused = false
