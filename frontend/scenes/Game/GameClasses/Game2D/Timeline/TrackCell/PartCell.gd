tool
extends MarginContainer

export (Color) var color = Color.white setget set_color


func set_color(val):
	if not is_inside_tree():
		yield(self, "ready")
	$ColorRect.color = val
