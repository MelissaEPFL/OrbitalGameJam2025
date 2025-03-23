extends Node

@onready var music_player = $MainMusicPlayer

var first_track = preload("res://music/Orbital2025 Project.wav")  # First track
var second_track = preload("res://music/filler.wav")  # Second track
var switched_to_loop = false  # Track whether we've switched


func _ready():
	music_player.stream = first_track  # Start with the first track
	music_player.play()
	music_player.connect("finished", Callable(self, "_on_music_finished"))

func _on_music_finished():
	if not switched_to_loop:
		music_player.stream = second_track  # Switch to second track
		music_player.loop = true  # Enable looping for second track
		switched_to_loop = true  # Ensure we don't switch again
	
	music_player.play()  # Start playing the second track (loops forever)
