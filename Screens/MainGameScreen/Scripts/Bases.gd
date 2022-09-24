extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var base1 = $Base
onready var base2 = $Base2
onready var base3 = $Base3
onready var base4 = $Base3
# Called when the node enters the scene tree for the first time.
func _ready():
	base1.index = 0
	base1.basePositionZ = 1000
	base2.index = 1
	base2.basePositionZ = 2000
	base3.index = 2
	base3.basePositionZ = 3000
	base4.index = 3
	base4.basePositionZ = 4000
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
