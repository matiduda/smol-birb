extends Node2D

func _ready():
	self.visible = false

func _on_player_player_out_of_screen():
	self.visible = true
