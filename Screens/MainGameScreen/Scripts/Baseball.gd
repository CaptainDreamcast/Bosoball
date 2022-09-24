extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum BattingPhase{
  DEBUG,
  HITTING_BALL,
  MISSED_BALL,
  HIT_BALL_FLYING,
  BALL_FOUL,
  BALL_HOMEDRIVE,
  BALL_BALL,
  EXPLOSION
}
var phase = BattingPhase.HITTING_BALL;

enum BallThrowType{
	NORMAL,
	CURVE,
	FAST,
	BALL
}
var ballThrowType = BallThrowType.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
	phase = BattingPhase.HITTING_BALL
	updateBallShadow()
	determineBallType()
	pass # Replace with function body.

# Normal ball parameters
var baseballTime = 0.0
var baseballStartX = 30
var baseballStartY = -72
var speed = Vector2(0,0)
var isPhysicsInCharge = false
var ballFlyDuration = 50
var baseballTargetX = baseballStartX

# Curve ball parameters
var curveBallAmplitude = 0.0

# Ball ball parameters

# Fast ball parameters

var ballThrowTypeDistribution = [
	BallThrowType.NORMAL,BallThrowType.NORMAL,BallThrowType.NORMAL,BallThrowType.NORMAL,BallThrowType.NORMAL,
	BallThrowType.CURVE,BallThrowType.CURVE,BallThrowType.CURVE,
	BallThrowType.FAST,BallThrowType.FAST,BallThrowType.FAST,
	BallThrowType.BALL,BallThrowType.BALL
	]
func determineBallType():
	self.ballThrowType = ballThrowTypeDistribution[randi() % ballThrowTypeDistribution.size()]
	
	if(self.ballThrowType == BallThrowType.NORMAL):
		self.ballFlyDuration = 50;
		pass
	elif(self.ballThrowType == BallThrowType.CURVE):
		self.ballFlyDuration = 50;
		self.curveBallAmplitude = Util.randomSign() * 60.0
		pass
	elif(self.ballThrowType == BallThrowType.BALL):
		var sig = Util.randomSign()
		self.baseballTargetX = sig * 80.0 + sig * 10.0
		pass
	elif(self.ballThrowType == BallThrowType.FAST):
		self.ballFlyDuration = 500;
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateBallShadow()
	updateZ()
	updateBallMovement();
	if phase == BattingPhase.HITTING_BALL:
		updateHittingBallPhase(_delta)
		pass
	elif phase == BattingPhase.EXPLOSION:
		updateExplosion()
		pass
	pass # Replace with function body.

onready var shadow = $Shadow
onready var racetrack = $"../Racetrack"
func updateBallShadow():
	shadow.offset.y = 100 * racetrack.getScaleXFromZ(racetrack.getTrackZFromY(self.position.y))
	pass
	
func updateZ():
	self.z_index = -racetrack.getTrackZFromY(self.position.y) * 0.1;
	pass

func updateBallMovement():
	if !isPhysicsInCharge:
		return

	self.position += speed
	
	pass

func updateHittingBallPhase(delta):
	if hasBallBeenHit():
		updateBaseballAfterHit()
		if isHitBallFoul():
			startBallFoulPhase()
		else:
			startHitBallFlyingPhase()
	elif hasBallBeenMissed():
		if isMissedBallBall():
			startBallBallPhase()
		else:
			startMissedBallPhase()
			
	updateBaseball(delta)
	pass

func updateBaseballAfterHit():
	isPhysicsInCharge = true
	var angleDeg = calculateBaseballHitAngle()
	var angle = deg2rad(angleDeg)
	var direction = Vector2(1.0, 0.0).rotated(angle + PI)
	self.speed = 5 * direction
	pass
	
func hasBallBeenHit():
	return isBatterAnimationInHitStance() && isBallInHitPosition()

onready var batter = $"../Batter"
onready var batterAnimation = $"../Batter/Sprite"
func isBatterAnimationInHitStance():
	return batterAnimation.animation == "batting_swing" && batterAnimation.frame >= 4 && batterAnimation.frame <= 4;
	
	
var baseBallHitRangeY = 25
onready var hitCore = $"../Batter/HitCore"
onready var hitLeft = $"../Batter/HitLeft"
onready var hitRight = $"../Batter/HitRight"
func isBallInHitPosition():
	var rangeFactor = batter.getContactFactor()
	var y = self.position.y
	var up = hitCore.get_global_position().y - baseBallHitRangeY * rangeFactor
	var down = hitCore.get_global_position().y + baseBallHitRangeY * rangeFactor
	var isOkY = (y >= up && y <= down);
	
	var x = self.position.x
	var left = hitLeft.get_global_position().x;
	var right = hitRight.get_global_position().x;
	var isOkX = (x >= left && x <= right);
	return isOkX && isOkY;

func isHitBallFoul():
	var angle = calculateBaseballHitAngle()
	return angle < 45 || angle > 135
	
func calculateBaseballHitAngle():
	var rangeFactor = batter.getContactFactor()
	var up = hitCore.get_global_position().y - baseBallHitRangeY * rangeFactor
	var down = hitCore.get_global_position().y + baseBallHitRangeY * rangeFactor
	var y = self.position.y;
	var t = (y - up) / float(down - up);
	return 30 + 120 * t;
	
