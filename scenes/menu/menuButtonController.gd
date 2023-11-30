extends MenuButton

@export var scene_path = ""
	
var soundScene = preload("res://scenes/soundengine/soundengine.tscn")
var soundPlayer

func _switch_to_scene():
	soundPlayer.playSound(soundPlayer.sounds.BUTTONPRESS)
	assert(scene_path != "", "Scene path can't be empty")
	get_tree().change_scene_to_file(scene_path)
	
func _ready():
	print(scene_path)
	soundPlayer = soundScene.instantiate()
	get_tree().root.add_child.call_deferred(soundPlayer)
	
func _do_nothing():
	print("Store not yet implemented")
