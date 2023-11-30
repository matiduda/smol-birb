extends CharacterBody2D
class_name Player

const reduction = 0.2

const SPEED = 600.0
var jump_amped = false
var JUMP_VELOCITY = -1250.0
const BASE_JUMP_VELOCITY = -1250.0

var soundScene = preload("res://scenes/soundengine/soundengine.tscn")
var soundPlayer

const GRAVITY = 1000
const WINGS_ACTIVE_TIME_SECONDS = 4
const POSITION_TO_SCORE_SCALE = .01

var touch_direction = 0

var score = 0
var collected_eggs = 0
var collected_golden_eggs = 0
var wings_collected = false

const PLAYER_SKINS = {
	"Normal bird": "res://assets/characters/birb.png",
	"Special bird": "res://assets/characters/birb_special.png"
}

signal player_out_of_screen;

func _ready():
	soundPlayer = soundScene.instantiate()
	get_tree().root.add_child.call_deferred( soundPlayer)
	set_collision_layer_value(1, true)
	set_collision_mask_value(30, true)
	var skin_texture = load(PLAYER_SKINS[GameState.active_skin])
	$Sprite2D.set_texture(skin_texture)
	if GameState.wings_bought:
		activate_wings()
		GameState.wings_bought = false

func _physics_process(delta):
	# APPLY GRAVITY
	if not is_on_floor():
		# AFFINITY MAKES THE PLAYER FALL FASTER THE LONGER IN THE AIR
		# AND MAKES JUMPING MORE PLEASANT 
		var affinity = .03 * velocity.y if velocity.y > 0  else 2.5
		velocity.y += GRAVITY * delta + affinity
		
	# JUMP ON PLATFORM
	if is_on_floor():
		soundPlayer.playSound(soundPlayer.sounds.STEP)
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
	if global_position.y > get_parent().get_node("Camera2D").global_position.y + get_viewport_rect().size.y / 2:
		handle_game_over()

	# HANDLE PLAYER TEXTURE FLIP
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	if velocity.x < 0:
		$Sprite2D.flip_h = true
		
	if $Timer.is_stopped() and jump_amped:
		JUMP_VELOCITY = BASE_JUMP_VELOCITY
		jump_amped = false

	move_and_slide()
	for index in get_slide_collision_count():
		var collider = get_slide_collision(index).get_collider()
		if collider is BrokenPlatform:
			var collider_id = collider.get_instance_id()
			instance_from_id(collider_id).visible = false
			instance_from_id(collider_id).get_child(1).disabled = true
		if collider is JumpyPlatform:
			accelerate()

func handle_game_over():
	# HERE IF SECOND LIFE HAS BEEN BOUGHT WE ACTIVATE WINGS
	if GameState.second_life:
		global_position.y -= 50
		GameState.set_second_life(false, true)
		activate_wings()
		return
		
	soundPlayer.playSound(soundPlayer.sounds.DEATH)
	visible = false
	set_physics_process(false)
	player_out_of_screen.emit(score, collected_eggs, collected_golden_eggs)
	GameState.update_state(score, collected_eggs, collected_golden_eggs, true)
	
func add_item( item_type):
	if item_type == ItemType.EGG:
		soundPlayer.playSound(soundPlayer.sounds.EGG)
		collected_eggs += 1
	elif item_type == ItemType.GOLDEN_EGG:
		soundPlayer.playSound(soundPlayer.sounds.GOLDENEGG)
		collected_golden_eggs += 1
	elif item_type == ItemType.WINGS:
		if wings_collected:
			return
		activate_wings()
				
func activate_wings():
	wings_collected = true
	$PlayerWings.visible = true	
	$Particles.set_emitting(true)	
	$WingsTimer.start()
	soundPlayer.playSound(soundPlayer.sounds.WINGS)

func update_score():
	var new_score = int(abs(global_position.y) * POSITION_TO_SCORE_SCALE) #DEBUG + 490
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
	$Particles.set_emitting(false)
	
func accelerate():
	if JUMP_VELOCITY != BASE_JUMP_VELOCITY:
		return
	$Timer.start()
	jump_amped = true
	JUMP_VELOCITY *= 1.4
