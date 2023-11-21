extends Camera2D

@onready var player = get_parent().get_node("Player")

func _process(_delta):
	if player != null and player.global_position.y < global_position.y:
		global_position = Vector2(0, player.global_position.y)
	get_parent().get_node("CanvasLayer/ScoreLabel").text = str(player.get_score())
