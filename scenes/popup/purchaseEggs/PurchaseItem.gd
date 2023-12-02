extends Node2D

@export var price = 0
@export var amount = 0

signal select_purchase;

func _ready():
	$PriceLabel.text = str(price) + "PLN"
	$GoldenEggLabel.text = str(amount)
	
func _select_purchase():
	print("select!")
	select_purchase.emit(price, amount)

