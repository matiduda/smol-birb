extends StaticBody2D

@onready var player_position = get_parent().get_node("Player").position

func _process(delta):
	player_position = get_parent().get_node("Player").position
	if player_position.y > self.position.y:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
	pass

