extends MarginContainer

export(bool) var on = false setget _set_on
func _set_on(value):
	on = value
	if on: 
		$On.show()
		$Off.hide()
	else:
		$Off.show()
		$On.hide()
	emit_signal("value_changed", on)

signal value_changed(value)

func _on_On_gui_input(event):
	print(event)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			self.on = false

func _on_Off_gui_input(event):
	print(event)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			self.on = true
