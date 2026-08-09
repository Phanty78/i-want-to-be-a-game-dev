class_name ThemeData

static func create_themes() -> Array[GameTheme]:
    var themes: Array[GameTheme] = []
    for theme_name in [
        "Fantasy",
        "Science Fiction",
        "Medieval",
        "Cyberpunk",
        "Space",
        "Western",
        "Pirates",
        "Zombies",
        "Post-Apocalyptic",
        "Superheroes",
        "Espionage",
        "Crime",
        "Military",
        "Mythology",
        "Prehistory",
        "Steampunk",
        "School Life",
        "Business",
        "Ancient Egypt",
        "Underwater"
    ]:
            themes.append(GameTheme.new(theme_name))
    return themes