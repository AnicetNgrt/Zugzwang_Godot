extends Control

onready var main_menu = $Scalable/MainMenu
onready var register_form = $Scalable/RegisterForm
onready var login_form = $Scalable/LoginForm
onready var error_popup = $Scalable/ErrorPopup
onready var ping_request = $Requests/PingRequest
onready var login_request = $Requests/LoginRequest
onready var erase_background_anim = $Animations/EraseBackground
onready var back_menu_button = $Scalable/BackMenuButton
onready var logged_in_menu = $Scalable/LoggedInMenu

signal _login_attempt_end

var connected = false
var logged_in = false


func _ready():
	print(OS.get_user_data_dir())
	$Background/Tree/Root.grow()


func _on_BUOnline_pressed():
	var err = ping_request.send({})
	yield(ping_request, "request_completed")
	if ! connected:
		error_popup.show()
		error_popup.get_node("CenterContainer/Rows/Message").text = "Connection to the service failed. Please try again later."
		return

	if ApiConfig.remember:
		if ! logged_in:
			var username_or_token = ApiConfig.username
			if ApiConfig.token != '':
				username_or_token = ApiConfig.token
			try_login(username_or_token, ApiConfig.password)
			yield(self, "_login_attempt_end")
		if ! logged_in:
			try_login(ApiConfig.username, ApiConfig.password)
			yield(self, "_login_attempt_end")
		if ! logged_in:
			_show_login_form()
		else:
			erase_background_anim.play("main")
			yield(erase_background_anim, "animation_finished")
			_show_user_dashboard()
	else:
		_show_login_form()


func _show_user_dashboard():
	main_menu.hide()
	back_menu_button.show()
	logged_in_menu.show()
	logged_in_menu.refresh()


func _show_login_form():
	main_menu.hide()
	back_menu_button.show()
	erase_background_anim.play("main")
	yield(erase_background_anim, "animation_finished")
	login_form.show()


func try_login(username_or_token, password):
	var err = login_request.send({}, username_or_token, password)
	yield(login_request, "request_completed")
	if err:
		logged_in = false
	emit_signal("_login_attempt_end")


func _on_PingRequest_request_completed(result, response_code, headers, body):
	connected = response_code == 200 and result == 0


func _on_BackMenuButton_pressed():
	_show_main_menu()


func _show_main_menu():
	register_form.hide()
	login_form.hide()
	logged_in_menu.hide()
	main_menu.show()
	back_menu_button.hide()
	erase_background_anim.play_backwards("main")
	yield(erase_background_anim, "animation_finished")
	ApiConfig.load_config()


func _on_login_success(remember):
	print(remember)
	ApiConfig.remember = remember
	if remember:
		ApiConfig.save_config()
	else:
		var password = "" + ApiConfig.password
		var username = "" + ApiConfig.username
		ApiConfig.password = ""
		ApiConfig.username = ""
		ApiConfig.save_config()
		ApiConfig.username = username
		ApiConfig.password = password
	
	register_form.hide()
	login_form.hide()
	_show_user_dashboard()


func _on_LoginRequest_request_completed(result, response_code, headers, body):
	logged_in = response_code == 200 and result == 0


func _on_RegisterForm_goto_login():
	register_form.hide()
	login_form.show()


func _on_LoginForm_goto_register():
	login_form.hide()
	register_form.show()


func _on_BUQuit_pressed():
	get_tree().quit()


func _on_LoggedInMenu_request_logout():
	ApiConfig.password = ""
	ApiConfig.username = ""
	ApiConfig.token = ""
	ApiConfig.save_config()
	logged_in = false
	_show_main_menu()
