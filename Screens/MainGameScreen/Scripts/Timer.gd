extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var isActive = false
var timeLeft = 0
func startTimer(seconds):
	timeLeft = seconds
	isActive = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isActive:
		return
	
	updateCountdown(delta)
	updateDigits()
	pass

onready var racer = $"../../../Batter"
func updateCountdown(delta):
	timeLeft -= delta
	timeLeft = max(0, timeLeft)
	if timeLeft == 0:
		racer.timeOut()
		isActive = false
		pass
	pass

onready var digitOneUi = $"1"
onready var digitTwoUi = $"2"
onready var digitThreeUi = $"3"
onready var digitFourUi = $"4"
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
	preload("res://Screens/MainGameScreen/Textures/UI_SMALL_9.png")]
	
func updateDigits():
	var digit1
	var digit2
	var digit3
	var digit4
	
	digit1 = int((int(timeLeft)) / 10)
	if(digit1 > 9):
		digit1 = 9
		digit2 = 9
		digit3 = 9
		digit4 = 9
	else:
		digit2 = (int(timeLeft)) % 10
		var fraction = timeLeft - int(timeLeft)
		var fractionNumber = int(fraction * 100)
		digit3 = int((int(fractionNumber)) / 10)
		digit4 = (int(fractionNumber)) % 10
	
	digitOneUi.texture = digitTextures[digit1]
	digitTwoUi.texture = digitTextures[digit2]
	digitThreeUi.texture = digitTextures[digit3]
	digitFourUi.texture = digitTextures[digit4]
	pass
