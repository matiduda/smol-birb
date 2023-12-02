extends Node2D

#QUICK TUTORIAL:
# In global declarations:
#	var soundScene = preload("res://scenes/soundengine/soundengine.tscn")
#	var soundPlayer 
#	--------------------
# In _ready() function:
#	soundPlayer = soundScene.instantiate()
#	get_tree().root.add_child.call_deferred(soundPlayer)
#	--------------------
# On action done:
#	soundPlayer.playSound(soundPlayer.sounds.<name of sound to play>, eg. WINGS)

enum sounds
{
	STEP,
	WINGS,
	DEATH,
	EGG,
	GOLDENEGG,
	BUTTONPRESS,
	PURCHASE_COMPLETE
}

#Audio StreamPlayer
var step = load("res://assets/sounds/Footstep.mp3")
var wings = load("res://assets/sounds/wings.mp3")
var death = load("res://assets/sounds/player_damage.mp3")
var egg = load("res://assets/sounds/egg.wav")
var goldenegg = load("res://assets/sounds/goldenegg.wav")
var buttonpress = load("res://assets/sounds/buttonpress.wav")
var purchase_complete = load("res://assets/sounds/purchase_complete.mp3")


# TO BE CONTINUED...

func playSound( soundName, volume = 0):
	var newSound = AudioStreamPlayer.new()
	newSound.bus = "Master"
	
	self.add_child( newSound)
	
	match( soundName):
		
		sounds.STEP:
			newSound.stream = step
			newSound.volume_db += 6
			
		sounds.WINGS:
			newSound.stream = wings
			newSound.volume_db += -10
			
		sounds.DEATH:
			newSound.stream = death
			
		sounds.EGG:
			newSound.stream = egg
			newSound.volume_db += -5
			
		sounds.GOLDENEGG:
			newSound.stream = goldenegg
			newSound.volume_db += -5
			
		sounds.BUTTONPRESS:
			newSound.stream = buttonpress
			
		sounds.PURCHASE_COMPLETE:
			newSound.stream = purchase_complete

	newSound.volume_db += volume
	newSound.play()

	newSound.finished.connect(newSound.queue_free)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
