tool
extends Control

class_name PathernsUI_ScalableControl

var start_pos

export(float,0.1,10.0,0.01) var scale = 1 setget _set_scale
func _set_scale(value):
	if not is_inside_tree(): yield(self,"ready")
	scale = value
	rect_scale = Vector2(value,value)
	anchor_bottom = 1/scale
	anchor_right = 1/scale 

func _ready():
	start_pos = rect_position
