extends Node

export var websocket_url = "ws://192.168.1.14:3001"

var _client = WebSocketClient.new()

func _ready():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")

	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	print("Connected with protocol: ", proto)

func _on_data():
	var data = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8()).result
	print(data)
	match data.message:
		"Your id":
			_handle_my_id_received(data)
		"Joined room":
			_handle_room_joined(data)
		"Guest joined":
			_handle_player_joined(data)
		"Failed to join game":
			_handle_failed_to_join_game(data)

func _process(delta):
	_client.poll()

func _on_Create_pressed():
	_put_packet({"message": "create"})
	_hide_main_menu()
	_start_loading()

func _handle_my_id_received(data):
	LobbyManager.selfId = data.get("id")
	LobbyManager.username = data.get("name")
	$Control/MainMenu/Username.text = "Connected as: "+data.get("name")

func _handle_room_joined(data):
	LobbyManager.role = data.get("role")
	LobbyManager.lobby = {
		"id": data.get("gameId"),
		"guests": data.get("guests"),
		"spectators": data.get("spectators")
	}
	_stop_loading()
	_show_lobby()
	_handle_player_joined({"guestId": LobbyManager.selfId, "guestName": "Anonymous"})

func _handle_failed_to_join_game(data):
	_stop_loading()
	_show_error(data.message + ": " + data.reason)

func _handle_player_joined(data):
	LobbyManager.lobby.guests.push_back({
		"id": data.get("guestId"),
		"name": data.get("guestName")
	})

func _put_packet(data):
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())

func _show_main_menu():
	$Control/FooterCredits.show()
	$Control/MainMenu.show()

func _hide_main_menu():
	$Control/FooterCredits.hide()
	$Control/MainMenu.hide()

func _show_lobby():
	$Control/LobbyMenu.show()
	$Control/LobbyMenu.update_code()

func _hide_lobby():
	$Control/LobbyMenu.hide()

func _start_loading():
	$Control/Loading.show()

func _stop_loading():
	$Control/Loading.hide()

func _show_error(message):
	$Control/Error.show()
	$Control/Error/ErrorMessage.text = message

func _hide_error():
	$Control/Error.hide()

func _exit_tree():
	_client.disconnect_from_host(1000, "manual scene quit")

func _on_ButtonSetName_pressed():
	_put_packet({"message":"my name is", "name":$Control/MainMenu/ChooseName/LineEdit.text})

func _on_ButtonJoin_pressed():
	_put_packet({"message":"join as guest", "gameId":$Control/MainMenu/Join/LineEdit.text})
	_hide_main_menu()
	_start_loading()

func _on_ButtonBackError_pressed():
	_hide_error()
	_show_main_menu()
