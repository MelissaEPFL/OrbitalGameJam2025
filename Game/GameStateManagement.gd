extends Node2D

enum IncantationInputs { UP, DOWN, RIGHT, LEFT}

signal targetChanged(old_value: int, new_value: int)
signal failedMissileLaunch
signal successfulMissileLaunch


signal incantationCharacterStream(char: String)

class IngredientIncantation:
	var ingredientName: String
	var inputs : Array[IncantationInputs]
	
	func _init(recipe_ingredients : Array[IncantationInputs], name : String) -> void:
		inputs = recipe_ingredients
		ingredientName = name
		
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

# The current selection of inputs from the player (right, up , down down down)
var current_incantation : Array[IncantationInputs] = [] 

var available_incantations: Array[IngredientIncantation] = [] # The recipes in play in the game
var ingredients_in_pot: Array[IngredientIncantation] = [] # The recipes in the pot looking to get sent


func receiveInput(receivedInput : IncantationInputs):
	current_incantation.append(receivedInput)
	for i in range(available_incantations.size()):
		if available_incantations[i].validate_incantation(current_incantation):
			ingredients_in_pot.append(available_incantations[i])
			current_incantation = []
			incantationCharacterStream.emit("SUCCESS")
			

func deleteInputs():
	if current_incantation.size() == 0:
		ingredients_in_pot = []
	current_incantation = []
	
var current_target = 1
var valid_targets : Array[int] = []
# Or you can initialize using Dictionary() to explicitly indicate it's a Dictionary
var targets : Dictionary[int, Target] = {}

func _ready() -> void:
	# Example for testing
	var bigbomb : IngredientIncantation = IngredientIncantation.new(
		[
			IncantationInputs.UP,
			IncantationInputs.RIGHT,
			IncantationInputs.DOWN,
			IncantationInputs.DOWN,
			IncantationInputs.DOWN
		],
		"bigbomb"
	)

	var thorium : IngredientIncantation = IngredientIncantation.new(
		[
			IncantationInputs.UP,
			IncantationInputs.RIGHT,
			IncantationInputs.LEFT,
			IncantationInputs.UP,
			IncantationInputs.DOWN
		],
		"thorium"
	)
	var some_recipe : Recipe = Recipe.new([bigbomb, thorium])
	
	var target: Target = Target.new(some_recipe)
	# Assign a value to the dictionary
	valid_targets = [1,2,3] # Setting some dummy targets
	targets[1] = target
	targets[2] = target
	targets[3] = target
	
	
	# Example of incantations
	available_incantations.append(thorium)
	available_incantations.append(bigbomb)
	
	
	
func user_pressed_enter_on_current_pot():
	var is_valid_ingredients_in_pot: bool = targets[current_target].validate_ingredients(ingredients_in_pot)
	if is_valid_ingredients_in_pot:
		print("Successful firing !")
		successfulMissileLaunch.emit()
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
