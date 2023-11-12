extends Area2D

func _ready():
	if name == "PlayerWings":
		$CollisionShape2D.disabled = true
	$AnimationPlayer.play("flap")

func _on_body_entered(body):
	if body is Player:
		(body as Player).add_item(ItemType.WINGS)
		queue_free()
