extends AudioStreamPlayer2D

var wompwomp = preload("res://music/SuccessfulLaunch.wav")

func _ready() -> void:
	stream = wompwomp

func play_sound(some_int_useless: int):
	play()
