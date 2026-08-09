class_name GenresData

static func create_genres() -> Array[Genre]:
    var genres: Array[Genre] = [
        Genre.new("Action"),
        Genre.new("Adventure"),
        Genre.new("RPG"),
        Genre.new("Strategy"),
        Genre.new("Simulation"),
	Genre.new("Casual"),
]
    return genres