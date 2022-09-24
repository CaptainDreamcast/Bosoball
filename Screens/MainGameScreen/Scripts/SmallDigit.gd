extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

onready var digitTextures = [
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_0.png"),
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_1.png"),
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_2.png"),
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_3.png"),
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_4.png"),
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_5.png"),
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_6.png"),
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_7.png"),
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_8.png"),
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_9.png")
	]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setDigit(number):
	number = number % 10;
	texture = digitTextures[number]
	pass
