@icon("res://vcder/soundVC/sc/icon_SoundPlayer2D.png")
extends AudioStreamPlayer2D

class_name SoundPlayerVc2D

enum PLAY_MODE{RANDOM = 0, SEQUENTIAL = 1, SET_RANDOM = 2, SMART_RANDOM = 3}

@export var sounds_stream: Array[AudioStream]
@export var play_mode: PLAY_MODE = PLAY_MODE.SET_RANDOM
@export var auto_shuffle: bool = true
#@export_group("SMART_RANDOM_MODE")
#@export var set_range:int=5


var play_id = -1
var played_id_set: Array = []

func _ready() -> void:
	match play_mode:
		PLAY_MODE.SET_RANDOM:
			shuffle_set()

func shuffle_set():
	played_id_set.clear()
	for i in range(sounds_stream.size()):
		played_id_set.append(i)
	played_id_set.shuffle()

func play_SoundVc(from_position: float = 0.0) -> void:
	if sounds_stream.size() == 0:
		return
	
	var playVc_stream: AudioStream
	
	match play_mode:
		PLAY_MODE.RANDOM:
			playVc_stream = sounds_stream[randi_range(0, sounds_stream.size() - 1)]
			
		PLAY_MODE.SEQUENTIAL:
			play_id = (play_id + 1) % sounds_stream.size()
			playVc_stream = sounds_stream[play_id]
			
		PLAY_MODE.SET_RANDOM:
			play_id += 1
			if play_id >= played_id_set.size():
				play_id = 0
				if auto_shuffle:
					shuffle_set()
			
			var stream_index = played_id_set[play_id]
			playVc_stream = sounds_stream[stream_index]
			
		PLAY_MODE.SMART_RANDOM:
			if played_id_set.size() >= sounds_stream.size():
				played_id_set.clear()
			
			var i = randi_range(0, sounds_stream.size() - 1)
			while played_id_set.has(i):
				i = randi_range(0, sounds_stream.size() - 1)
			
			played_id_set.append(i)
			playVc_stream = sounds_stream[i]
	
	stream = playVc_stream
	play(from_position)
