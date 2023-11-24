extends Node2D

var SHOP_ITEM_CONFIG = {
#	"item_name": [
#		type (Normal or Golden),
#		price,
#		icon (path to texture)
#	]
	"Wings": [
		ShopItemType.Normal,
		50,
		"res://assets/items/wing.png"
	],
	"Golden key": [
		ShopItemType.Golden,
		1000,
		"res://assets/items/golden_key.png"
	],
	"Normal bird": [
		ShopItemType.Normal,
		1,
		"res://assets/items/birb.png"
	],
	"Special bird": [
		ShopItemType.Normal,
		2,
		"res://assets/items/birb_skin.png"
	],
}

var all_items = []

func _ready():
	_refresh_wallet()
	
	var item_scene = load("res://scenes/shop/item.tscn")
		
	for item in SHOP_ITEM_CONFIG:
		var new_item = item_scene.instantiate() #creates a new node
		$Items.add_child(new_item) #this adds the new crop as a child of the current node
		
		var item_config =  SHOP_ITEM_CONFIG[item]
		_configure_item(new_item, item, item_config)
		all_items.push_back(new_item)
		
		new_item.connect("buy_requested", on_buy_requested)
		
	_update_all_items_enabled()

func _configure_item(item, item_name, config):
	item.set_item_type(config[0])
	item.set_item_name(item_name)
	item.set_price(config[1])
	item.set_item_texture(config[2])

func _update_all_items_enabled():
	var i = 0
	for item in SHOP_ITEM_CONFIG:
		var item_config = SHOP_ITEM_CONFIG[item]
		if item_config[0] == ShopItemType.Normal:
			all_items[i].set_enabled(GameState.eggs >= item_config[1])
		if item_config[0] == ShopItemType.Golden:
			all_items[i].set_enabled(GameState.golden_eggs >= item_config[1])
		if item == "Normal bird" && GameState.active_skin == "default":
			all_items[i].set_enabled(false)
		if item == "Special bird" && GameState.active_skin == "special":
			all_items[i].set_enabled(false)
		i += 1
		
		
func _refresh_wallet():
	$Eggs/EggLabel.text = str(GameState.eggs)
	$Eggs/GoldenEggLabel.text = str(GameState.golden_eggs)

func on_buy_requested(item_name):
	var item_price = SHOP_ITEM_CONFIG[item_name][1]
	var item_type = SHOP_ITEM_CONFIG[item_name][0]
	
	if item_type == ShopItemType.Normal:
		if GameState.eggs < item_price:
			print("Not enough funds for item " + item_name);
			return
		GameState.eggs -= item_price
	if item_type == ShopItemType.Golden:
		if GameState.golden_eggs < item_price:
			print("Not enough funds for item " + item_name);
			return
		GameState.golden_eggs -= item_price
	
	_process_buy_request(item_name)
	_refresh_wallet()
	_update_all_items_enabled()
	GameState.save_state()
	
func _process_buy_request(item_name):
	match item_name:
		"Wings":
			GameState.wings_bought = true
		"Golden key":
			GameState.chest_keys += 1
		"Normal bird":
			GameState.active_skin = "default"
		"Special bird":
			GameState.active_skin = "special"
