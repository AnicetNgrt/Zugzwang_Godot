tool
extends Label

export (Color) var color = Color.white setget set_color


func set_color(val):
	color = val
	set("custom_colors/font_color", color)
