extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
onready var fadeInPrefab = preload("res://Screens/PrologueScreen/Prefabs/FadeIn.tscn")
func _ready():
	GameManager.totalReset()
	var fadeIn = fadeInPrefab.instance()
	self.add_child(fadeIn)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
