extends MenuButton

func _switch_to_game_scene():
	var game_scene = preload("res://scenes/game/game.tscn").instantiate()
	get_tree().root.add_child(game_scene)
	get_node("/root/menu").free()

func _on_pressed():
	print("Switching!!")
	_switch_to_game_scene()
