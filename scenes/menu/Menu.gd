extends Node

signal game_start_requested;

func _ready():
	$LoadingBackground.visible = false
	$LoadingContainer.visible = false
	
	$Eggs/EggLabel.text = str(GameState.eggs)
	$Eggs/GoldenEggLabel.text = str(GameState.golden_eggs)
	$HighscoreLabel.text += str(GameState.highscore)
	
func _onGameStart():
	$LoadingBackground.visible = true
	$LoadingContainer.visible = true
	game_start_requested.emit()
