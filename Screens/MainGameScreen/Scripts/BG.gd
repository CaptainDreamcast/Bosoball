extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lsdShader1 = preload("res://Screens/TitleScreen/Shaders/RacingScreen2.gdshader")
var lsdShader2 = preload("res://Screens/TitleScreen/Shaders/RacingScreen3.gdshader")
var portalShader = preload("res://Screens/TitleScreen/Shaders/RacingScreen.gdshader")
var noiseTexture = preload("res://Screens/TitleScreen/Textures/noise.png")
var warpShader = preload("res://Screens/MainGameScreen/Shaders/warp.gdshader")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = noiseTexture
	var index = int(rand_range(0, 1.99))
	if index == 0:
		self.material.shader = lsdShader2
	else:
		self.material.shader = lsdShader1
	
	pass # Replace with function body.



onready var player = $"../Batter"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateActiveShader()
	pass
	
func updateActiveShader():
	if player.state == player.PlayerState.RACING && self.material.shader != warpShader:
		self.material.shader = warpShader
		pass
		
	if self.material.shader == warpShader:
		var mat = self.get_material()
		mat.set_shader_param("speed", float(int(player.racingSpeed * 7)))
	pass
