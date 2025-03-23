extends Panel

signal youLose
signal oneCityBuilt

@onready var country1 = get_node("country")
@onready var country2 = get_node("country2_with_offset")
@onready var country3 = get_node("country3_with_offset")

	
func _process(delta):
	
	if (country1.country_health == 1000) or (country2.country_health == 1000) or (country3.country_health == 1000):
		oneCityBuilt.emit()
	if (country1.country_health == 1000) and (country2.country_health == 1000) and (country3.country_health == 1000):
		youLose.emit()
	

	
	
