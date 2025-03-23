extends Node

# each X seconds, we update stuff
const time_step: int = 2

var time_country: float = 0
var last_time_increment: int = 0

# country has to build up
const initial_health: int = 0
var health_step: int = 50
# TODO tie some game over logic
const maximum_country_health: int = 1000

const attack_damage: int = 350
const attack_animation_duration: int = 3
var city_last_attack: int = -1
var debug_play_one_attack_example: bool = true

var country_health: int = initial_health

@onready var _animation_healthbar = $Healthbar
@onready var _animation_explosion = $Explosion

@onready var _animation_ingredient01 = $Ingredient01
@onready var _animation_ingredient02 = $Ingredient02
@onready var _animation_ingredient03 = $Ingredient03

@onready var _animation_flag = $Flag
@onready var _animation_city = $City
const CITY_FRAMES: int = 3

var all_recipes: Array[int]
var recipe: Array[int]

var damage_country_next_time = false

var ID: String

func _ready():
	var regex = RegEx.new()
	regex.compile("\\d")
	var name_match = regex.search(self.name)
	ID = name_match.get_string() if name_match else '1'
	print('ID is ' + ID)
	_animation_healthbar.frame = 0
	_animation_explosion.visible = false
	_animation_flag.play("country_"+str(ID))
	_animation_city.frame = 0
	if ID == '1':
		print('set target 1 recipe: ', all_recipes[0], all_recipes[1], all_recipes[2])
		recipe = [all_recipes[0], all_recipes[1], all_recipes[2]]
		_animation_ingredient01.frame = all_recipes[0]
		_animation_ingredient02.frame = all_recipes[1]
		_animation_ingredient03.frame = all_recipes[2]
	elif ID == '2':
		print('set target 2 recipe: ', all_recipes[3], all_recipes[4], all_recipes[5])
		recipe = [all_recipes[3], all_recipes[4], all_recipes[5]]
		_animation_ingredient01.frame = all_recipes[3]
		_animation_ingredient02.frame = all_recipes[4]
		_animation_ingredient03.frame = all_recipes[5]
	elif ID == '3':
		print('set target 3 recipe: ', all_recipes[6], all_recipes[7], all_recipes[8])
		recipe = [all_recipes[6], all_recipes[7], all_recipes[8]]
		_animation_ingredient01.frame = all_recipes[6]
		_animation_ingredient02.frame = all_recipes[7]
		_animation_ingredient03.frame = all_recipes[8]

func _process(delta: Variant):
	time_country = time_country + delta
	#print(time_country)
	
	if time_country - last_time_increment > time_step: 
		last_time_increment = last_time_increment + time_step
		
		country_health = country_health + health_step
		if country_health > maximum_country_health:
			country_health = maximum_country_health
		# frame 1-8, frame 1 is unhealthy, frame 8 is healthy
		_animation_healthbar.frame = round(country_health/health_step)
		#print('update country health!')
		
		# update city sprite depending on health and 3 frames of city health
		# frame 0: damaged
		# frame 1: building
		# frame 2: ok
		# change 3
		# 200 is just magic number so ~30% is destroy, 30-70 is okaish and
		# 70+ is healthy
		_animation_city.frame = roundi(
			fmod(country_health - 200, maximum_country_health) / 
			(maximum_country_health / CITY_FRAMES)
		) if country_health < maximum_country_health else 2
		#print(ID, ': ', _animation_city.frame, '||||',country_health, '||||', maximum_country_health)
	
	#print(_animation_city.frame)
	
	# stop attack animation after a while
	#print(round(time_country), '|||||',city_last_attack + attack_animation_duration)
	if time_country > city_last_attack + attack_animation_duration:
		_animation_explosion.visible = false
		
	# REMOVE for demo purpose, play attack animation on city
	#if time_country > 5 && debug_play_one_attack_example:
	if damage_country_next_time:
		damage_country_next_time = false
		attack_city(time_country)
		
func attack_city(now: float):
	debug_play_one_attack_example = false
	city_last_attack = now
	_animation_explosion.visible = true
	_animation_explosion.play()
	country_health = country_health - attack_damage

func _on_game_manager_recipe_for_target(
	t1_i1: int,
	t1_i2: int,
	t1_i3: int,
	t2_i1: int,
	t2_i2: int,
	t2_i3: int,
	t3_i1: int,
	t3_i2: int,
	t3_i3: int,
) -> void:
	all_recipes = [
		t1_i1, t1_i2, t1_i3,
		t2_i1, t2_i2, t2_i3,
		t3_i1, t3_i2, t3_i3,
	]
	

func _on_game_manager_successful_missile_launch(target: int) -> void:
	if target == ID.to_int():
		damage_country_next_time = true
		print('country ', ID, ' was hit')
