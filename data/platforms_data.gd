class_name PlatformsData

static func create_platforms() -> Array[Platform]:
    var platforms: Array[Platform] = []
    for platform_name in [
        "Magnavox Odyssey",
        "Fairchild Channel F",
        "Atari 2600",
        "Commodore PET",
        "Apple II",
        "TRS-80",
        "Magnavox Odyssey²",
        "Intellivision",
        "Atari 400",
        "Atari 800",
        "TI-99/4",
        "Sinclair ZX80",
        "Commodore VIC-20",
        "Sinclair ZX81",
        "IBM PC",
        "BBC Micro",
        "ZX Spectrum",
        "Commodore 64",
        "ColecoVision",
        "Atari 5200"
    ]:
            platforms.append(Platform.new(platform_name))
    return platforms