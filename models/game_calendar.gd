class_name GameCalendar

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

var current_week := 1
var weeks_count_for_month := 1
var current_month := months[0]
var current_month_index:= 0
var current_year := 1
