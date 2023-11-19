extends Node2D

var SHOP_ITEM_CONFIG = {
#	"item_name": [
#		type (Normal or Golden),
#		price,
#		icon (path to texture)
#	]
	"Test item": [
		ShopItemType.Normal,
		100,
		"res://assets/items/chest_closed.png"
	],
	"Test item 2": [
		ShopItemType.Golden,
		200,
		"res://assets/items/chest_closed.png"
	],
	"Test item 3": [
		ShopItemType.Normal,
		500,
		"res://assets/items/chest_closed.png"
	],
	"Wings": [
		ShopItemType.Golden,
		50,
		"res://assets/items/wing.png"
	],
}

var all_items = []

var points_dict = {"White": 50, "Yellow": 75, "Orange": 100}

func _ready():
	$Eggs/EggLabel.text = str(GameState.eggs)
	$Eggs/GoldenEggLabel.text = str(GameState.golden_eggs)
	
	var item_scene = load("res://scenes/shop/item.tscn")
		
	for item in SHOP_ITEM_CONFIG:
		var new_item = item_scene.instantiate() #creates a new node
		$Items.add_child(new_item) #this adds the new crop as a child of the current node
		
		var item_config =  SHOP_ITEM_CONFIG[item]
		_configure_item(new_item, item, item_config)
		
		all_items.push_back(new_item)
		
		new_item.connect("buy_requested", on_buy_requested)

func on_buy_requested(item_name):
	print("Buy request for item " + item_name)

func _configure_item(item, item_name, config):
	item.set_item_type(config[0])
	item.set_item_name(item_name)
	item.set_price(config[1])
	item.set_item_texture(config[2])
