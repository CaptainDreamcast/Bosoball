extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateRemoval()
	pass

var callback = null
var animationName = "default"
onready var sprite = $Sprite
func updateRemoval():
	if sprite.frame == sprite.frames.get_frame_count(animationName) - 1:
		if callback:
			callback.call_func()
		self.queue_free()
		pass
	pass

func setAnimation(frames, newAnimationName = "default", cb = null):
	sprite.frames = frames
	animationName = newAnimationName
	sprite.play(newAnimationName)
	sprite.frame = 0
	callback = cb
	pass
