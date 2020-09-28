extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if Input.is_action_pressed("scroll_down"):
		scale.x = clamp(scale.x - 0.01, 0.1, 1)
		scale.y = scale.x * 0.7
	if Input.is_action_just_pressed("scroll_up"):
		scale.x = clamp(scale.x + 0.01, 0.1, 1)
		scale.y = scale.x * 0.7
