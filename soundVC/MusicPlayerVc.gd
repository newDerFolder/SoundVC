@icon("res://vcder/soundVC/sc/icon_MusicPlayer.png")
extends SoundPlayerVc

class_name MusicPlayerVc

@export var auto_replay:bool=true

func _vc_ready() -> void:
	super()
	connect("finished", Callable(self, "_on_playback_finished"))


func _on_playback_finished():
	if auto_replay:
		vc_play_sound()

func vc_set_paused(set_bool:bool)->void:
	stream_paused=set_bool
