extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var strength = 10 # TODO: read from character
# Called when the node enters the scene tree for the first time.
func _ready():
	var name = GameManager.getPitcherName()
	while name == GameManager.getPitcherName():
		name = GameManager.teamStats[0].playerNames[randi() % 3]
		
	var frames = load("res://Screens/MainGameScreen/Textures/racers/" + name + ".tres")
	sprite.frames = frames
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateTarget()
	updateMovement(delta)
	updateAttacking()
	updateZ()
	pass
	
onready var racetrack = $"../../Racetrack"
func updateZ():
	self.z_index = -racetrack.getTrackZFromY(self.position.y) * 0.1
	pass

var target = Vector2(0, 0)
onready var racer = $"../../Batter"
func updateTarget():
	target = racer.position - Vector2(50, 0)
	pass

var targetEpsilon = 1
var speed = 30
func updateMovement(delta):
	if isAttacking():
		return
	
	if abs(self.position.x - target.x) > targetEpsilon:
		if target.x > self.position.x:
			self.position.x += speed * delta
		else:
			self.position.x -= speed * delta
			
			
	if abs(self.position.y - target.y) > targetEpsilon:
		if target.y > self.position.y:
			self.position.y += speed * delta
		else:
			self.position.y -= speed * delta
	pass
	
func updateAttacking():
	updateAttackingStart()
	updateAttackingEnd()
	pass
	
onready var sprite = $Sprite
func updateAttackingStart():
	if isAttacking():
		return
	
	if (abs(self.position.x - target.x) <= targetEpsilon) && (abs(self.position.y - target.y) <= targetEpsilon):
		sprite.play("racing_swing_right")
		pass
		
	pass
	
var attackFrame = 3
func updateAttackingEnd():
	if !isAttacking():
		return
		
	if sprite.frame == attackFrame:
		racer.attackedWithBat(self.strength)
		
	if sprite.frame == sprite.frames.get_frame_count(sprite.animation) - 1:
		sprite.play("racing_swing_right")
	pass
	
func isAttacking():
	return sprite.animation == "racing_swing_right" || sprite.animation == "racing_swing_left"
