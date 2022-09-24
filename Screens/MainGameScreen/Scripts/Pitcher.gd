extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	getBaseScaleAndTrackZ()
	var frames = load("res://Screens/MainGameScreen/Textures/racers/" + GameManager.getPitcherName() + ".tres")
	sprite.frames = frames
	sprite.play("pitching_idle")
	
	if GameManager.isFirstHalf:
		initPlayer();
	else:
		pass
	
	pass # Replace with function body.

onready var targetRectangleParent = $"../TargetRectangle"
onready var targetRectangle = $"../TargetRectangle/Rectangle"
onready var targetArrow = $"../TargetRectangle/Arrow"
onready var hitCore = $"../Batter/HitCore"
func initPlayer():
	targetRectangleParent.visible = true
	targetRectangle.position.x = hitCore.get_global_position().x
	targetRectangle.position.y = hitCore.get_global_position().y
	pass

var baseScale = 1.0
var baseZ = 0.0
onready var racetrack = $"../Racetrack"
func getBaseScaleAndTrackZ():
	baseZ = racetrack.getTrackZFromY(self.position.y + 20.0)
	self.position.y = racetrack.getYFromZ(baseZ) - 20.0;
	baseScale = racetrack.getScaleXFromZ(baseZ)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.isFirstHalf:
		updatePlayerThrowing(delta)
		pass
	else:
		updateNpcThrowing(delta)
	updateThrowing()
	updatePosition()
	updateDestroy()
	updateZ()
	pass
	
func updatePlayerThrowing(delta):
	updateRectangleMovement(delta)
	updateRectangleArrow()
	pass
	
func updateRectangleMovement(_delta):
	pass
	
onready var throwStartPoint = $ThrowStartPoint
func updateRectangleArrow():
	var startPoint = throwStartPoint.get_global_position()
	var endPoint = targetRectangle.get_global_position()
	var delta = endPoint - startPoint
	var length = delta.length()
	delta = delta.normalized()
	var scaleFactor = (length / 162.0);
	targetArrow.scale.y = scaleFactor
	targetArrow.position = throwStartPoint.get_global_position()
	
	pass
	
func updateNpcThrowing(delta):
	updateNpcThrowingStart(delta)
	pass
	
func updateZ():
	self.z_index = -baseZ * 0.1;
	pass

onready var startUI = $"../UI/StartUI"
onready var batter = $"../Batter"
var lifeTime = 0.0
func updateNpcThrowingStart(delta):
	if isThrowing || startUI.visible ||  has_node("../Baseball"):
		return

	lifeTime += delta
	if lifeTime > 3.0:
		startThrowing()

	pass

onready var sprite = $Sprite
var isThrowing = false
func startThrowing():
	sprite.play("pitching_throw")
	isThrowing = true
	pass
	
func updateThrowing():
	if !isThrowing:
		return
		
	if sprite.frame == 3:
		sprite.play("pitching_idle")
		isThrowing = false
		createBaseball()
	pass
	
var ballPrefab = preload("res://Screens/MainGameScreen/Prefabs/Baseball.tscn")
var baseball = null
var baseballTime = 0
	
func createBaseball():
	baseball = ballPrefab.instance();
	baseball.position.x = baseball.baseballStartX
	baseball.position.y = baseball.baseballStartY
	get_parent().add_child(baseball)
	
	baseballTime = 0.0
	pass
	
func updatePosition():
	self.position.y = racetrack.getYFromZ(baseZ) - 20.0;
	var currentScale = racetrack.getScaleXFromZ(baseZ)
		
	if currentScale == 0.0:
		self.scale.x = 0.0
	else:
		var scaleDelta = (currentScale / baseScale) - 1.0
		self.scale.x = 1.0 + scaleDelta
	self.scale.y = self.scale.x
	
	pass
	
func updateDestroy():
	if self.scale.x < 1e-4:
		self.queue_free()
		
	pass
