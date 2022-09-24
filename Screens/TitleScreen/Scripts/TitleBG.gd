extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lsdShader1 = preload("res://Screens/TitleScreen/Shaders/RacingScreen2.gdshader")
var lsdShader2 = preload("res://Screens/TitleScreen/Shaders/RacingScreen3.gdshader")
var portalShader = preload("res://Screens/TitleScreen/Shaders/RacingScreen.gdshader")
var noiseTexture = preload("res://Screens/TitleScreen/Textures/noise.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = noiseTexture
	self.material.shader = portalShader
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
