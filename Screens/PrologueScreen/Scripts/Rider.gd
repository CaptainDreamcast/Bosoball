extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateMovement(delta)
	updateHit()
	updateAnimation()
	pass

var isHitInMotion = false
var hasHitConnected = false
func updateMovement(delta):
	if isHitInMotion:
		return
		
	if Input.is_action_pressed("prologue_move_left"):
		self.position.x -= 100 * delta
	if Input.is_action_pressed("prologue_move_right"):
		self.position.x += 100 * delta
	pass

func updateHit():
	updateHitStart()
	updateHitConnect();
	updateHitEnd()
	pass
	
onready var sprite = $Sprite
func updateHitStart():
	if isHitInMotion:
		return
	
	if Input.is_action_just_pressed("prologue_hit"):
		var animation = "hit"
		if Input.is_action_pressed("prologue_move_left"):
			animation = "hit_left"
		if Input.is_action_pressed("prologue_move_right"):
			animation = "hit_right"
		
		sprite.play(animation)
		isHitInMotion = true
		hasHitConnected = false
		pass
	pass
	
onready var enemy = $"../Enemy"
onready var enemySprite = $"../Enemy/Sprite"
onready var hitEffectPrefab = preload("res://Screens/PrologueScreen/Prefabs/AnimationEffect.tscn")
onready var effectRoot = $"../EffectRoot"
func updateHitConnect():
	if !isHitInMotion || sprite.frame != 1 || hasHitConnected:
		return
		
	if(self.position.x < 20 || self.position.x > 200):
		return
		
	if enemySprite.animation != "get_hit":
		enemy.getHit()
		var newHitEffect = hitEffectPrefab.instance()
		newHitEffect.position = self.position + Vector2(40, -20)
		effectRoot.add_child(newHitEffect)

	hasHitConnected = true
	
func updateHitEnd():
	if !isHitInMotion:
		return
		
	if sprite.frame == 2:
		isHitInMotion = false
	pass

func updateAnimation():
	if isHitInMotion:
		return
		
	var animation = "default";
	if Input.is_action_pressed("prologue_move_left"):
		animation = "move_left"
	if Input.is_action_pressed("prologue_move_right"):
		animation = "move_right"
	if animation != sprite.animation:
		sprite.play(animation)
	
	pass
