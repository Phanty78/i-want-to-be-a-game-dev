extends Node

const WEEKS_PER_YEAR := 52
const WEEK_DURATION_SECONDS := 7

var current_week := 1
var current_year := 1
var studio_money := 10_000

@onready var date_label: Label = $UI/UIRoot/HUD/HBoxContainer/DateLabel
@onready var money_label: Label = $UI/UIRoot/HUD/HBoxContainer/MoneyLabel
@onready var game_clock: Timer = $GameClock

func _ready() -> void:
	game_clock.start(WEEK_DURATION_SECONDS)
	update_hud()


func _on_game_clock_timeout() -> void:
	current_week += 1

	if current_week > WEEKS_PER_YEAR:
		current_week = 1
		current_year += 1

	update_hud()


func update_date_label() -> void:
	date_label.text = "Year %d - Week %d" % [
		current_year,
		current_week
	]


func update_money_label() -> void:
	money_label.text = "Money: %d €" % studio_money


func update_hud() -> void:
	update_date_label()
	update_money_label()
