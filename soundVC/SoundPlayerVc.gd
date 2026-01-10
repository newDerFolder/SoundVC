@icon("res://vcder/soundVC/sc/icon_SoundPlayer.png")
extends AudioStreamPlayer

class_name SoundPlayerVc



enum PLAY_MODE{RANDOM = 0, SEQUENTIAL = 1, SET_RANDOM = 2, SMART_RANDOM = 3}

@export var sounds_stream: Array[AudioStream]

@export var first_play_no_offset:bool=true
@export_range(-80,24) var volume_db_min_offset:float=0.0
@export_range(-80,24) var volume_db_max_offset:float=0.0
@export_range(0.01,4.0) var pitch_scale_min_offset:float=1
@export_range(0.01,4.0) var pitch_scale_max_offset:float=1

@export var play_mode: PLAY_MODE = PLAY_MODE.SET_RANDOM
@export var auto_shuffle: bool = true
@export_group("smart_random_mode")
@export var set_played_range: int = 2

var vc_ready:bool=false
var play_count: int = 0


var play_id = -1
var played_id_set: Array = []

func _vc_ready() -> void:
	match play_mode:
		PLAY_MODE.SET_RANDOM:
			if sounds_stream.size() > 0:
				shuffle_set(randi_range(0,sounds_stream.size()-1))
	vc_ready=true

func shuffle_set(end_id:int):
	played_id_set.clear()
	for i in range(sounds_stream.size()):
		played_id_set.append(i)
	played_id_set.shuffle()
	if played_id_set[0]==end_id and sounds_stream.size()>1:
		var temp=played_id_set[0]
		var swId=randi_range(1,played_id_set.size()-1)
		played_id_set[0]=played_id_set[swId]
		played_id_set[swId]=temp

func vc_play_sound(from_position: float = 0.0) -> void:
	if not vc_ready:
		_vc_ready()
	
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
		if not first_play_no_offset or play_count>0:
			volume_db=randf_range(volume_db_min_offset,volume_db_max_offset)
			pitch_scale=randf_range(pitch_scale_min_offset,pitch_scale_max_offset)
		stream = playVc_stream
		play(from_position)
		play_count+=1
