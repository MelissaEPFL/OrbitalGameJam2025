extends Node

# each X seconds, we update stuff
const time_step = 2

var time_country = 0
var last_time_increment = 0

# country has to build up
const initial_health = 0
const health_step = 100
# TODO tie some game over logic
const maximum_country_health = 1000

const attack_animation_duration = 3
var city_last_attack = -1
var debug_play_one_attack_example = true

var country_health = initial_health

@onready var _animation_healthbar = $VBoxContainer/upper/HealthbarContainer/Healthbar
@onready var _animation_city = $VBoxContainer/upper/CityContainer/City

func _ready():
	_animation_healthbar.frame = 1
	_animation_city.visible = false

func _process(delta):
	time_country = time_country + delta
	
	if time_country - last_time_increment > time_step: 
		last_time_increment = last_time_increment + time_step
		
		country_health = country_health + health_step
		# frame 1-8, frame 1 is unhealthy, frame 8 is healthy
		_animation_healthbar.frame = round(country_health/health_step)
		print('update country health!')
	
	# stop attack animation after a while
	#print(round(time_country), '|||||',city_last_attack + attack_animation_duration)
	if time_country > city_last_attack + attack_animation_duration:
		_animation_city.visible = false
		
	# TODO REMOVE for demo purpose, play attack animation on city
	if time_country > 5 && debug_play_one_attack_example:
		play_attack_on_city(time_country)
		
func play_attack_on_city(now: float):
	debug_play_one_attack_example = false
	city_last_attack = now
	_animation_city.visible = true
	_animation_city.play()
