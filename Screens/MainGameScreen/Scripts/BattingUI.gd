extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	updateBattingUIDisplay()
	pass # Replace with function body.

onready var inningDisplays = [
	[
		$"Numbers/Innings1/1", 
		$"Numbers/Innings1/2",
		$"Numbers/Innings1/3"
	], [
		$"Numbers/Innings2/1",
		$"Numbers/Innings2/2",
		$"Numbers/Innings2/3"
	]]
	
onready var driveNumbers = [$"Numbers/General/Drives1", $"Numbers/General/Drives2"]
onready var hitNumbers = [$"Numbers/General/Hits1", $"Numbers/General/Hits2"]
onready var errorNumbers = [$"Numbers/General/Errors1", $"Numbers/General/Errors2"]

onready var strikeImages = [$"StrikeImages/Strike1", $"StrikeImages/Strike2", $"StrikeImages/Strike3"]
onready var outImages = [$"OutImages/Out1", $"OutImages/Out2", $"OutImages/Out3"]
onready var ballImages = [$"BallImages/Ball1", $"BallImages/Ball2", $"BallImages/Ball3", $"BallImages/Ball4"]
onready var baseImages = [$"BaseImages/Base1", $"BaseImages/Base2", $"BaseImages/Base3"]

func updateBattingUIDisplay():
	for i in range(0, GameManager.strikes):
		strikeImages[i].visible = true
		
	for i in range(0, GameManager.outs):
		outImages[i].visible = true
	
	for i in range(0, GameManager.balls):
		ballImages[i].visible = true
		
	for i in range(0, 3):
		baseImages[i].visible = GameManager.basePlayers[i] != ""
	
	for i in range(0, 2):
		driveNumbers[i].setDigit(GameManager.teamStats[i].drives)
		hitNumbers[i].setDigit(GameManager.teamStats[i].hits)
		errorNumbers[i].setDigit(GameManager.teamStats[i].errors)
		
		for j in range(0, GameManager.inning + 1):
			inningDisplays[i][j].visible = true
			inningDisplays[i][j].setDigit(GameManager.teamStats[i].inningDrives[j])
		
		pass
	
	pass
	
var healthSizeX = 22;
var healthSizeY = 20;
var baseHealthOffsetY = -20
onready var healthIndicator = $HealthIndicator
func updateHealthUIDisplay(health, healthMax):
	var t = health / float(healthMax);
	var sizeY = int(t * healthSizeY)
	var offsetY = healthSizeY - sizeY;
	healthIndicator.offset.y = baseHealthOffsetY + offsetY;
	healthIndicator.region_rect = Rect2(0, offsetY, healthSizeX, sizeY)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateDistanceTravelled()
	pass

var fullDistanceScaleFactor = 32;
onready var racetrack = $"../../Racetrack"
onready var distanceImages = [$"DistanceImages/1", $"DistanceImages/2", $"DistanceImages/3", $"DistanceImages/4"]
func updateDistanceTravelled():
	var distance = racetrack.distanceTravelled
	if distance >= 4000:
		for i in range(0, 4):
			distanceImages[i].scale.x = fullDistanceScaleFactor
	elif distance >= 3000:
		for i in range(0, 3):
			distanceImages[i].scale.x = fullDistanceScaleFactor
		var t = (distance - 3000) / 1000
		distanceImages[3].scale.x = t * fullDistanceScaleFactor
	elif distance >= 2000:
		for i in range(0, 2):
			distanceImages[i].scale.x = fullDistanceScaleFactor
		distanceImages[3].scale.x = 0.0
		var t = (distance - 2000) / 1000
		distanceImages[2].scale.x = t * fullDistanceScaleFactor
	elif distance >= 1000:
		distanceImages[0].scale.x = fullDistanceScaleFactor
		distanceImages[2].scale.x = 0.0
		distanceImages[3].scale.x = 0.0
		var t = (distance - 1000) / 1000
		distanceImages[1].scale.x = t * fullDistanceScaleFactor
	else:
		distanceImages[1].scale.x = 0.0
		distanceImages[2].scale.x = 0.0
		distanceImages[3].scale.x = 0.0
		var t = distance / 1000.0
		distanceImages[0].scale.x = t * fullDistanceScaleFactor
		pass
		
	pass
