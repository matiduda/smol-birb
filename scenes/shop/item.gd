class_name ShopItem extends Control

const button_standard_icon = preload("res://assets/items/egg.png");
const button_golden_icon = preload("res://assets/items/golden_egg.png");

var item_type: int = ShopItemType.Normal
var item_name: String = ""
var item_price: int = 0

signal buy_requested

func _ready():
	$SpecialBackground.visible = false
	$StandardBackground.visible = false
	
func set_item_type(type: int):
	item_type = type
	match type:
		ShopItemType.Normal:
			$StandardBackground.visible = true
			$VBoxContainer/Button.icon = button_standard_icon
		ShopItemType.Golden:
			$VBoxContainer/Button.icon = button_golden_icon
			$SpecialBackground.visible = true
	
func set_item_name(value: String):
	item_name = value
	$VBoxContainer/Label.text = value

func set_item_texture(path: String):
	$VBoxContainer/ItemTexture.texture = ResourceLoader.load(path)

func set_price(price: int):
	item_price = price
	$VBoxContainer/Button.text = str(price)

func set_enabled(enough_funds_for_item: bool):
	$VBoxContainer/Button.disabled = !enough_funds_for_item

func _on_button_pressed():
	emit_signal("buy_requested", item_name)
