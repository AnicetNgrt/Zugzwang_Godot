extends Node2D

var data = []

func _ready():
	for i in range(0, 15):
		data.append([])
		for j in range(0, 10):
			data[i].append(1)

func _input(event):
	_handle_scroll()

func _handle_scroll():
	if Input.is_action_pressed("scroll_down"):
		scale.x = clamp(scale.x - 0.01, 0.1, 1)
		scale.y = scale.x * 0.7
	if Input.is_action_just_pressed("scroll_up"):
		scale.x = clamp(scale.x + 0.01, 0.1, 1)
		scale.y = scale.x * 0.7
