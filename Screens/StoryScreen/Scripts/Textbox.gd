extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(mainText)
	assert(nameText)
	pass # Replace with function body.

onready var sprites = [$"../CutsceneSprite/Sprite", $"../CutsceneSprite2/Sprite", $"../CutsceneSprite3/Sprite"]

onready var mainText = $MainBody/TextRoot/Text
onready var nameText = $Namefield/TextRoot/Text
func setText(newMainText, newNameText, shouldBeBuiltUp):
	mainText.text = newMainText
	nameText.text = newNameText
	
	if(shouldBeBuiltUp):
		#false but good enough for now
		for sprite in sprites:
			if sprite.visible && sprite.frames.has_animation("speaking"):
				sprite.play("speaking")
				pass
		
		mainText.visible_characters = 0
		textBuildUpNow = 0
	else:
		mainText.visible_characters = -1
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateTextBuildup(delta)
	updateInput()
	pass

var textBuildUpNow = 0
var textBuildUpSpeed = 0.1
func updateTextBuildup(delta):
	if mainText.visible_characters == -1:
		return
		
	textBuildUpNow += delta
	while textBuildUpNow > textBuildUpSpeed:
		mainText.visible_characters += 1
		textBuildUpNow -= textBuildUpSpeed
		if mainText.percent_visible >= 1.0:
			for sprite in sprites:
				if sprite.visible && sprite.frames.has_animation("default"):
					sprite.play("default")
			mainText.visible_characters = -1
		pass
		
	pass
	
onready var cutsceneManager = $"../CutsceneManager"
func updateInput():
	if Input.is_action_just_pressed("advance_story_text"):
		if mainText.percent_visible >= 1.0:
			cutsceneManager.loadNextStoryIndex()
			pass
		else:
			mainText.percent_visible = 1.0;
			for sprite in sprites:
				if sprite.visible && sprite.frames.has_animation("default"):
					sprite.play("default")
	pass
