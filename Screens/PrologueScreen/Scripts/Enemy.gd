extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateHitMovement(delta)
	pass

onready var sprite = $Sprite

func getHit():
	sprite.play("get_hit")
	pass
	
func updateHitMovement(delta):
	if sprite.animation != "get_hit":
		return
		
	self.rotation_degrees += delta * 1000
	self.scale.x = max(0, self.scale.x - delta)
	self.scale.y = max(0, self.scale.y - delta)
	self.position.y -= delta * 100
