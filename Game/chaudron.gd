extends AnimatedSprite2D

# Signals
signal chaudron_moving
signal chaudron_arrived

# Variables for positions
var left_position = Vector2(-72, 73)  # Outside the left screen
var right_position = Vector2(937, 73)  # Outside the right screen

# Speed for movement
var movement_speed = 200  # Pixels per second

# States
enum State {
	MOVING,
	IDLE
}
var current_state = State.IDLE

# child AnimatedSprite2D
@onready var sprite_chaudron = $Chaudrons
@onready var gameManager = $GameManager

func _ready():
	# Initial position of the sprite
	position = left_position
	gameManager.connect("successfulMissileLaunch", _on_recipe_change())

func _process(delta):
	match current_state:
		State.MOVING:
			move_to_position(right_position, delta)

func move_to_position(target_position, delta):
	#Mouvement en cours
	if position.distance_to(target_position) > movement_speed * delta:
		position += (target_position - position).normalized() * movement_speed * delta
	else:
		#Mouvement terminé
		position = left_position
		current_state = State.IDLE
		emit_signal("chaudron_arrived")

func _on_recipe_change():
	#sprite appear and start moving to the center
	current_state = State.MOVING
	emit_signal("chaudron_moving")
