extends Modifier


func execute(game) -> void:
	#put at the end
	.execute(game)


func undo(game) -> void:
	#put at the end
	.undo(game)


func _get_future_desc() -> String:
	return ""


func _get_past_desc() -> String:
	return ""


func get_debug_string() -> String:
	return .get_debug_string() + ""
