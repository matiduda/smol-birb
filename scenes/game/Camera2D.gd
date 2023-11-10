extends Camera2D

@onready var player = get_parent().get_node("Player")

func _process(delta):
	if player != null and player.position.y < self.position.y:
		self.position = Vector2(360, player.position.y)
