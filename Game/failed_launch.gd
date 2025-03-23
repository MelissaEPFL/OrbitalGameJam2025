extends AudioStreamPlayer2D

var wompwomp = preload("res://music/FailedLaunch.wav")

func _ready() -> void:
	stream = wompwomp

func play_sound():
	play()
