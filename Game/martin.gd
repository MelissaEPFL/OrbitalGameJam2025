extends AnimatedSprite2D

func _on_recipe_started_finished():
	if animation == "walk":
		play("idle")
