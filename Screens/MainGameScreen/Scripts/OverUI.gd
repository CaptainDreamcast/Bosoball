extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

enum OverType{
  TIMEOUT,
  DESTROYED,
  DRIVE
}

enum WhereType{
  BASE1,
  BASE2,
  BASE3,
  BASE4,
  OUT
}

var afterDoneCB = null
func startOverUI(overType, whereType, cb):
	setOverSpriteFromType(overType)
	setWhereSpriteFromType(whereType)
	afterDoneCB = cb
	self.visible = true
	pass
	
onready var typeSprite = $Type
func setOverSpriteFromType(type):
	var overTexture
	if type == OverType.TIMEOUT:
		overTexture = load("res://Screens/MainGameScreen/Textures/TIMEOUT.png")
	elif type == OverType.DESTROYED:
		overTexture = load("res://Screens/MainGameScreen/Textures/DESTROYED.png")
	else:
		overTexture = load("res://Screens/MainGameScreen/Textures/DRIVE.png")
		pass

	typeSprite.texture = overTexture
	pass

onready var whereSprite = $Where
func setWhereSpriteFromType(type):
	var whereTexture
	if type == WhereType.BASE1:
		whereTexture = load("res://Screens/MainGameScreen/Textures/BASE1.png")
	elif type == WhereType.BASE2:
		whereTexture = load("res://Screens/MainGameScreen/Textures/BASE2.png")
	elif type == WhereType.BASE3:
		whereTexture = load("res://Screens/MainGameScreen/Textures/BASE3.png")
	elif type == WhereType.BASE4:
		whereTexture = load("res://Screens/MainGameScreen/Textures/BASE4.png")
	else:
		whereTexture = load("res://Screens/MainGameScreen/Textures/OUT.png")
		pass

	whereSprite.texture = whereTexture
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateDestruction(delta)
	pass
	
var lifeTime = 0
func updateDestruction(delta):
	if !self.visible:
		return
	lifeTime += delta
	if lifeTime > 3.0:
		if afterDoneCB:
			afterDoneCB.call_func()
		self.visible = false
	pass
