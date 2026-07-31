extends Node

const WEEKS_PER_YEAR := 52
const WEEK_DURATION_SECONDS := 0.2
var MONTHS: Array[Month] = [
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

var current_week := 1
var weeks_count_for_month := 1
var current_month := MONTHS[0]
var current_month_index:= 0
var current_year := 1
var studio_money := 10_000
# TO-DO : plus tard ces variables changeront dans le temps en fonction de divers paramétre
var rent_cost := 500
var life_cost := 250
var create_game_menu_open = false

@onready var date_label: Label = $UI/UIRoot/HUD/HBoxContainer/DateLabel
@onready var money_label: Label = $UI/UIRoot/HUD/HBoxContainer/MoneyLabel
@onready var game_clock: Timer = $GameClock
@onready var action_menu: PopupPanel = $UI/UIRoot/ActionMenu
@onready var create_game_modal: PopupPanel = $UI/UIRoot/CreateGameModal
@onready var game_name_input: LineEdit = $UI/UIRoot/CreateGameModal/GameNameInput

func _ready() -> void:
	game_clock.start(WEEK_DURATION_SECONDS)
	update_hud()

func _on_game_clock_timeout() -> void:
	current_week += 1
	
	update_current_month()

	if current_week > WEEKS_PER_YEAR:
		current_week = 1
		current_year += 1
		
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
			current_month = MONTHS[0]
			current_month_index= 0
		else :
			current_month = MONTHS[current_month_index]

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
	create_game_menu_open = true
	action_menu.visible = false
	create_game_modal.popup_centered(Vector2i(320, 160))

func _on_create_game_modal_popup_hide() -> void:
	create_game_menu_open = false
	game_clock.paused = false
