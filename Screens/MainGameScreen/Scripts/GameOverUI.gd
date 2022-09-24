extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start():
	setTypeSprite()
	self.visible = true
	pass
	
var isWin = false
onready var typeSprite = $Type
onready var gameOverSprite = $GameOver
func setTypeSprite():
	var typeTexture
	if GameManager.teamStats[0].drives > GameManager.teamStats[1].drives:
		typeTexture = load("res://Screens/MainGameScreen/Textures/LOSE.png")
		typeSprite.texture = typeTexture
	elif GameManager.teamStats[0].drives == GameManager.teamStats[1].drives:
		typeTexture = load("res://Screens/MainGameScreen/Textures/DRAW.png")
		typeSprite.texture = typeTexture
	else:
		isWin = true
		typeTexture = load("res://Screens/MainGameScreen/Textures/WIN.png")
		gameOverSprite.texture = typeTexture
		typeSprite.visible = false

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateDestruction(delta)
	pass
	
onready var fadeOut = $"../../FadeOut"
var lifeTime = 0
func updateDestruction(delta):
	if !self.visible:
		return
	lifeTime += delta
	if Input.is_action_just_pressed("restart_gameover"):
		var cb = funcref(self, "resetGame")
		fadeOut.startFadeout(1.0, cb)
		self.visible = false
	pass
	
func resetGame():
	if !isWin:
		GameManager.resetGameState()
		GameManager.skipToFinalInning()
		var _changed = get_tree().change_scene("res://Screens/MainGameScreen/MainGameScreen.tscn");
	else:
		GameManager.setStoryScriptName("2")
		var _changed = get_tree().change_scene("res://Screens/StoryScreen/StoryScreen.tscn");
	pass
