extends Resource
class_name GameState

signal turn_added(turn)
signal turn_erased(turn)
signal turn_part_added(turn, part)
signal turn_part_erased(turn, part)

export (Resource) var board
export (Array, Resource) var timeline
export (Array, Resource) var sides

var current_turn_index: int = 0


func add_turn(turn: Turn) -> void:
	timeline.append(turn)
	turn.num = timeline.size() - 1
	#warning-ignore:return_value_discarded
	turn.connect("part_added", self, "_on_turn_part_added")
	#warning-ignore:return_value_discarded
	turn.connect("part_erased", self, "_on_turn_part_erased")
	emit_signal("turn_added", turn)


func erase_turn(turn: Turn) -> void:
	timeline.erase(turn)
	turn.num = turn.NOT_IN_TIMELINE_NUM
	emit_signal("turn_erased", turn)


func get_turn(i: int) -> Turn:
	return timeline[i] as Turn


func set_turn(i: int, turn: Turn) -> void:
	timeline[i] = turn


func get_turn_index(turn: Turn) -> int:
	return timeline.find(turn)


func has_turn(turn: Turn) -> bool:
	return get_turn_index(turn) != -1


func _on_turn_part_added(turn: Turn, part: Part):
	emit_signal("turn_part_added", turn, part)


func _on_turn_part_erased(turn: Turn, part: Part):
	emit_signal("turn_part_erased", turn, part)
