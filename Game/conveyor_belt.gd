extends AnimatedSprite2D

# States
enum State {
	MOVING,
	IDLE
}

var current_state = State.IDLE

@onready var chaudron:Node2D = $Chaudron

func _ready():
	
	current_state = State.IDLE
	chaudron.connect("chaudron_moving", _conveyor_on_off())
	chaudron.connect("chaudron_arrived", _conveyor_on_off())
	
func _process(delta):
	match current_state:
		State.MOVING:
			play("moving")
		State.IDLE:
			play("idle")
	
func _conveyor_on_off():
	if current_state == State.IDLE:
		current_state = State.MOVING
	elif current_state == State.MOVING:
		current_state = State.IDLE
