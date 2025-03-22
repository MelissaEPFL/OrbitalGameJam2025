extends AnimatedSprite2D

# States
enum State {
	COOKING,
	DYING,
	PARTYING
}

var current_state = State.COOKING

func _ready():
	play("let_him_cook")  # Start with the idle animation

func _process(delta):
	match current_state:
		State.COOKING:
			play("let_him_cook")
		State.PARTYING:
			play_animation_once("success")
		State.DYING:
			play_animation_once("failure")
		
				
func _on_success():
	current_state = State.PARTYING
		
func _on_failure():
	current_state = State.DYING
		
func play_animation_once(animation_name):
	play(animation_name)
	await self.animation_finished
	current_state = State.COOKING
