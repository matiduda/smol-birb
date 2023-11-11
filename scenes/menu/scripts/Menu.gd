extends Node

func _ready():
	var data: SavedData = GameResourceSaver.load_data()
	$Eggs/EggLabel.text = str(data.eggs)
	$Eggs/GoldenEggLabel.text = str(data.golden_eggs)
