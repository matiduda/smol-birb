extends Node2D

func _ready():
	self.visible = false

func _on_player_player_out_of_screen(score, collected_eggs, collected_golden_eggs):
	set_score(score)
	set_egg_count(collected_eggs)
	set_golden_egg_count(collected_golden_eggs)
	set_total_egg_count(GameState.eggs)
	set_total_golden_egg_count(GameState.golden_eggs)
	$NinePatchRect/ResumeButton.set_disabled(GameState.golden_eggs < 5)
	self.visible = true

func set_score(score):
	$NinePatchRect/ScoreLabel.text = "Score: " + str(score)

func set_egg_count(number):
	$NinePatchRect/EggLabel.text = str(number)

func set_golden_egg_count(number):
	$NinePatchRect/GoldenEggLabel.text = str(number)

func set_total_egg_count(number):
	$NinePatchRect/TotalEggLabel.text = str(number)

func set_total_golden_egg_count(number):
	$NinePatchRect/TotalGoldenEggLabel.text = str(number)
