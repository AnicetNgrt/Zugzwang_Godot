extends Resource
class_name Turn

signal part_added(part)
signal part_erased(part)

const NOT_IN_TIMELINE_NUM = -1

export (Array, Resource) var parts
export (int) var num = NOT_IN_TIMELINE_NUM


func add_part(part: Part) -> void:
	parts.append(part)
	emit_signal("part_added", part)


func erase_part(part: Part) -> void:
	parts.erase(part)
	emit_signal("part_erased", part)


func get_part(i: int) -> Turn:
	return parts[i] as Turn


func set_part(i: int, turn: Part) -> void:
	parts[i] = turn


func get_part_index(part: Part) -> int:
	return parts.find(part)


func has_part(part: Part) -> bool:
	return get_part_index(part) != -1
