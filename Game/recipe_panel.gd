extends Panel

# Variables
var is_flashing = false
var flash_color = Color(0, 0.725, 0, 1) # Green color
var default_color = Color(0.854, 0.4902, 0.34118, 1) # Reddish color
var flash_timer = 0.0 # Timer for color transition
var speed_multiplier = 15.0 # Adjust this value to control flashing speed
var end_timer = 5.0
var incantation = "salut"


# Reference to the ColorRect background
@onready var background_node: ColorRect = $ColorRect
@onready var label_node: Label = $Label
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func flash_green():
	set_flash_color(0, 0.725, 0) # Green color)
	if not is_flashing:
		is_flashing = true
		
func set_flash_color(r: float, g: float, b: float):
	var flash_color = Color(r, g, b, 1)


func _process(delta):
	if is_flashing:
		flash_timer += delta * speed_multiplier # Multiply delta to increase speed
		var t = (sin(flash_timer) + 1.0) / 2.0 # Oscillates smoothly between 0 and 1
		var r = lerp(default_color.r, flash_color.r, t)
		var g = lerp(default_color.g, flash_color.g, t)
		var b = lerp(default_color.b, flash_color.b, t)
		var a = lerp(default_color.a, flash_color.a, t)
		background_node.modulate = Color(r, g, b, a) # Apply to ColorRect
		if flash_timer >= end_timer:
			is_flashing = false
			flash_timer = 0.0    
	else:
		background_node.modulate = default_color

'''			
	if randf() < 1.0 / 200.0:
			label_node.text = "akdskadlajflkjs"
	if randf() < 1.0 / 200.0:
			label_node.text = "kojokjolkokokm"
	if randf() < 1.0 / 200.0:
			sprite_node.texture = red_texture
	if randf() < 1.0 / 200.0:
			sprite_node.texture = green_texture
	if randf() < 1.0 / 200.0:
			sprite_node.texture = blue_texture
'''
