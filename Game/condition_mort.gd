extends Panel

signal youLose
signal oneCityBuilt

@onready var country1 = get_node("country")
@onready var country2 = get_node("country2_with_offset")
@onready var country3 = get_node("country3_with_offset")

var health_step_increase_per_minute = 20
var health_step_start = 20
	
func _ready():
	#initial health step
	country1.health_step = health_step_start
	country2.health_step = health_step_start
	country3.health_step = health_step_start

func _process(delta):
	
	if (country1.country_health >= 1000) or (country2.country_health >= 1000) or (country3.country_health >= 1000):
		youLose.emit()
	#if (country1.country_health == 1000) and (country2.country_health == 1000) and (country3.country_health == 1000):
	#	youLose.emit()
		
func _progressive_difficulty():
	
	country1.health_step += health_step_increase_per_minute
	country2.health_step += health_step_increase_per_minute
	country3.health_step += health_step_increase_per_minute
	
	
	

	
	
