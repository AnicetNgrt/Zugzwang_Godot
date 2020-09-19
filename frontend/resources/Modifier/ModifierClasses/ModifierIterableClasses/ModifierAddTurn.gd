extends ModifierIterable
class_name ModifierAddTurn

export (Resource) var turn = null


func execute(game) -> void:
	game.gameState.add_turn(turn)
	#put at the end
	.execute(game)


func undo(game) -> void:
	game.erase_turn(turn)
	#put at the end
	.undo(game)


func _get_future_desc() -> String:
	return TranslationServer.translate("ModifierAddTurnFuture").replace("<n>", turn.num)


func _get_past_desc() -> String:
	return TranslationServer.translate("ModifierAddTurnPast").replace("<n>", turn.num)


func get_debug_string() -> String:
	return .get_debug_string() + "Adding turn " + str(turn.num)


func copy() -> Modifier:
	var copy = duplicate()
	copy.turn = turn.duplicate()
	return copy
