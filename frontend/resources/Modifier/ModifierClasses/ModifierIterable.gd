extends Modifier
class_name ModifierIterable


func execute(game) -> void:
	#put at the end
	.execute(game)


func undo(game) -> void:
	#put at the end
	.undo(game)


# warning-ignore:unused_argument
func set_iteration(i: int) -> void:
	pass


func _get_future_desc() -> String:
	return ""


func _get_past_desc() -> String:
	return ""
