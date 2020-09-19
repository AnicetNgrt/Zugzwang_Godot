extends Node
class_name Game

export (Resource) var gameState setget set_gameState
export (Array, Resource) var executionQueue
export (Array, Resource) var executedStack

var _is_last_modifier_executed: bool = true


# warning-ignore:unused_argument
func _process(delta):
	try_execute_queue_top_modifier()


func try_execute_modifier(modifier: Modifier) -> void:
	if _is_last_modifier_executed == true:
		_is_last_modifier_executed = false
		# warning-ignore:return_value_discarded
		modifier.connect("just_executed", self, "_on_modifier_just_executed")
		modifier.execute(self)


func try_execute_queue_top_modifier() -> void:
	if executionQueue.size() > 0:
		var modifier = executionQueue.pop_front()
		try_execute_modifier(modifier)


func add_modifier_to_queue(modifier: Modifier) -> void:
	executionQueue.push_back(modifier)


func _on_modifier_just_executed(modifier: Modifier) -> void:
	_is_last_modifier_executed = true
	print(modifier.get_debug_string())
	executedStack.push_back(modifier)
	try_execute_queue_top_modifier()


# warning-ignore:unused_argument
func _on_gameState_turn_added(turn: Turn) -> void:
	pass


# warning-ignore:unused_argument
func _on_gameState_turn_erased(turn: Turn) -> void:
	pass


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_gameState_turn_part_added(turn: Turn, part: Part) -> void:
	pass


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_gameState_turn_part_erased(turn: Turn, part: Part) -> void:
	pass


func set_gameState(val: GameState) -> void:
	gameState = val
	gameState.connect("turn_added", self, "_on_gameState_turn_added")
	gameState.connect("turn_erased", self, "_on_gameState_turn_erased")
	gameState.connect("turn_part_added", self, "_on_gameState_turn_part_added")
	gameState.connect("turn_part_erased", self, "_on_gameState_turn_part_erased")
