extends Panel
const UP_ARROW = "↑"
const DOWN_ARROW = "↓"
const RIGHT_ARROW = "→"
const LEFT_ARROW = "←"

var label_content : String = ""

var is_success : bool = false
var to_be_wiped: bool = false

@onready var label: Label = $Label
@onready var panel : Panel = $IncantationPanel

func adjust_color() -> void:
	label.clip_text

func change_label_color(new_color: Color):
	label.modulate = new_color
	

func _ready() -> void:
	label.text = label_content

func treatSignal(signal_value: String) -> void:
	print("RECEIVED SGINALEGOe")
	print(signal_value)
	if to_be_wiped:
		label_content = ""
		to_be_wiped = false
	
	if signal_value == "RESET":
		is_success = false
		label_content = ""
	elif signal_value == "UP":
		is_success = false
		label_content += UP_ARROW
	elif signal_value == "DOWN":
		is_success = false
		label_content += DOWN_ARROW
	elif signal_value == "LEFT":
		is_success = false
		label_content += LEFT_ARROW
	elif signal_value == "RIGHT":
		is_success = false
		label_content += RIGHT_ARROW
	elif signal_value == "SUCCESS":
		#label_content = ""
		is_success = true
		to_be_wiped = true
		
	
	if is_success:
		change_label_color(Color.GREEN)
	else:
		change_label_color(Color.WHITE)

	label.text = label_content
