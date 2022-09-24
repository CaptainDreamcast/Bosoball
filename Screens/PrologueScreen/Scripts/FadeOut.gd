extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var isFadingOut = false
var afterFadeoutCB;
var fadeoutTime = 1.0
func startFadeout(duration, cb):
	fadeoutTime = duration
	afterFadeoutCB = cb
	isFadingOut = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateFadeout(delta)
	pass
	
onready var texture = $Texture
var fadeoutNow = 0.0
func updateFadeout(delta):
	if !isFadingOut:
		return
	
	fadeoutNow = min(fadeoutTime, fadeoutNow + delta)
	var factor = fadeoutNow / fadeoutTime
	texture.modulate.a = factor
	if fadeoutNow == fadeoutTime:
		afterFadeoutCB.call_func()
		
	pass
	
