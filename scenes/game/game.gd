extends Node2D

const PLATFORMS_CAP = 7
const TOP_POSITION_CAP = -1200
const PLATFROM_REMOVE_THRESHOLD = 700
const PLATFORM_WIDTH = 150
const PLATFORM_MIN_DISTANCE_Y = 210

var platform: = preload("res://scenes/platform/platform.tscn")
var position_cap = Vector2(720, -500)
var existing_platforms = []

func remove_platforms_offscreen():
	var i = 0
	for platform in existing_platforms:
		if abs(platform.position.y - $Camera2D.position.y) >= PLATFROM_REMOVE_THRESHOLD:
			existing_platforms.erase(platform)
			platform.queue_free()

func spawn_platforms_inbounds():
	var new_platform = null
	while true:
		if PLATFORMS_CAP <= existing_platforms.size():
			return null
		var generated_position = Vector2(randf_range(0, position_cap.x - PLATFORM_WIDTH), randf_range($Player.position.y + position_cap.y, $Camera2D.position.y + TOP_POSITION_CAP))
		# check if position is valid - too close to other platform makes it invalid
		for platform in existing_platforms:
			if abs(generated_position.y - platform.position.y) <= PLATFORM_MIN_DISTANCE_Y:
				return null
		new_platform = platform.instantiate() 
		new_platform.position = generated_position
		existing_platforms.append(new_platform)
		add_child(new_platform)
		return null;
		
func _ready():
	existing_platforms.append($platform)
	existing_platforms.append($platform6)
	spawn_platforms_inbounds()

func _physics_process(delta):
	spawn_platforms_inbounds()
	remove_platforms_offscreen()
