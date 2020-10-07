extends Control

signal request_logout()

onready var nameLabel = $TopLeft/Name

func refresh():
	nameLabel.text = "Welcome "+ApiConfig.username

func _on_ButtonLogout_pressed():
	emit_signal("request_logout")
