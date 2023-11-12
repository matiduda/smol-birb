extends CharacterBody2D
class_name Player

const SPEED = 600.0
const JUMP_VELOCITY = -1250.0
var GRAVITY = 1000

var touch_direction = 0

var highscore = 0
var collected_eggs = 0
var collected_golden_eggs = 0

var player_dead = false
signal player_out_of_screen;

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
	#if $LeftTouchArea.is_pressed():
	
	var direction = Input.get_axis("ui_left", "ui_right")
	var accelerometer = Input.get_accelerometer()
	
	if touch_direction:
		velocity.x = touch_direction * SPEED
	elif accelerometer.x != 0:
		velocity.x = accelerometer.x * SPEED
	else:
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
	if global_position.y > get_viewport_rect().size.y and not player_dead:
		handle_game_over()

	move_and_slide()

func handle_game_over():
	player_dead = true
	player_out_of_screen.emit(collected_eggs, collected_golden_eggs)
	GameState.update_state(highscore, collected_eggs, collected_golden_eggs, true)
	
func add_item(item_type):
	if item_type == ItemType.EGG:
		collected_eggs += 1
	elif item_type == ItemType.GOLDEN_EGG:
		collected_golden_eggs += 1
		
func get_collected_eggs():
	return collected_eggs
	
func get_collected_golden_eggs():
	return collected_golden_eggs
	
func set_touch_direction_left():
	touch_direction = -1

func set_touch_direction_right():
	touch_direction = 1
	
func reset_touch():
	touch_direction = 0
	

