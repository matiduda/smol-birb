extends Node2D

func _ready():
	self.visible = false

func _on_player_player_out_of_screen(collected_eggs, collected_golden_eggs):
	set_egg_count(collected_eggs)
	set_golden_egg_count(collected_golden_eggs)
	self.visible = true
	
func set_egg_count(number):
	$NinePatchRect/EggLabel.text = str(number)

func set_golden_egg_count(number):
	$NinePatchRect/GoldenEggLabel.text = str(number)
