extends StaticBody2D

@onready var player_position = get_parent().get_node("Player").position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_position = get_parent().get_node("Player").position
	if player_position.y > self.position.y:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
	pass

