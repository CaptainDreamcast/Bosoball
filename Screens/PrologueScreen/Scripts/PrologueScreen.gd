extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
onready var fadeInPrefab = preload("res://Screens/PrologueScreen/Prefabs/FadeIn.tscn")
func _ready():	
	var fadeIn = fadeInPrefab.instance()
	self.add_child(fadeIn)
	loadCorrectScreen()
	pass # Replace with function body.

onready var bg = $BG
onready var rider = $Rider
onready var riderAnimation = $Rider/Sprite
onready var enemy = $Enemy
onready var enemyAnimation = $Enemy/Sprite
onready var movingText = $MovingText
onready var movingTextSprite = $MovingText/Sprite
onready var fadeOut = $FadeOut
func loadCorrectScreen():
	if GameManager.currentPrologue == 0:
		loadAncientScreen()
	elif GameManager.currentPrologue == 1:
		loadCowboyScreen()
	else:
		loadSpaceScreen()
	pass

onready var ancientBG = preload("res://Screens/PrologueScreen/Textures/ANCIENT/BG.png")
onready var ancientRiderFrames = preload("res://Screens/PrologueScreen/Textures/ANCIENT/rider.tres")
onready var ancientEnemyFrames = preload("res://Screens/PrologueScreen/Textures/ANCIENT/enemy.tres")
onready var ancientText = preload("res://Screens/PrologueScreen/Textures/TEXT1.png")
func loadAncientScreen():
	bg.texture = ancientBG
	riderAnimation.frames = ancientRiderFrames
	enemyAnimation.frames = ancientEnemyFrames
	movingTextSprite.texture = ancientText
	pass
	
onready var cowboyBG = preload("res://Screens/PrologueScreen/Textures/COWBOY/BG.png")
onready var cowboyRiderFrames = preload("res://Screens/PrologueScreen/Textures/COWBOY/rider.tres")
onready var cowboyEnemyFrames = preload("res://Screens/PrologueScreen/Textures/COWBOY/enemy.tres")
onready var cowboyText = preload("res://Screens/PrologueScreen/Textures/TEXT2.png")
func loadCowboyScreen():
	bg.texture = cowboyBG
	riderAnimation.frames = cowboyRiderFrames
	enemyAnimation.frames = cowboyEnemyFrames
	movingTextSprite.texture = cowboyText
	pass
	
onready var spaceBG = preload("res://Screens/PrologueScreen/Textures/SPACE/BG.png")
onready var spaceRiderFrames = preload("res://Screens/PrologueScreen/Textures/SPACE/rider.tres")
onready var spaceEnemyFrames = preload("res://Screens/PrologueScreen/Textures/SPACE/enemy.tres")
onready var spaceText = preload("res://Screens/PrologueScreen/Textures/TEXT3.png")
func loadSpaceScreen():
	bg.texture = spaceBG
	riderAnimation.frames = spaceRiderFrames
	enemyAnimation.frames = spaceEnemyFrames
	movingTextSprite.texture = spaceText
	rider.position.y -= 50
	enemy.position.y -= 50
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	checkOver()
	pass

func checkOver():
	if enemy.scale.x < 1e-4 && movingText.modulate.a < 1e-4:
		var cb = funcref(self, "gotoNextScreen")
		fadeOut.startFadeout(1.0, cb)
		pass
	pass
	
func gotoNextScreen():
	GameManager.increasePrologue();
	if GameManager.currentPrologue < 3:	
		var _changed = get_tree().change_scene("res://Screens/PrologueScreen/PrologueScreen.tscn");
	else:
		GameManager.setStoryScriptName("1")
		var _changed = get_tree().change_scene("res://Screens/StoryScreen/StoryScreen.tscn");
	pass
