extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var isFadingIn = true
var fadeinTime = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateFadein(delta)
	pass
	
onready var texture = $Texture
var fadeinNow = 0.0
func updateFadein(delta):
	if !isFadingIn:
		return
	
	fadeinNow = min(fadeinTime, fadeinNow + delta)
	var factor = 1.0 - (fadeinNow / fadeinTime)
	texture.modulate.a = factor
	if fadeinNow == fadeinTime:
		isFadingIn = false
		self.queue_free()
		
	pass
	
