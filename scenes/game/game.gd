extends Node2D

const PLATFORMS_CAP = 7
const TOP_POSITION_CAP = -1200
const PLATFROM_REMOVE_THRESHOLD = 700
const PLATFORM_WIDTH = 150
const PLATFORM_MIN_DISTANCE_Y = 210

var platform = preload("res://scenes/platform/platform.tscn")
var position_cap = Vector2(360, -500)
var existing_platforms = []

@onready var light_bg = get_node("ParallaxBackground/BackgroudColor/BackgroudDay")
@onready var dark_bg = get_node("ParallaxBackground/BackgroudColor/BackgroundNight")
@onready var planets = get_node("ParallaxBackground/Moving/Planets")
@onready var clouds = get_node("ParallaxBackground/Moving/Clouds")
@onready var player = get_node("Player")

func remove_platforms_offscreen():
	for existing_platform in existing_platforms:
		if existing_platform.global_position.y > $Camera2D.global_position.y + get_viewport_rect().size.y / 2:
			existing_platforms.erase(existing_platform)
			existing_platform.queue_free()

func spawn_platforms_inbounds():
	var new_platform = null
	if PLATFORMS_CAP <= existing_platforms.size():
		return
	var generated_position = Vector2(randf_range(-get_viewport_rect().size.x / 2, position_cap.x - PLATFORM_WIDTH), randf_range($Player.position.y + position_cap.y, $Camera2D.position.y + TOP_POSITION_CAP))
	# check if position is valid - too close to other platform makes it invalid
	for existing_platform in existing_platforms:
		if abs(generated_position.y - existing_platform.position.y) <= PLATFORM_MIN_DISTANCE_Y:
			return
	new_platform = platform.instantiate()
	new_platform.position = generated_position
	existing_platforms.append(new_platform)
	add_child(new_platform)
	
func apply_background():
	if player.score >= 500:
		fade_out(light_bg)
		fade_out(clouds)
		fade_in(dark_bg)
		fade_in(planets)

func fade_out(node):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, 1.0) # Fades to transparent in 2 seconds

func fade_in(node):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 1.0) # Fades to opaque in 2 seconds
	
func _ready():
	existing_platforms.append($platform)
	existing_platforms.append($platform6)

func _physics_process(_delta):
	spawn_platforms_inbounds()
	remove_platforms_offscreen()
	apply_background()
