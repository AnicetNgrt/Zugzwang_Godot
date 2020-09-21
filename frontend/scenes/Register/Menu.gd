extends Control

onready var main_menu = $Scalable/MainMenu
onready var register_form = $Scalable/RegisterForm
onready var login_form = $Scalable/LoginForm
onready var neutral_popup = $Scalable/NeutralPopup
onready var error_popup = $Scalable/ErrorPopup
onready var ping_request = $Requests/PingRequest
onready var erase_background_anim = $Animations/EraseBackground
onready var back_menu_button = $Scalable/BackMenuButton

var connected = false

func _on_BUOnline_pressed():
	var err = ping_request.send({})
	yield(ping_request, "request_completed")
	if connected:
		main_menu.hide()
		register_form.show()
		back_menu_button.show()
		erase_background_anim.play("main")
	else:
		error_popup.show()
		error_popup.get_node("CenterContainer/Rows/Message").text = "Connection to the service failed. Please try again later."

func _on_PingRequest_request_completed(result, response_code, headers, body):
	if result == 0 and response_code == 200:
		connected = true
	else:
		connected = false

func _on_BackMenuButton_pressed():
	register_form.hide()
	main_menu.show()
	back_menu_button.hide()
	erase_background_anim.play_backwards("main")
	ApiConfig.load_config()

func _on_login_success(remember):
	if remember:
		ApiConfig.save_config()
	else:
		var password = ""+ApiConfig.password
		var username = ""+ApiConfig.username
		ApiConfig.password = ""
		ApiConfig.username = ""
		ApiConfig.save_config()
		ApiConfig.username = username
		ApiConfig.password = password
	
	login_form.hide()
	register_form.hide()
