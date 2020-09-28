extends Control

onready var tb_username = $Body/Margin/Parts/Fields/Boxes/TBUsername
onready var tb_pswd = $Body/Margin/Parts/Fields/Boxes/TBPassword
onready var to_remember = $Body/Margin/Parts/RememberMe/Toggle
onready var token_request = $Requests/TokenRequest
onready var error = $Error

signal login_success(remember)
signal goto_register

var initial_pos = null


func _process(delta):
	if not initial_pos:
		initial_pos = rect_position


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _input(event):
	if event is InputEventMouseMotion:
		_mouse_anim(event.position)


func _mouse_anim(mouse_pos: Vector2):
	if initial_pos:
		rect_position = initial_pos + (0.05 * (mouse_pos - rect_position))


func _on_BURegister_pressed():
	emit_signal("goto_register")


func _on_BUContinue_pressed():
	error.hide()
	token_request.send({}, tb_username.text, tb_pswd.text)


func _on_TokenRequest_request_completed(result, response_code, headers, body):
	if result != 0:
		error.show()
		error.text = "Connection failed, try later."
		return

	if response_code != 200:
		error.show()
		error.text = "Wrong username or wrong password."
		return

	ApiConfig.username = tb_username.text
	ApiConfig.password = tb_pswd.text
	ApiConfig.token = JSON.parse(body.get_string_from_utf8()).result["token"]
	emit_signal("login_success", to_remember.on)
