class_name Studio

var money := 10_000
var rent_cost := 500
var life_cost := 250

var finished_games: Array[Game] = []
var game_in_development: Game

func get_monthly_studio_cost() -> int:
	return rent_cost + life_cost