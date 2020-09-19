extends Resource
class_name Modifier

signal just_executed(modifier)
signal just_undone(modifier)

export (bool) var silent = true

var executed = false


# warning-ignore:unused_argument
func execute(game) -> void:
	assert(not executed)
	executed = true
	emit_signal("just_executed", self)


# warning-ignore:unused_argument
func undo(game) -> void:
	assert(executed)
	executed = false
	emit_signal("just_undone", self)


func get_future_desc() -> String:
	if silent:
		return ""
	return _get_future_desc()


func _get_future_desc() -> String:
	return ""


func get_past_desc() -> String:
	if silent:
		return ""
	return _get_past_desc()


func _get_past_desc() -> String:
	return ""


func get_debug_string() -> String:
	return str(self) + " "


func copy() -> Modifier:
	return duplicate() as Modifier
