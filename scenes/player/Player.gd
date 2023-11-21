extends CharacterBody2D
class_name Player

const SPEED = 600.0
const JUMP_VELOCITY = -1250.0
const GRAVITY = 1000
const WINGS_ACTIVE_TIME_SECONDS = 4
const POSITION_TO_SCORE_SCALE = .01

var touch_direction = 0

var score = 0
var collected_eggs = 0
var collected_golden_eggs = 0
var wings_collected = false

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
	
	# BOOST FROM WINGS
	if wings_collected:
		velocity.y = JUMP_VELOCITY
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if touch_direction:
		velocity.x = touch_direction * SPEED
	else:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# TELEPORT PLAYER TO LEFT OR RIGHT SCREEN SIDE WHEN OUT OF BOUNDS
	if global_position.x < -get_viewport_rect().size.x / 2:
		global_position.x = get_viewport_rect().size.x / 2
	elif global_position.x > get_viewport_rect().size.x / 2:
		global_position.x = -get_viewport_rect().size.x / 2
	
	# UPDATE SCORE
	if velocity.y < 0:
		update_score()
	
	# HANDLE GAME OVER
	if global_position.y > get_parent().get_node("Camera2D").global_position.y + get_viewport_rect().size.y / 2 and not player_dead:
		handle_game_over()

	move_and_slide()

func handle_game_over():
	player_dead = true
	player_out_of_screen.emit(score, collected_eggs, collected_golden_eggs)
	GameState.update_state(score, collected_eggs, collected_golden_eggs, true)
	
func add_item(item_type):
	if item_type == ItemType.EGG:
		collected_eggs += 1
	elif item_type == ItemType.GOLDEN_EGG:
		collected_golden_eggs += 1
	elif item_type == ItemType.WINGS:
		if wings_collected:
			return
		wings_collected = true
		$PlayerWings.visible = true
		$WingsTimer.start()
				
func update_score():
	var new_score = int(abs(global_position.y) * POSITION_TO_SCORE_SCALE)
	if new_score > score:
		score = new_score

func get_score():
	return score

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
	
func _on_wings_timer_timeout():
	wings_collected = false
	$PlayerWings.visible = false
