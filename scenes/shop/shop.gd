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
	"Second life": [
		ShopItemType.Normal,
		200,
		"res://assets/items/heart.png"
	],
	"Normal bird": [
		ShopItemType.Golden,
		0,
		"res://assets/items/birb.png"
	],
	"Special bird": [
		ShopItemType.Golden,
		200,
		"res://assets/items/birb_skin.png"
	],
	"Overheat birb": [
		ShopItemType.Golden,
		250,
		"res://assets/items/birb_overheat.png"
	],
	"Handsome birb": [
		ShopItemType.Golden,
		350,
		"res://assets/items/birb_handsome.png"
	],
	"Lil'pengu": [
		ShopItemType.Golden,
		1000,
		"res://assets/items/lil_penguin.png"
	]
}

# Matches Purchase.PurchaseState in the Play Billing Library
enum PurchaseState {
	UNSPECIFIED,
	PURCHASED,
	PENDING,
}

var all_items = []
var google_play_payment

var pending_eggs = 0

signal purchase_complete

func _ready():
	_refresh_wallet()
	_init_google_play_integration()
	
	var item_scene = load("res://scenes/shop/item.tscn")
		
	for item in SHOP_ITEM_CONFIG:
		var new_item = item_scene.instantiate() #creates a new node
		$Items.add_child(new_item) #this adds the new crop as a child of the current node
		
		var item_config =  SHOP_ITEM_CONFIG[item]

		_configure_item(new_item, item, item_config)
		all_items.push_back(new_item)
	
		new_item.connect("buy_requested", on_buy_requested)
		
	_update_all_items_enabled()
	
	$purchaseEggs.visible = false
	$purchaseEggs.connect("request_exit", _close_golden_egg_store)
	$purchaseEggs.connect("select_item", _on_select_golden_egg_purchase)
	
	$PaymentCover.visible = false


func _configure_item(item, item_name, config):
	item.set_item_type(config[0])
	item.set_item_name(item_name)
	item.set_price(config[1])
	item.set_item_texture(config[2])

func _update_all_items_enabled():
	var i = 0
	for item in SHOP_ITEM_CONFIG:
		var item_config = SHOP_ITEM_CONFIG[item]
		if item in GameState.bought_skins:
			item_config[1] = 0
			all_items[i].set_price(0)
			all_items[i].set_enabled(true)
		if item_config[0] == ShopItemType.Normal:
			all_items[i].set_enabled(GameState.eggs >= item_config[1])
		if item_config[0] == ShopItemType.Golden:
			all_items[i].set_enabled(GameState.golden_eggs >= item_config[1])
		if GameState.active_skin == item:
			all_items[i].set_enabled(false)
		i += 1
		
func _refresh_wallet():
	$Eggs/EggLabel.text = str(GameState.eggs)
	$Eggs/GoldenEggLabel.text = str(GameState.golden_eggs)

func on_buy_requested(item_name):
	var item = SHOP_ITEM_CONFIG[item_name]
	var item_price = item[1]
	var item_type = item[0]
	
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
		"Second life":
			GameState.second_life = true
		"Normal bird":
			GameState.set_active_skin(item_name, true)
		"Special bird":
			GameState.set_active_skin(item_name, true)
		"Lil'pengu":
			GameState.set_active_skin(item_name, true)
		"Overheat birb":
			GameState.set_active_skin(item_name, true)
		"Handsome birb":
			GameState.set_active_skin(item_name, true)
			

func _open_golden_egg_store():
	$purchaseEggs.visible = true
	
func _close_golden_egg_store():
	$purchaseEggs.visible = false
	
# IAP items are with following ids:
# golden_eggs_0000, where 0000 is the amount of eggs requested
	
func _on_select_golden_egg_purchase(price, amount):
	_close_golden_egg_store()
	$PaymentCover.visible = true
	
	$GooglePlayLabel.text = "Requested purchase of " + str(amount) + " golden eggs (" + str(price) + ")"

	var iap_item = "golden_eggs_" + str(amount)
	if google_play_payment:
		google_play_payment.purchase(iap_item)
		pending_eggs = amount
	else:
		$GooglePlayLabel.text = "Buy request unsuccessful, because payment service is not initialized"

