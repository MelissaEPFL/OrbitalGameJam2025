extends AudioStreamPlayer2D

var wompwomp = preload("res://music/WrongIncantation.wav")

func _ready() -> void:
	stream = wompwomp

func play_sound():
	play()
