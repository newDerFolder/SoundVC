@icon("res://vcder/soundVC/SoundVC_bg.png")
extends Node

#SoundVc0.1 | Godot4.5

var nowBgm
var nowBgmMaxLen=0
var bgmList:Array
var bgmLoopPlay:bool=true
var playBgmFromList=false
var bgmListPlayId=0

func play(soundPath:String,from_position: float = 0.0):
	$AudioStreamPlayer.stream=load(soundPath)
	$AudioStreamPlayer.play(from_position)

func playBgm(soundPath:String,stopAndRePlay=false):
	if stopAndRePlay:
		$BGM.stop()
	$BGM.stream=load(soundPath)
	print(str($BGM.stream.get_length()))
	$BGM.play()
	nowBgm=soundPath

func startPlayBgmList():
	playBgmFromList=true
	bgmListPlayId=0
	playBgm(get_bgmListPalyPath())

func pausedBgm():
	$BGM.stream_paused=true
func unPausedBgm():
	$BGM.stream_paused=false

func addBgmToList(soundPath:String,oncePlay:bool=false,playNow=false):
	var newBgm={
		"soundPath":soundPath,
		"oncePlay":oncePlay
	}
	bgmList.append(newBgm)
	if playNow:
		playBgmFromList=true
		playBgm(soundPath)
		bgmListPlayId=bgmList.size()-1

func get_bgmListPalyPath():
	if bgmList.size() <= 0:
		return null
	
	# 使用取模运算确保索引始终在有效范围内
	var playId = bgmListPlayId
	bgmListPlayId = (bgmListPlayId + 1) % bgmList.size()
	return bgmList[playId]["soundPath"]

func _on_bgm_finished() -> void:
	if bgmLoopPlay:
		if playBgmFromList:
			playBgm(get_bgmListPalyPath())
		else:
			playBgm(nowBgm)
