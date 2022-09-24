extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

onready var thSprite = $thSprite
onready var counterDigits = [$"Counter/1", $"Counter/2", $"Counter/3"]

func setSprites():
	var pitchCount = GameManager.pitchCount + 1
	var pitchDigits = Util.numberToDigitArray(pitchCount)
	selectThSprite(pitchCount, pitchDigits);
	setDigits(pitchDigits)
	pass
	
func selectThSprite(pitchCount, pitchDigits):
	var thName;
	if pitchCount == 11 || pitchCount == 12 || pitchCount == 13:
		thName = "th"
	elif pitchDigits[0] == 1:
		thName = "st"
	elif pitchDigits[0] == 2:
		thName = "nd"
	elif pitchDigits[0] == 3:
		thName = "rd"
	else:
		thName = "th";
	
	var thTexture = load("res://Screens/MainGameScreen/Textures/th/" + thName + ".png")
	thSprite.texture = thTexture
	pass
	
func setDigits(pitchDigits):
	if pitchDigits.size() > 3:
		pitchDigits.resize(3);
		
	for i in range(0, pitchDigits.size()):
		var digit = pitchDigits[i]
		var digitSprite = counterDigits[i];
		var digitTexture = load("res://Screens/MainGameScreen/Textures/pitchcountnumbers/" + str(digit) + ".png")
		digitSprite.texture = digitTexture
		digitSprite.visible = true
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
