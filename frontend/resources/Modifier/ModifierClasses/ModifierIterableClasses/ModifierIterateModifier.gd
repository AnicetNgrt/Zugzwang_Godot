extends ModifierIterable
class_name ModifierIterateModifier

export (Resource) var modifier
export (int) var count = 0
var iterations = []


func execute(game) -> void:
	for i in range(0, count):
		iterations.append(modifier.copy())
		iterations[i].set_iteration(i)
		game.add_modifier_to_queue(iterations[i])
	#put at the end
	.execute(game)


func undo(game) -> void:
	for i in range(count - 1, -1, -1):
		var iteration = iterations[i]
		iteration.undo()
	.undo(game)


func _get_future_desc() -> String:
	return ""


func _get_past_desc() -> String:
	return ""


func get_debug_string() -> String:
	return (
		.get_debug_string()
		+ "Iterate over \""
		+ modifier.get_debug_string()
		+ "\" "
		+ str(count)
		+ " times"
	)
