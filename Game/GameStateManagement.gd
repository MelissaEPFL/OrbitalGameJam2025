extends Node2D

enum IncantationInputs { UP, DOWN, RIGHT, LEFT}

signal targetChanged(old_value: int, new_value: int)
signal failedMissileLaunch
signal successfulMissileLaunch(target : int)

signal successfulIncantation(incantation_input_string : String, sprite_frame: int)
signal associateRecipeElement(incantation_input_string: String, sprite_frame: int)

signal incantationCharacterStream(char: String)

signal emptyIncantation

# recipe for target 1, recipe for target 2...
signal recipeForTarget(recipes: Array[Recipe])

class IngredientIncantation:
	var ingredientName: String
	var inputs : Array[IncantationInputs]
	var sprite_frame : int
	var incantation_string : String
	
	func _init(recipe_ingredients : Array[IncantationInputs], name : String, sprite_frameU : int, incantation_stringU : String) -> void:
		inputs = recipe_ingredients
		ingredientName = name
		sprite_frame = sprite_frameU
		incantation_string = incantation_stringU
		
	func validate_incantation(ingredients_to_compare: Array[IncantationInputs]) -> bool:
		return inputs == ingredients_to_compare
		
	func equal(recipe : IngredientIncantation):
		return recipe.validate_incantation(inputs) and recipe.ingredientName == ingredientName
		
class Recipe:
	# Represents the ingredients, in order, that the recipe expects
	var inputs : Array[IngredientIncantation]
	
	func _init(expects: Array[IngredientIncantation]) -> void:
		inputs = expects
		
	func validate_ingredients(to_validate: Array[IngredientIncantation]) -> bool:
		if to_validate.size() != inputs.size():
			return false
		for i in range(inputs.size()):
			if !inputs[i].equal(to_validate[i]):
				return false
		return true

class Target:
	var recipe: Recipe
	func _init(expects: Recipe):
		recipe = expects
		
	func validate_ingredients(in_pot: Array[IngredientIncantation]) -> bool:
		return recipe.validate_ingredients(in_pot)

const MAX_INCANTATION_SIZE : int = 5 # Maximum length of the incantation, to reset if it gets too large

# The current selection of inputs from the player (right, up , down down down)
var current_incantation : Array[IncantationInputs] = [] 

var available_incantations: Array[IngredientIncantation] = [] # The recipes in play in the game
var ingredients_in_pot: Array[IngredientIncantation] = [] # The recipes in the pot looking to get sent


func receiveInput(receivedInput : IncantationInputs):
	current_incantation.append(receivedInput)
	
	var success_in_pattern: bool = false
	for i in range(available_incantations.size()):
		if available_incantations[i].validate_incantation(current_incantation):
			ingredients_in_pot.append(available_incantations[i])
			current_incantation = []
			incantationCharacterStream.emit("SUCCESS")
			successfulIncantation.emit(available_incantations[i].incantation_string,available_incantations[i].sprite_frame)
			success_in_pattern = true
	
	print("CONDITIONS !!")
	print(str(current_incantation.size()))
	print(success_in_pattern)
	if current_incantation.size() >= MAX_INCANTATION_SIZE and !success_in_pattern:
		incantationCharacterStream.emit("FAILURE")
		current_incantation = []

func deleteInputs():
	if current_incantation.size() == 0:
		ingredients_in_pot = []
		emptyIncantation.emit()
	current_incantation = []
	
		
var current_target = 1
var valid_targets : Array[int] = []
# Or you can initialize using Dictionary() to explicitly indicate it's a Dictionary
var targets : Dictionary[int, Target] = {}



