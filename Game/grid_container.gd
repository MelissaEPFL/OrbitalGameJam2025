extends GridContainer

var nbr_ingr:int = 4

#children ingredients
@onready var ingr1 = $Ingredient1
@onready var ingr2 = $Ingredient2
@onready var ingr3 = $Ingredient3
@onready var ingr4 = $Ingredient4

# Array to store the state of each ingredient
var ingredient_states:Array = ["empty", "empty","empty","empty"]
var ingredients:Array = [ingr1,ingr2,ingr3,ingr4]

func _ready():
	# Initialize empty ingredients
	for i in range(nbr_ingr):
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
		
