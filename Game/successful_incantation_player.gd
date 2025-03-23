extends AudioStreamPlayer2D


var Bb7 = preload("res://music/Bb7.wav") 
var Cm7 = preload("res://music/Cm7.wav") 
var F7 = preload("res://music/F7.wav") 
var Gm7 = preload("res://music/Gm7.wav") 
var Cm6 = preload("res://music/Cm6.wav") 

var chords_order : Array[Resource] = [Cm7, Cm6, Gm7, F7, Bb7]
var cursor : int = 0
var NUMBER_OF_CHORDS = chords_order.size()

func play_chord():
	stream = chords_order[cursor]
	cursor = (cursor + 1) % NUMBER_OF_CHORDS
	play()
