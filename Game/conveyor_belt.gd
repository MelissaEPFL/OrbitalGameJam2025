extends AnimatedSprite2D

# States
enum State {
	MOVING,
	IDLE
}

var current_state = State.IDLE

func _ready():
	
	current_state = State.IDLE
	
func _process(delta):
	match current_state:
		State.MOVING:
			play("moving")
		State.IDLE:
			play("idle")
	
func _conveyor_on_off(target:int):
	if current_state == State.IDLE:
		current_state = State.MOVING
	elif current_state == State.MOVING:
		current_state = State.IDLE