func calculateBaseballHitStrengthFactor():
	var x = self.position.x
	var left = hitLeft.get_global_position().x;
	var right = hitRight.get_global_position().x;
	var t = (x - left) / float(right - left);
	return 0.5 + 0.5 * t * batter.getStrengthFactor()
	
func hasBallBeenMissed():
	return self.position.y > 120
	
func isMissedBallBall():
	return self.position.x < -80 || self.position.x > 80
	
func updateBaseball(delta):
	if(self.isPhysicsInCharge):
		return
	baseballTime += delta
		
	if self.ballThrowType == BallThrowType.CURVE || self.ballThrowType == BallThrowType.NORMAL || self.ballThrowType == BallThrowType.BALL || self.ballThrowType == BallThrowType.FAST:
		self.position.y = baseballStartY + baseballTime * baseballTime * self.ballFlyDuration
	
	var t = (self.position.y - baseballStartY) / (hitCore.get_global_position().y - baseballStartY)
	if self.ballThrowType == BallThrowType.CURVE:
		if t <= 0.5:
			t = t * 2
		else:
			t = t - 0.5;
			t = t * 2
			t = 1.0 - t
		t = Util.easeOutSine(t)
		self.position.x = baseballStartX + t * self.curveBallAmplitude
		pass
	else:
		self.position.x = baseballStartX + t * (baseballTargetX - baseballStartX)
		pass
	pass
	
onready var hitEffectPrefab = preload("res://Screens/PrologueScreen/Prefabs/AnimationEffect.tscn")
onready var effectRoot = $"../UI"
func playEffectAnimation(funcName, frames):
	var newHitEffect = hitEffectPrefab.instance()
	effectRoot.add_child(newHitEffect)
	newHitEffect.position = Vector2(0, 0)
	var cb = funcref(self, funcName)
	newHitEffect.setAnimation(frames, "default", cb)
	pass
	
onready var strikeAnimation = preload("res://Screens/MainGameScreen/Textures/strike_animation.tres")
func startMissedBallPhase():
	addStrike()
	playEffectAnimation("missedAnimationOverCB", strikeAnimation)
	phase = BattingPhase.MISSED_BALL
	pass
	
onready var overUI = $"../UI/OverUI"
func missedAnimationOverCB():
	if GameManager.strikes == 3:
		explode()
		GameManager.addOut();
		battingUI.updateBattingUIDisplay()
		var cb = funcref(self, "overUIOverCB")
		overUI.startOverUI(overUI.OverType.DESTROYED, overUI.WhereType.OUT, cb)
	else:
		resetPhase()
	pass
	
onready var gameOverUI = $"../UI/GameOverUI"
func overUIOverCB():
	if GameManager.outs >= 3:
		gameOverUI.start()
		pass
	else:
		var cb = funcref(self, "gotoNextBatter")
		fadeout.startFadeout(1.0, cb)
	pass

onready var timer = $"../UI/Batting/Timer"
onready var racingUiRoot = $"../UI/Racing"
onready var hitAnimation = preload("res://Screens/MainGameScreen/Textures/hit_animation.tres")
func startHitBallFlyingPhase():
	playEffectAnimation("hitAnimationOverCB", hitAnimation)
	phase = BattingPhase.HIT_BALL_FLYING
	batter.startKickstarting();
	var hitStrength = calculateBaseballHitStrengthFactor()
	timer.startTimer(25.0 * hitStrength)
	racingUiRoot.visible = true
	pass
	
func hitAnimationOverCB():
	pass
	
onready var foulAnimation = preload("res://Screens/MainGameScreen/Textures/foul_animation.tres")
func startBallFoulPhase():
	if GameManager.strikes < 2:
		addStrike()
	playEffectAnimation("foulAnimationOverCB", foulAnimation)
	phase = BattingPhase.BALL_FOUL
	pass
	
func foulAnimationOverCB():
	resetPhase()
	pass
	

onready var battingUI = $"../UI/Batting"
func addStrike():
	GameManager.addStrike()
	battingUI.updateBattingUIDisplay();
	pass
	
onready var ballAnimation = preload("res://Screens/MainGameScreen/Textures/ball_animation.tres")
func startBallBallPhase():
	playEffectAnimation("ballAnimationOverCB", ballAnimation)
	phase = BattingPhase.BALL_BALL
	pass


func ballAnimationOverCB():
	resetPhase()
	pass

func resetPhase():
	self.queue_free()
	pass
	
func explode():
	batterAnimation.play("exploding")
	phase = BattingPhase.EXPLOSION
	pass
	
onready var fadeout = $"../FadeOut"
func updateExplosion():
	if batterAnimation.frame == 16:
		batterAnimation.playing = false
	pass
	
func gotoNextBatter():
	GameManager.gotoNextBatter()
	resetScreen()
	pass
	
func resetScreen():
	var _changed = get_tree().change_scene("res://Screens/MainGameScreen/MainGameScreen.tscn");
	pass
	