func _ready() -> void:
	# Example for testing
	var my_array = []
	var uranium : IngredientIncantation = IngredientIncantation.new(
		[
			IncantationInputs.UP,
			IncantationInputs.RIGHT,
			IncantationInputs.DOWN,
			IncantationInputs.DOWN,
			IncantationInputs.DOWN
		],
		"uranium",
		0,
		"↑→↓↓↓"
	)
	my_array.append(uranium)

	var banana : IngredientIncantation = IngredientIncantation.new(
		[
			IncantationInputs.UP,
			IncantationInputs.RIGHT,
			IncantationInputs.LEFT,
			IncantationInputs.UP,
			IncantationInputs.DOWN
		],
		"banana",
		1,
		"↑→←↑↓"
	)
	my_array.append(banana)

	var amethyst : IngredientIncantation = IngredientIncantation.new(
		[
			IncantationInputs.UP,
			IncantationInputs.DOWN,
			IncantationInputs.UP,
			IncantationInputs.DOWN,
			IncantationInputs.RIGHT
		],
		"amethyst",
		2,
		"↑↓↑↓→"
	)
	my_array.append(amethyst)

	#TODO put different incantation fro blood orange and diamond 
	var blood : IngredientIncantation = IngredientIncantation.new(
		[
			IncantationInputs.DOWN,
			IncantationInputs.DOWN,
			IncantationInputs.DOWN,
			IncantationInputs.DOWN,
			IncantationInputs.DOWN
		],
		"blood",
		3,
		"↓↓↓↓↓"
	)
	my_array.append(blood)

	var orange : IngredientIncantation = IngredientIncantation.new(
		[
			IncantationInputs.UP,
			IncantationInputs.RIGHT,
			IncantationInputs.DOWN,
			IncantationInputs.LEFT,
			IncantationInputs.UP,
		],
		"orange",
		4,
		"↑→↓←↑"
	)
	my_array.append(orange)

	var diamond : IngredientIncantation = IngredientIncantation.new(
		[
			IncantationInputs.UP,
			IncantationInputs.LEFT,
			IncantationInputs.DOWN,
			IncantationInputs.RIGHT,
			IncantationInputs.UP,
		],
		"diamond",
		5,
		"↑←↓→↑"
	)
	my_array.append(diamond)
	
	for element in my_array: #TODO iterate over the things in recipe
		associateRecipeElement.emit(element.incantation_string, element.sprite_frame)

	# Example of incantations
	available_incantations.append(uranium)
	available_incantations.append(banana)
	available_incantations.append(amethyst)
	available_incantations.append(blood)
	available_incantations.append(orange)
	available_incantations.append(diamond)
	
	#var target: Target = Target.new(some_recipe)
	# Assign a value to the dictionary
	valid_targets = [1,2,3] # Setting some dummy targets
	var target_1_recipe = Recipe.new([uranium, banana, amethyst])
	targets[1] = Target.new(target_1_recipe)
	var target_2_recipe = Recipe.new([orange, banana, diamond])
	targets[2] = Target.new(target_2_recipe)
	var target_3_recipe = Recipe.new([blood, uranium, amethyst])
	targets[3] = Target.new(target_3_recipe)
	# fails
#	recipeForTarget.emit([
#		target_1_recipe,
#		target_2_recipe,
#		target_3_recipe,
#	])
	#0 uranium
	#1 banana
	#2 amethyst
	#3 blood
	#4 orange
	#5 diamond
	recipeForTarget.emit(
		0,1,2,
		4,1,5,
		3,0,2,
	)
	
func user_pressed_enter_on_current_pot():
	var is_valid_ingredients_in_pot: bool = targets[current_target].validate_ingredients(ingredients_in_pot)
	if is_valid_ingredients_in_pot:
		print("Successful firing !")
		successfulMissileLaunch.emit(current_target)
	else:
		failedMissileLaunch.emit()
		print("You failed, nul !")
	deleteInputs()
	deleteInputs()

func assign_target(new_target : int) -> bool:
	print("Pressed " + str(new_target))
	if new_target in valid_targets:
		print("Target assigned at : " + str(current_target))
		targetChanged.emit(current_target, new_target)
		current_target = new_target
		return true
	else:
		return false
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_W or event.keycode == KEY_UP:
			incantationCharacterStream.emit("UP")
			receiveInput(IncantationInputs.UP)
		if event.keycode == KEY_A or event.keycode == KEY_LEFT:
			incantationCharacterStream.emit("LEFT")
			receiveInput(IncantationInputs.LEFT)
		if event.keycode == KEY_S or event.keycode == KEY_DOWN:
			incantationCharacterStream.emit("DOWN")
			receiveInput(IncantationInputs.DOWN)
		if event.keycode == KEY_D or event.keycode == KEY_RIGHT:
			incantationCharacterStream.emit("RIGHT")
			receiveInput(IncantationInputs.RIGHT)
		if event.keycode == KEY_ESCAPE:
			incantationCharacterStream.emit("RESET")
			deleteInputs()
		if event.keycode == KEY_ENTER:
			user_pressed_enter_on_current_pot()
			incantationCharacterStream.emit("RESET")
		print("-----------")
		print(current_incantation)
		print(ingredients_in_pot)
		
		# Processing inputs with target acquisition :
		if event.keycode == KEY_1:
			assign_target(1)
		if event.keycode == KEY_2:
			assign_target(2)
		if event.keycode == KEY_3:
			assign_target(3)
		if event.keycode == KEY_4:
			assign_target(4)
		if event.keycode == KEY_5:
			assign_target(5)
		if event.keycode == KEY_6:
			assign_target(6)
		if event.keycode == KEY_7:
			assign_target(7)
		if event.keycode == KEY_8:
			assign_target(8)
		if event.keycode == KEY_9:
			assign_target(9)


func change_to_deat_screen():
	get_tree().change_scene_to_file("res://death_screen.tscn")
