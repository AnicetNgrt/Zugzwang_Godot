extends Control

onready var main_menu = $Scalable/MainMenu
onready var register_form = $Scalable/RegisterForm
onready var neutral_popup = $Scalable/NeutralPopup
onready var error_popup = $Scalable/ErrorPopup
onready var ping_request = $Requests/PingRequest

var connected = false

func _on_BUOnline_pressed():
	#neutral_popup.show()
	var err = ping_request.send({})
	yield(ping_request, "request_completed")
	if connected:
		#neutral_popup.hide()
		main_menu.hide()
		register_form.show()
	else:
		error_popup.show()
		error_popup.get_node("CenterContainer/Rows/Message").text = "Connection to the service failed. Please try again later."

func _on_PingRequest_request_completed(result, response_code, headers, body):
	if result == 0 and response_code == 200:
		connected = true
	else:
		connected = false
