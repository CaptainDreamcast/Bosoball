extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateTime(delta)
	updateMovement(delta)
	updateFadeIn()
	updateFadeOut()
	pass

var lifeTime = 0
func updateTime(delta):
	lifeTime += delta
	pass

func updateMovement(delta):
	self.position.y += delta * 10
	pass
	
var fadeInDuration = 1.0
func updateFadeIn():
	if self.modulate.a == 1.0 || lifeTime > fadeOutStart:
		return
		
	var t = lifeTime / fadeInDuration;
	self.modulate.a = min(1.0, t)
	pass
	
var fadeOutStart = 4.0
var fadeOutDuration = 1.0
func updateFadeOut():
	if lifeTime < fadeOutStart:
		return
		
	var t = (lifeTime - fadeOutStart) / fadeOutDuration
	self.modulate.a = max(0.0, 1.0 - t)
		
	pass
