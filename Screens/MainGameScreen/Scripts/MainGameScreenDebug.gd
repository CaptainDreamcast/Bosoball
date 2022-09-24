extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var battingUI = $"../UI/Batting"
# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.inning == 1:
		GameManager.skipToFinalInning()
	battingUI.updateBattingUIDisplay()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#updatePitchStartDebugInput()
	pass
	
onready var pitcher = $"../Pitcher"
func updatePitchStartDebugInput():
	if Input.is_action_just_pressed("debug_pitcherthrow") && !has_node("../Baseball"):
		pitcher.startThrowing()
		pass
	pass
