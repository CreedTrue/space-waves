extends Node

# An enum to define our colors. This is cleaner than using strings.
enum ColorType { RED, BLUE, GREEN }

# A list to help us pick a random color later
const COLOR_LIST = [ColorType.RED, ColorType.BLUE, ColorType.GREEN]

# A dictionary to map our enum to actual visual Color values
const COLOR_MAP = {
	ColorType.RED: Color.RED,
	ColorType.BLUE: Color.DODGER_BLUE,
	ColorType.GREEN: Color.LIME_GREEN
}
