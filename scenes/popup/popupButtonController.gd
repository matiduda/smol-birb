extends MenuButton

func _go_back_to_menu():
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
	
func _reset_current_scene():
	get_tree().reload_current_scene()
