extends MenuButton

@export var scene_path = ""

func _switch_to_scene():
	assert(scene_path != "", "Scene path can't be empty")
	
	var game_scene = load(scene_path).instantiate()
	get_tree().root.add_child(game_scene)
	get_node("/root/menu").free()

func _on_pressed():
	_switch_to_scene()
