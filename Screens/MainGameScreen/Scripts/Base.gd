extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#updateSprite()
	#updateBasePassed()
	pass # Replace with function body.

func initWithBasePosition(positionZ):
	if racetrack.distanceTravelled >= positionZ:
		isActive = false
	pass

onready var racetrack = $"../../Racetrack"
onready var sprite = $Sprite
func updateSprite():
	sprite.position.y = racetrack.getYFromZ(basePositionZ)
	sprite.scale.x = racetrack.getScaleXFromZ(basePositionZ)
	sprite.scale.y = sprite.scale.x
	pass
	
onready var hitEffectPrefab = preload("res://Screens/PrologueScreen/Prefabs/AnimationEffect.tscn")
onready var effectRoot = $"../../UI"
onready var baseReachedAnimation = preload("res://Screens/MainGameScreen/Textures/strike_animation.tres")
var basePositionZ = 1000
var index = 0
var isActive = true
func updateBasePassed():
	if !isActive:
		return
		
	if racetrack.distanceTravelled >= basePositionZ:
		var newHitEffect = hitEffectPrefab.instance()
		effectRoot.add_child(newHitEffect)
		newHitEffect.position = Vector2(0, 0)
		newHitEffect.setAnimation(baseReachedAnimation)
		isActive = false
		
		if(index < 3):
			GameManager.addDrive()
			pass
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
