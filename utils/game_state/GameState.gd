extends Node

const FILE_NAME = "user://save.tres"

@export var highscore: int = 0
@export var eggs: int = 0
@export var golden_eggs: int = 0
@export var second_life = false

# FOR LATER
@export var chest_keys: int = 0
@export var active_skin = "default"
@export var wings_bought = false

# RETRIEVE SAVED DATA
func _ready():
	load_state()
	
func update_state(score: int, collected_eggs: int,
				collected_golden_eggs: int, should_save: bool):
	if highscore < score:
		highscore = score
	eggs += collected_eggs
	golden_eggs += collected_golden_eggs
	
	if should_save:
		save_state()

func set_second_life(second_life: bool, should_save: bool):
	self.second_life = second_life
	
	if should_save:
		save_state()
	
func load_state() -> void:
	if ResourceLoader.exists(FILE_NAME):
		var data = ResourceLoader.load(FILE_NAME)
		if data is DataToSave:
			highscore = data.highscore
			eggs = data.eggs
			golden_eggs = data.golden_eggs
			second_life = data.second_life
	else:
		print("CANNOT LOAD SAVED DATA")

func save_state():
	var data = DataToSave.new()
	data.highscore = highscore
	data.eggs = eggs
	data.golden_eggs = golden_eggs
	data.second_life = second_life
	var result = ResourceSaver.save(data, FILE_NAME)
	if result != OK:
		print("WARNING!! FAILED TO PERSIST GAME DATA IN FILE")
	
