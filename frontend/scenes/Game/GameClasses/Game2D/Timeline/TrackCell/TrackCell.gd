tool
extends VBoxContainer

export (float) var fade_in_anim_duration = 0.1
export (float) var fade_out_anim_duration = 0.1
export (int) var num = -1 setget set_num
export (PoolColorArray) var parts = [] setget set_parts


func add_part(partColor: Color, append = true):
	if append:
		parts.append(partColor)
	var part = $"Parts/PartCell - proto".duplicate()
	part.color = partColor
	part.show()
	$Parts.add_child(part)


func remove_part(i: int):
	parts.remove(i)
	if i + 1 < $Parts.get_child_count():
		var part = $Parts.get_child(i + 1)
		$Parts.remove_child(part)
		part.queue_free()


func remove_last_part():
	parts.remove(parts.size() - 1)
	var part = $Parts.get_child($Parts.get_child_count() - 1)
	$Parts.remove_child(part)
	part.queue_free()


func fade_in(delay = 0):
	$Tween.interpolate_property(
		self,
		"modulate",
		Color(0, 0, 0, 0),
		Color(1, 1, 1, 1),
		fade_in_anim_duration,
		Tween.TRANS_SINE,
		Tween.EASE_OUT,
		delay
	)
	$Tween.start()


func fade_out(delay = 0):
	$Tween.interpolate_property(
		self,
		"modulate",
		Color(1, 1, 1, 1),
		Color(0, 0, 0, 0),
		fade_out_anim_duration,
		Tween.TRANS_SINE,
		Tween.EASE_OUT,
		delay
	)
	$Tween.start()


func set_num(val):
	if not is_inside_tree():
		yield(self, "ready")
	num = val
	$Banner/Num.text = str(val)


func set_parts(val):
	if not is_inside_tree():
		yield(self, "ready")
	for i in range(0, parts.size()):
		remove_last_part()
	parts = val
	for p in val:
		if p == null:
			add_part(Color.white, false)
		else:
			add_part(p, false)
