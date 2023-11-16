extends StaticBody2D
class_name RegularPlatform

@onready var player = get_parent().get_node("Player")

const ITEM_SPAWN_OFFSET_Y = 2

const EGG_SPAWN_CHANCE = .4
const GOLDEN_EGG_SPAWN_CHANCE = .03
const WINGS_SPAWN_CHANCE = .05

var egg = preload("res://scenes/items/egg/Egg.tscn")
var golden_egg = preload("res://scenes/items/golden_egg/GoldenEgg.tscn")
var wings = preload("res://scenes/items/wings/wings.tscn")

func _ready():
	# THIS IF IS NEEDED BECAUSE WE DON'T WANT TO SPAWN ON STARTING PLATFORM
	# AND IT IS THE ONLY ONE THAT HAS POSITION.X < 0
	if position.x > 0:
		try_spawn_item()
		
func _process(_delta):
	var player_position = player.position
	if player_position.y > self.position.y:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
	pass

func try_spawn_item():
	var chance_to_spawn = randf_range(0, 1)
	var platform_center = Vector2($CollisionShape2D.shape.size.x / 2,
		-$CollisionShape2D.shape.size.y - ITEM_SPAWN_OFFSET_Y)
	# TRY SPAWN GOLDEN EGG
	if GOLDEN_EGG_SPAWN_CHANCE >= chance_to_spawn:
		var golden_egg_instance = golden_egg.instantiate()
		golden_egg_instance.position = platform_center
		add_child(golden_egg_instance)
	# TRY SPAWN WINGS
	elif WINGS_SPAWN_CHANCE >= chance_to_spawn:
		var wings_instance = wings.instantiate()
		wings_instance.position = platform_center
		add_child(wings_instance)
	# TRY SPAWN EGG
	elif EGG_SPAWN_CHANCE >= chance_to_spawn:
		var egg_instance = egg.instantiate()
		egg_instance.position = platform_center
		add_child(egg_instance)		
