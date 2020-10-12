extends AudioStreamPlayer2D


func _ready():
	var parent = get_parent()
	if parent is BaseButton:
		parent.connect("mouse_entered",self,"_on_parent_mouse_entered")

func _on_parent_mouse_entered():
	play()
