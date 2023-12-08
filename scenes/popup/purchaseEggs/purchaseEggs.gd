extends Node2D

signal request_exit;
signal select_item;

func _ready():
	_init_children()

func _init_children():
	$NinePatchRect/PurchaseItem.connect("select_purchase", _on_select_golden_egg_purchase)
	$NinePatchRect/PurchaseItem2.connect("select_purchase", _on_select_golden_egg_purchase)
	$NinePatchRect/PurchaseItem3.connect("select_purchase", _on_select_golden_egg_purchase)
	$NinePatchRect/PurchaseItem4.connect("select_purchase", _on_select_golden_egg_purchase)
	$NinePatchRect/PurchaseItem5.connect("select_purchase", _on_select_golden_egg_purchase)

func _request_exit():
	request_exit.emit()

func _on_select_golden_egg_purchase(price, amount):
	select_item.emit(price, amount)
