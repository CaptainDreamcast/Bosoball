extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum PlayerState{
  DEBUG,
  BATTING,
  KICKSTARTING,
  RACING,
}
var state = PlayerState.BATTING

onready var sprite = $Sprite
var startDistance = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var frames = load("res://Screens/MainGameScreen/Textures/racers/" + GameManager.getBatterName() + ".tres")
	sprite.frames = frames
	sprite.play("batting_default")
	state = PlayerState.BATTING
	startDistance = racetrack.distanceTravelled
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == PlayerState.BATTING:
		updateBatting(delta)
	elif state == PlayerState.KICKSTARTING:
		updateKickStarting()
	elif state == PlayerState.RACING:
		updateRacing(delta)
	pass
	
func updateBatting(delta):
	if sprite.animation == "exploding":
		return
		
	updateSwingStart()
	updateSwingOver()
	updateSwingOffset(delta)
	updateBattingMovement(delta)
	updateZ()
	pass
	
var battingAnimationOffset = 0

func updateSwingOffset(delta):
	var deltaFactor = delta / 0.00625
	battingAnimationOffset += delta * deltaFactor
	pass

var battingMovementTime = 0.0
func updateBattingMovement(delta):
	if sprite.animation == "batting_swing":
		return
	
	var speed = 50 * getSpeedFactor()
	var lerpSpeed = 10
	if Input.is_action_pressed("batting_move_left"):
		position.x -= delta * speed
		battingMovementTime += delta * lerpSpeed
		pass
	elif Input.is_action_pressed("batting_move_right"):
		position.x += delta * speed
		battingMovementTime += delta * lerpSpeed
		pass
	else:
		battingMovementTime = 0.0
		
	scale.x = 1.0 + sin(battingMovementTime) * 0.1
	scale.y = scale.x
	
	pass

func updateSwingStart():
	if sprite.animation != "batting_swing" && Input.is_action_just_pressed("batting_swing"):
		battingAnimationOffset = 0
		sprite.play("batting_swing")
		pass
	pass
	
func updateSwingOver():
	if sprite.animation == "batting_swing" && sprite.frame == sprite.frames.get_frame_count("batting_swing") - 1:
		sprite.play("batting_default")
	pass

onready var battingUiRoot = $"../UI/Batting"
func startKickstarting():
	sprite.play("kickstarting")
	state = PlayerState.KICKSTARTING
	#battingUiRoot.visible = false
	pass
	
func updateKickStarting():
	if sprite.animation == "exploding":
		return
		
	if Input.is_action_just_pressed("kickstart"):
		startRacing()
	pass
	
func startRacing():
	state = PlayerState.RACING
	sprite.play("racing")
	pass

var isExploding = false
func updateRacing(delta):
	updateExploding()
	if isExploding:
		return
	
	updateAcceleration(delta)
	updateSteering(delta)
	updateSlidding()
	updateVictory()
	updateZ()
	pass
	
func updateZ():
	self.z_index = -racetrack.distanceTravelled * 0.1;
	pass
	
var racingSpeed = 0
func updateAcceleration(delta):
	if Input.is_action_pressed("racing_accelerate"):
		racingSpeed = min(1.0, racingSpeed + delta * 0.1 * getSpeedFactor())
		pass
	else:
		racingSpeed *= 0.999
		
	sprite.speed_scale = racingSpeed * 10
	pass

func updateSteering(delta):
	if Input.is_action_pressed("racing_move_left"):
		position.x -= delta * racingSpeed * 200
		sprite.play("racing_move_left")
	elif Input.is_action_pressed("racing_move_right"):
		position.x += delta * racingSpeed * 200
		sprite.play("racing_move_right")
	else:
		sprite.play("racing")
		
onready var racetrack = $"../Racetrack"
func updateSlidding():
	position.x -= racetrack.raceStripeOffset
	pass
	
func updateExploding():
	if position.x < -140 || position.x > 140 || self.health == 0:
		isExploding = true
		if sprite.animation != "exploding":
			sprite.play("exploding")
		racingSpeed *= 0.9
		if sprite.frame == 16 && sprite.playing:
			sprite.frame = 16
			sprite.playing = false
			outOfBounds()
			
func gotoGameOverScreen():
	var _changed = get_tree().change_scene("res://GameOverScreen.tscn");
	pass
		
var contactFactor = 1.0
func getContactFactor():
	return contactFactor
	
var strengthFactor = 1.0
func getStrengthFactor():
	return strengthFactor
	
var speedFactor = 10.0
func getSpeedFactor():
	return speedFactor
	
var healthMax = 100
var health = healthMax
func attackedWithBat(strength):
	self.health = max(self.health - strength, 0);
	battingUI.updateHealthUIDisplay(self.health, self.healthMax)
	pass
	
func updateVictory():
	if racetrack.distanceTravelled >= 4000 && timer.isActive:
		timer.isActive = false
		var whereType = overUI.WhereType.BASE4
		GameManager.addDrive()
		battingUI.updateBattingUIDisplay()
		var cb = funcref(self, "overUIOverCB")
		overUI.startOverUI(overUI.OverType.DRIVE, whereType, cb)
		pass
	pass
	
func timeOut():
	outFunc(overUI.OverType.TIMEOUT)
	pass
	
func outOfBounds():
	outFunc(overUI.OverType.DESTROYED)
	pass

func distanceToWhereType():
	if racetrack.distanceTravelled - startDistance < 1000:
		return overUI.WhereType.OUT
	elif racetrack.distanceTravelled >= 3000:
		return overUI.WhereType.BASE3
	elif racetrack.distanceTravelled >= 2000:
		return overUI.WhereType.BASE2
	else:
		return overUI.WhereType.BASE1
	pass
	
func whereTypeToIndex(type):
	if type == overUI.WhereType.BASE1:
		return 1;
	elif type == overUI.WhereType.BASE2:
		return 2;
	else:
		return 3;
	pass

onready var timer = $"../UI/Batting/Timer"
onready var overUI = $"../UI/OverUI"
onready var battingUI = $"../UI/Batting"
func outFunc(type):
	timer.isActive = false
	var whereType = distanceToWhereType()
	if whereType == overUI.WhereType.OUT:
		GameManager.addOut();
	else:
		var index = whereTypeToIndex(whereType)
		GameManager.addPlayerToBase(GameManager.getBatterName(), index)
	battingUI.updateBattingUIDisplay()
	var cb = funcref(self, "overUIOverCB")
	overUI.startOverUI(type, whereType, cb)
	pass
	
onready var fadeout = $"../FadeOut"
onready var gameOverUI = $"../UI/GameOverUI"
func overUIOverCB():
	if GameManager.outs >= 3 || (GameManager.teamStats[1].drives > GameManager.teamStats[0].drives):
		gameOverUI.start()
		pass
	else:
		var cb = funcref(self, "gotoNextBatter")
		fadeout.startFadeout(1.0, cb)
	pass

func gotoNextBatter():
	GameManager.gotoNextBatter()
	resetScreen()
	pass
	
func resetScreen():
	var _changed = get_tree().change_scene("res://Screens/MainGameScreen/MainGameScreen.tscn");
	pass
	
