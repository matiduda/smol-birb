extends Node

signal game_start_requested;

var soundScene = preload("res://scenes/soundengine/soundengine.tscn")
var soundPlayer

func _ready():
	soundPlayer = soundScene.instantiate()
	get_tree().root.add_child.call_deferred(soundPlayer)
	
	$LoadingBackground.visible = false
	$LoadingContainer.visible = false
	
	$Eggs/EggLabel.text = str(GameState.eggs)
	$Eggs/GoldenEggLabel.text = str(GameState.golden_eggs)
	$HighscoreLabel.text += str(GameState.highscore)
	
func _onGameStart():
	soundPlayer.playSound(soundPlayer.sounds.BUTTONPRESS)
	$LoadingBackground.visible = true
	$LoadingContainer.visible = true
		
	var t = Timer.new()
	t.set_wait_time(0.01)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout
	_loadGame()
	
func _loadGame():
	game_start_requested.emit(true)
	
