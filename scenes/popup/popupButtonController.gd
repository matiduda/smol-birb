extends MenuButton

var soundScene = preload("res://scenes/soundengine/soundengine.tscn")
var soundPlayer

func _go_back_to_menu():
	soundPlayer.playSound(soundPlayer.sounds.BUTTONPRESS)
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
	
func _reset_current_scene():
	get_tree().reload_current_scene()
	
func _ready():
	soundPlayer = soundScene.instantiate()
	get_tree().root.add_child.call_deferred(soundPlayer)
	