func _finish_payment(successful):
	$PaymentCover.visible = false
	if successful:
		GameState.golden_eggs += pending_eggs
		_refresh_wallet()
		_update_all_items_enabled()
		GameState.save_state()
		purchase_complete.emit()
	pending_eggs = 0
	

func _init_google_play_integration():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		google_play_payment = Engine.get_singleton("GodotGooglePlayBilling")
		google_play_payment.connected.connect(_on_payment_service_connected)
		google_play_payment.disconnected.connect(_on_payment_service_disconnected)
		google_play_payment.connect_error.connect(_on_payment_service_connect_error)

		google_play_payment.product_details_query_completed.connect(_on_product_details_query_completed) # Products (Dictionary[])
		google_play_payment.product_details_query_error.connect(_on_product_details_query_error) # Response ID (int), Debug message (string), Queried SKUs (string[])
		google_play_payment.product_details_query_completed.connect(_on_product_details_query_completed) # Products (Dictionary[])
		google_play_payment.purchase_consumed.connect(_on_purchase_consumed) # Purchase token (string)
		google_play_payment.purchase_consumption_error.connect(_on_purchase_consumption_error) # Response ID (int), Debug message (string), Purchase token (string)
		google_play_payment.query_purchases_response.connect(_on_query_purchases_response) # Purchases (Dictionary[])
		google_play_payment.purchase_error.connect(_on_purchase_error) # Response ID (int), Debug message (string)
		google_play_payment.purchases_updated.connect(_on_purchases_updated) # Purchases (Dictionary[])

		google_play_payment.startConnection()
		$AddGoldenEggsButton.disabled = false
	else:
		print("Android IAP support is not enabled. IAP will not work.")
		$AddGoldenEggsButton.disabled = true
		$AddGoldenEggsButton/GoldenEggSprite.modulate.a = 0.3
		
func _on_payment_service_connected():
	$GooglePlayLabel.text = "Google play connected"
	google_play_payment.querySkuDetails([
		"golden_eggs_50",
		"golden_eggs_300",
		"golden_eggs_1000",
		"golden_eggs_5000",
		"golden_eggs_100000",
		], "inapp")
	
func _on_product_details_query_completed(product_details):
	var msg = "Available products: "
	
	for available_product in product_details:
		msg += available_product
	
func _on_payment_service_disconnected():
	print("Google play disconnected")
	
func _on_payment_service_connect_error(id, msg):
	print("Error while connecting: " + msg)
	
func _on_product_details_query_error(response_id, error_message, products_queried):
	print("on_product_details_query_error id:" + str(response_id) + " message: " + error_message)

func _on_purchase_error(id, msg):
	print("Error " + str(id) + " : " + msg)
	_finish_payment(false)
	
func _query_purchases():
	google_play_payment.queryPurchases("inapp") # Or "subs" for subscriptions

func _on_query_purchases_response(query_result):
	if query_result.status == OK:
		for purchase in query_result.purchases:
			_process_purchase(purchase)
	else:
		print("queryPurchases failed, response code: " + str(query_result.response_code) + " debug message: " + query_result.debug_message)

func _process_purchase(purchase):
	var pending_purchase_id = "golden_eggs_" + str(pending_eggs)
	if purchase.skus[0] == pending_purchase_id and not purchase.is_acknowledged:
		google_play_payment.consumePurchase(purchase.purchase_token)

func _on_purchase_acknowledgement_error(id, msg, token):
	print(msg)
	$GooglePlayLabel.text = "_on_purchase_acknowledgement_error id:" + str(id) + " message: " + msg + " token: " + token

func _on_purchases_updated(purchases):
	for purchase in purchases:
		_process_purchase(purchase)

func _on_purchase_consumed(purchase_token):
	_handle_purchase_token(purchase_token, true)

func _on_purchase_consumption_error(response_id, error_message, purchase_token):
	print("_on_purchase_consumption_error id:" + str(response_id) + " message: " + error_message)
	_handle_purchase_token(purchase_token, false)

func _handle_purchase_token(purchase_token, purchase_successful):
	_finish_payment(purchase_successful)
