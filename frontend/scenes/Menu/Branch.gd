tool
extends ColorRect

export(int) var height
export(bool) var _visible = false setget _set_visible

var die_count = 0

signal grown_up()
signal grown_down()

func _ready():
	randomize()
	pass

func on_parent_grown_up():
	grow()

func half_die():
	die_count += 1
	if die_count == 2:
		die_count = 0
		die()

func _set_visible(value):
	if not is_inside_tree(): yield(self, "ready")
	if value and not _visible:
		_visible = value
		grow()
	elif not value and _visible:
		_visible = value
		die()

func grow():
	var tween = Tween.new()
	var duration = (3 + (1/height))*0.5
	var easing = Tween.EASE_OUT
	var trans = Tween.TRANS_SINE
	if height == 1000:
		duration = rand_range(55,60);
		easing = Tween.EASE_IN_OUT
	if height == 50:
		duration += 1
		trans = Tween.TRANS_EXPO
	tween.interpolate_property(
		self, 
		"rect_size", 
		Vector2(rect_size.x, 0), 
		Vector2(rect_size.x, height), 
		duration,
		trans,
		easing
		)
	add_child(tween)
	tween.start()
	yield(tween, "tween_completed")
	remove_child(tween)
	tween.queue_free()
	
	emit_signal("grown_up")
	if Engine.is_editor_hint(): return
	if get_child_count() <= 0:
		# yield(get_tree().create_timer(rand_range(1, 10)), "timeout")
		die()
	else:
		for c in get_children():
			#yield(get_tree().create_timer(rand_range(0, 0.5)), "timeout")
			c.grow()

func die():
	var tween = Tween.new()
	var duration = (3 - (1/height))*0.2
	if height == 1000:
		duration = 10
	tween.interpolate_property(
		self, 
		"rect_size", 
		Vector2(rect_size.x, height), 
		Vector2(rect_size.x, 0), 
		duration,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
		)
	add_child(tween)
	tween.start()
	yield(tween, "tween_completed")
	remove_child(tween)
	tween.queue_free()
	
	emit_signal("grown_down")
	
	if Engine.is_editor_hint(): return
	if get_parent().has_method("half_die"):
		#yield(get_tree().create_timer(rand_range(0, 0.5)), "timeout")
		get_parent().half_die()
	else:
		yield(get_tree().create_timer(4), "timeout")
		grow()
