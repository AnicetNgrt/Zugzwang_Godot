extends HBoxContainer

onready var tb_username = $Left/Body/Margin/Parts/Fields/Boxes/TBUsername
onready var tb_pswd1 = $Left/Body/Margin/Parts/Fields/Boxes/TBPassword
onready var tb_pswd2 = $Left/Body/Margin/Parts/Fields/Boxes/TBRepeat
onready var to_remember = $Left/Body/Margin/Parts/Remember/Toggle
onready var error = $Left/Error

var initial_pos = null

func _process(delta):
	if not initial_pos:
		initial_pos = rect_position

func _on_BUContinue_pressed():
	error.hide()
	var username = tb_username.text
	var pswd = tb_pswd1.text
	var pswd_repeat = tb_pswd2.text
	if username.length() < 3:
		error.show()
		error.text = "Username too short (minimum 3 long)"
		return
	if pswd.length() < 6:
		error.show()
		error.text = "Password too short (minimum 6 long)"
		return
	if pswd != pswd_repeat:
		error.show()
		error.text = "Passwords didn't match"
		tb_pswd1.text = ""
		tb_pswd2.text = ""
		return
	

func _input(event):
   if event is InputEventMouseMotion:
	   _mouse_anim(event.position)

func _mouse_anim(mouse_pos:Vector2):
	if initial_pos:
		rect_position = initial_pos + (0.05 * (mouse_pos - rect_position))

func _on_CreateAccountRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
