extends AudioStreamPlayer

func _ready():
	self.volume_db = AudioSettings.volume_db
	AudioSettings.connect("volume_db_changed",self,"_on_AudioSettings_volume_db_changed")

func _on_AudioSettings_volume_db_changed(val):
	volume_db = val

func _on_MusicPlayer_finished():
	play()
