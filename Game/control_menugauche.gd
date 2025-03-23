extends Control

func select_RecipePanel(recipe_panel_num:int) -> Panel:
	var current_panel : Panel = null
	match recipe_panel_num:
		0:
			current_panel = $RecipePanel1
		1:
			current_panel = $RecipePanel2
		2:
			current_panel = $RecipePanel3
		3:
			current_panel = $RecipePanel4
		4:
			current_panel = $RecipePanel5
		5:
			current_panel = $pRecipePanel6
		_:
			print("WRONG NUMBER")
	return current_panel

func update_panel(panel_incantation: String, recipe_panel_num: int):
	var current_panel : Panel = select_RecipePanel(recipe_panel_num)
	current_panel.get_node("AnimatedSprite2D").frame = recipe_panel_num
	current_panel.get_node("Label").text = panel_incantation
	#current_panel.flash_green()
'''
func update_sprite(sprite_frame: int, recipe_panel_num: int):
	var current_panel : Panel = select_RecipePanel(recipe_panel_num)
	if sprite_frame > 5:
		print("WRONG")
	if sprite_frame < 0:
		print("SUPER WRONG")
	current_panel.get_node("AnimatedSprite2D").frame = sprite_frame
	current_panel.flash_green()
'''
func interecpt_success(incantation_input_string:String, sprite_frame:int):
	var current_panel : Panel = select_RecipePanel(sprite_frame)
	current_panel.flash_green()

func interecpt_setup(incant_string: String, sprite_frame : int):
	update_panel(incant_string,sprite_frame)

func update_incantation(new_text: String, recipe_panel_num: int):
	var current_panel : Panel = select_RecipePanel(recipe_panel_num)
	var label : Label = current_panel.get_node("Label") # Access the "Label" node inside "panel3"
	label.text = new_text # Update the label's text
	current_panel.flash_green()

'''
func _process(delta: float) -> void:

	if randf() < 1.0 / 200.0:
			interecpt_success("sup", 1)

	if randf() < 1.0 / 200.0:
			update_sprite(3, 2)
	if randf() < 1.0 / 200.0:
			update_sprite(5, 3)
	if randf() < 1.0 / 200.0:
			update_sprite(2, 4)
	if randf() < 1.0 / 200.0:
			update_incantation("sup", 5)
'''
