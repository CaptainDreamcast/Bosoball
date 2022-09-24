extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

onready var sprite = $Sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateMovement(delta)
	updateHit()
	pass

var speed = 200
func updateMovement(delta):
	if sprite.animation == "racing_swing_right":
		return
	
	if Input.is_action_pressed("title_move_left"):
		self.position.x -= delta * speed
		self.position.x = max(-160, self.position.x)
		sprite.play("racing_move_left")
		pass
	elif Input.is_action_pressed("title_move_right"):
		self.position.x += delta * speed
		self.position.x = min(160, self.position.x)
		sprite.play("racing_move_right")
		pass
	else:
		sprite.play("racing")
		
	pass
	
func updateHit():
	updateHitStart()
	updateHitConnect()
	updateHitEnd()
	pass
	
func updateHitStart():
	if sprite.animation == "racing_swing_right":
		return
		
	if Input.is_action_just_pressed("title_attack"):
		sprite.play("racing_swing_right")
		
	pass
	
onready var hitToStart = $"../HitToStart"
func updateHitConnect():
	if sprite.animation != "racing_swing_right":
		return
	
	if sprite.frame == 1 && self.position.x > -45 && self.position.x < 85:
		hitToStart.hit()
	
	pass
	
func updateHitEnd():
	if sprite.animation != "racing_swing_right":
		return
		
	if sprite.frame == sprite.frames.get_frame_count("racing_swing_right") - 1:
		sprite.play("racing")
		pass
	pass
