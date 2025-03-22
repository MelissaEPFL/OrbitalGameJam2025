extends Node

# each X seconds, we update stuff
const time_step: int = 2

var time_country: float = 0
var last_time_increment: int = 0

# country has to build up
const initial_health: int = 0
const health_step: int = 100
# TODO tie some game over logic
const maximum_country_health: int = 1000

const attack_damage: int = 350
const attack_animation_duration: int = 3
var city_last_attack: int = -1
var debug_play_one_attack_example: bool = true

var country_health: int = initial_health

@onready var _animation_healthbar = $VBoxContainer/upper/HealthbarContainer/Healthbar
@onready var _animation_explosion = $VBoxContainer/upper/Explosion
@onready var _animation_flag = $VBoxContainer/upper/FlagContainer/Flag
@onready var _animation_city = $VBoxContainer/upper/CityContainer/City
const CITY_FRAMES: int = 3

func _ready():
	_animation_healthbar.frame = 0
	_animation_explosion.visible = false
	_animation_flag.play()
	_animation_city.frame = 0

func _process(delta: Variant):
	time_country = time_country + delta
	#print(time_country)
	
	if time_country - last_time_increment > time_step: 
		last_time_increment = last_time_increment + time_step
		
		country_health = country_health + health_step
		# frame 1-8, frame 1 is unhealthy, frame 8 is healthy
		_animation_healthbar.frame = round(country_health/health_step)
		print('update country health!')
		
		# update city sprite depending on health and 3 frames of city health
		# frame 0: damaged
		# frame 1: building
		# frame 2: ok
		# change 3
		_animation_city.frame = roundi(fmod(country_health, maximum_country_health) / (maximum_country_health / CITY_FRAMES))
		#print(_animation_city.frame, '||||',country_health, '||||', maximum_country_health, '|||', maximum_country_health / 3 * 2)
	
	#print(_animation_city.frame)
	
	# stop attack animation after a while
	#print(round(time_country), '|||||',city_last_attack + attack_animation_duration)
	if time_country > city_last_attack + attack_animation_duration:
		_animation_explosion.visible = false
		
	# TODO REMOVE for demo purpose, play attack animation on city
	if time_country > 5 && debug_play_one_attack_example:
		attack_city(time_country)
		
func attack_city(now: float):
	debug_play_one_attack_example = false
	city_last_attack = now
	_animation_explosion.visible = true
	_animation_explosion.play()
	country_health = country_health - attack_damage
