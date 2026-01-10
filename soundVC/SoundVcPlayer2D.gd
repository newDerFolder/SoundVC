@icon("res://vcder/soundVC/sc/icon_SoundPlayer2D.png")
extends AudioStreamPlayer2D

class_name SoundPlayerVc2D

enum PLAY_MODE{RANDOM = 0, SEQUENTIAL = 1, SET_RANDOM = 2, SMART_RANDOM = 3}

@export var sounds_stream: Array[AudioStream]
@export var play_mode: PLAY_MODE = PLAY_MODE.SET_RANDOM
@export var auto_shuffle: bool = true
@export_group("smart_random_mode")
@export var set_played_range: int = 2



var play_id = -1
var played_id_set: Array = []

func _ready() -> void:
	match play_mode:
		PLAY_MODE.SET_RANDOM:
			if sounds_stream.size() > 0: # 新增容错：数组为空时不执行洗牌
				shuffle_set(randi_range(0,sounds_stream.size()-1))

func shuffle_set(end_id:int):
	played_id_set.clear()
	for i in range(sounds_stream.size()):
		played_id_set.append(i)
	played_id_set.shuffle()
	if played_id_set[0]==end_id:
		var temp=played_id_set[0]
		var swId=randi_range(1,played_id_set.size()-1)
		played_id_set[0]=played_id_set[swId]
		played_id_set[swId]=temp

func vc_play_sound(from_position: float = 0.0) -> void:
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
				if auto_shuffle:
					shuffle_set(played_id_set[-1])
				play_id = 0
			
			var stream_index = played_id_set[play_id]
			playVc_stream = sounds_stream[stream_index]
			
		PLAY_MODE.SMART_RANDOM:
			if set_played_range>sounds_stream.size()-1:
				set_played_range=sounds_stream.size()-1
			while played_id_set.size()>set_played_range:
				played_id_set.pop_front()
			var i=randi_range(0,sounds_stream.size()-1)
			while played_id_set.has(i):
				i=randi_range(0,sounds_stream.size()-1)
			played_id_set.append(i)
			playVc_stream=sounds_stream[i]
	
	if playVc_stream:
		stream = playVc_stream
		play(from_position)
