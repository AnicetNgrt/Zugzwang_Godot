extends HBoxContainer

onready var tb_username = $Left/Body/Margin/Parts/Fields/Boxes/TBUsername
onready var tb_pswd1 = $Left/Body/Margin/Parts/Fields/Boxes/TBPassword
onready var tb_pswd2 = $Left/Body/Margin/Parts/Fields/Boxes/TBRepeat
onready var to_remember = $Left/Body/Margin/Parts/RememberMe/Toggle
onready var create_account_request = $Requests/CreateAccountRequest
onready var error = $Left/Error

signal login_success(remember)
signal goto_login

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
	create_account_request.send({"username": username, "password": pswd})


func _input(event):
	if event is InputEventMouseMotion:
		_mouse_anim(event.position)


func _mouse_anim(mouse_pos: Vector2):
	if initial_pos:
		rect_position = initial_pos + (0.05 * (mouse_pos - rect_position))


func _on_CreateAccountRequest_request_completed(result, response_code, headers, body):
	print(response_code)
	print(body.get_string_from_utf8())
	if result != 0:
		error.show()
		error.text = "Connection failed, retry later."
		return
	if response_code != 201:
		var reason = JSON.parse(body.get_string_from_utf8()).result["reason"]
		match reason:
			"USERNAME_TAKEN":
				reason = "This username is already taken"
		error.show()
		error.text = reason
		return
	ApiConfig.username = tb_username.text
	ApiConfig.password = tb_pswd1.text
	emit_signal("login_success", to_remember.on)


func _on_BULogin_pressed():
	emit_signal("goto_login")
