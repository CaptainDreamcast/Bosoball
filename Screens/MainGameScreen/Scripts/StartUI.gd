extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	setSprites()
	self.visible = true
	pass # Replace with function body.

onready var inningSprite = $Inning
onready var batterSprite = $Batter
onready var pitcherSprite = $Pitcher
onready var pitchCount = $PitchCount
func setSprites():
	var currentInning = GameManager.inning
	var batter = GameManager.getBatterName()
	var pitcher = GameManager.getPitcherName()
	var inningTexture = load("res://Screens/MainGameScreen/Textures/inning/" + str(currentInning) + ".png")
	inningSprite.texture = inningTexture
	var batterTexture = load("res://Screens/MainGameScreen/Textures/batting/" + batter + ".png")
	batterSprite.texture = batterTexture
	var pitcherTexture = load("res://Screens/MainGameScreen/Textures/pitching/" + pitcher + ".png")
	pitcherSprite.texture = pitcherTexture
	
	pitchCount.setSprites()
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
	if lifeTime > 2.0:
		self.visible = false
	pass
