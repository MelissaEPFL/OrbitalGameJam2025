extends GridContainer

var nbr_ingr:int = 4

# Array to store the state of each ingredient
var ingredient_states:Array = ["empty", "empty","empty","empty"]
var ingredients:Array = []

func _ready():
	
	#Get children ingredients
	var ingr1 = get_node("ingredient1")
	var ingr2 = get_node("ingredient2")
	var ingr3 = get_node("ingredient3")
	var ingr4 = get_node("ingredient4")
	ingredients = [ingr1,ingr2,ingr3,ingr4]	
	
	# Initialize empty ingredients
	for i in range(nbr_ingr):
		print(ingredients[i])
		ingredients[i].play("empty")

# Update a specific ingredient in the grid
func update_ingredient(fleches:String, ingredient_index: int):
	
	#find first empty slot
	for i in range(nbr_ingr):
		if ingredient_states[i] == "empty":
			#update correct sprite
			var new_sprite:String = "sprite_" + str(ingredient_index)
			ingredients[i].play(new_sprite)
			return
			
func reset_grid(target:int):
		# Initialize empty ingredients
	for i in range(nbr_ingr):
		ingredients[i].play("empty")
		
