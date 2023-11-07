extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -1250.0
var GRAVITY = 1000

func _physics_process(delta):
	# APPLY GRAVITY
	if not is_on_floor():
		# AFFINITY MAKES THE PLAYER FALL FASTER THE LONGER IN THE AIR
		# AND MAKES JUMPING MORE PLEASANT 
		var affinity = .03 * velocity.y if velocity.y > 0  else 2.5
		velocity.y += GRAVITY * delta + affinity
		
	# JUMP ON PLATFORM
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# HERE WE USE ARROWS TO MOVE, SHOULD CHANGE TO GYROSCOPE LATER
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# TELEPORT PLAYER TO LEFT OR RIGHT SCREEN SIDE WHEN OUT OF BOUNDS
	if global_position.x < 0:
		global_position.x = get_viewport_rect().size.x
	elif global_position.x > get_viewport_rect().size.x:
		global_position.x = 0
	
	# HANDLE GAME OVER
	if global_position.y > get_viewport_rect().size.y:
		handle_game_over()

	move_and_slide()

func handle_game_over():
	print("GAME OVER")
	queue_free()
