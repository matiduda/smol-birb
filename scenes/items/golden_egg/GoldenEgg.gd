extends Area2D

func _on_body_entered(body):
	if body is Player:
		(body as Player).add_item(ItemType.GOLDEN_EGG)
		queue_free()
