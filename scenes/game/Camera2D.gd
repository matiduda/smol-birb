extends Camera2D

@onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null and player.position.y < self.position.y:
		self.position = Vector2(360, player.position.y)
	pass
