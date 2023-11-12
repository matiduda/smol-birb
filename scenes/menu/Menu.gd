extends Node

func _ready():
	$Eggs/EggLabel.text = str(GameState.eggs)
	$Eggs/GoldenEggLabel.text = str(GameState.golden_eggs)
