extends MenuButton

@export var scene_path = ""
		
func _switch_to_scene():
	assert(scene_path != "", "Scene path can't be empty")
	get_tree().change_scene_to_file(scene_path)
	
func ready():
	print(scene_path)
	
func _do_nothing():
	print("Store not yet implemented")
