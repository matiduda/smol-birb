extends Node2D

const PLATFORMS_CAP = 7
const TOP_POSITION_CAP = -1200
const PLATFROM_REMOVE_THRESHOLD = 650
const PLATFORM_WIDTH = 150
const PLATFORM_MIN_DISTANCE_Y = 210

var regularPlatform = preload("res://scenes/platforms/regularPlatform/regularPlatform.tscn")
var brokenPlatform = preload("res://scenes/platforms/brokenPlatform/brokenPlatform.tscn")
var jumpyPlatform = preload("res://scenes/platforms/jumpyPlatform/jumpyPlatform.tscn")
var fakePlatform = preload("res://scenes/platforms/fakePlatform/fakePlatform.tscn")
var platformInstances = []
var position_cap = Vector2(720, -500)
var existing_platforms = []

func remove_platforms_offscreen():
	for existing_platform in existing_platforms:
		if abs(existing_platform.position.y - $Camera2D.position.y) >= PLATFROM_REMOVE_THRESHOLD:
			existing_platforms.erase(existing_platform)
			existing_platform.queue_free()

func spawn_platforms_inbounds():
	var new_platform = null
	if PLATFORMS_CAP <= existing_platforms.size():
		return null
	var generated_position = Vector2(randf_range(0, position_cap.x - PLATFORM_WIDTH), randf_range($Player.position.y + position_cap.y, $Camera2D.position.y + TOP_POSITION_CAP))
	# check if position is valid - too close to other platform makes it invalid
	for existing_platform in existing_platforms:
		if abs(generated_position.y - existing_platform.position.y) <= PLATFORM_MIN_DISTANCE_Y:
			return null
	var random_index = randi_range(0, platformInstances.size() -1)
	var platformInstance = platformInstances[random_index]
	new_platform = platformInstance.instantiate()
	new_platform.position = generated_position
	existing_platforms.append(new_platform)
	add_child(new_platform)
		
func _ready():
	existing_platforms.append($platform)
	existing_platforms.append($platform6)
	platformInstances.append(regularPlatform)
	platformInstances.append(brokenPlatform)
	platformInstances.append(jumpyPlatform)
	platformInstances.append(fakePlatform)
	platformInstances.append(regularPlatform)
	platformInstances.append(brokenPlatform)
	platformInstances.append(jumpyPlatform)

func _physics_process(_delta):
	spawn_platforms_inbounds()
	remove_platforms_offscreen()
