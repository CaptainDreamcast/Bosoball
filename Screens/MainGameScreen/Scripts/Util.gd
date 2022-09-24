extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# More at https://easings.net/
func easeOutSine(x):
	return sin((x * PI) / 2);

func randomSign():
	if (randi() % 2) == 0:
		return -1
	else:
		return 1

func numberToDigitArray(number):
	var ret = []
	while number >= 10:
		var digit = number % 10;
		ret.push_back(digit)
		number /= 10;
	ret.push_back(number)
	return ret;
