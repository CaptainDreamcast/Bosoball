extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var streetImages = [
	preload("res://Screens/MainGameScreen/Textures/Concept/LARGE_STREET1.png"),
	preload("res://Screens/MainGameScreen/Textures/Concept/LARGE_STREET2.png"),
	preload("res://Screens/MainGameScreen/Textures/Concept/LARGE_STREET3.png"),
	preload("res://Screens/MainGameScreen/Textures/Concept/LARGE_STREET4.png"),
	preload("res://Screens/MainGameScreen/Textures/Concept/LARGE_STREET5.png"),
	preload("res://Screens/MainGameScreen/Textures/Concept/LARGE_STREET6.png"),
	preload("res://Screens/MainGameScreen/Textures/Concept/LARGE_STREET7.png"),
	preload("res://Screens/MainGameScreen/Textures/Concept/LARGE_STREET8.png"),
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	loadStartPosition()
	setupTrackStripes();
	pass # Replace with function body.

func loadStartPosition():
	var batterName = GameManager.getBatterName()
	var startDistanceBaseIndex = GameManager.popBatterStartDistance(batterName)
	distanceTravelled = startDistanceBaseIndex * 1000
	pass

var currentGroupOffset = 0.0
var currentFirstIndex = 0
var groupSize = 8;

var racetrackStripe = preload("res://Screens/MainGameScreen/Prefabs/RacetrackStripe.tscn")
var stripeYScale = 2.0
func setupTrackStripes():
	var groupOffset = int(currentGroupOffset);
	
	var currentIndex = currentFirstIndex;
	for yIndex in 96:
		var newStripe = racetrackStripe.instance()
		newStripe.position.x = 0
		newStripe.position.y = 120 - yIndex * stripeYScale
		var t = yIndex / 95.0;
		newStripe.scale.x = 1.0 - t * 0.9
		newStripe.scale.y = stripeYScale
		newStripe.texture = streetImages[currentIndex]
		add_child(newStripe)
		
		groupOffset = groupOffset + 1
		if groupOffset >= groupSize:
			groupOffset = 0
			groupSize = max(1, groupSize - 1)
			currentIndex = (currentIndex + 1) % 8
		
		pass
		
	for _i in range(96):
		curveValues.append(0)
	
	pass
	
var curveValues = []
var curveOffsetX = 0.0
var groupDelta =  0;
var raceStripeOffset = 0

func updateTrackStripes():
	if isInCurve:
		curveOffsetX += groupDelta * curveDirection
	else:
		curveOffsetX -= groupDelta * curveDirection
		if curveDirection < 0 && curveOffsetX > 0:
			curveOffsetX = 0
			curveDirection = 0
		if curveDirection > 0 && curveOffsetX < 0:
			curveOffsetX = 0
			curveDirection = 0
	
	raceStripeOffset = 0
	var integerGroupDelta;
	if groupDelta < 1e-6:
		integerGroupDelta = 0
	else:
		integerGroupDelta = int(groupDelta + 1)
	for yIndex in integerGroupDelta:
		raceStripeOffset += curveValues[yIndex]
		curveValues[95 - yIndex] = curveDirection
		pass
	
	var groupOffset = int(currentGroupOffset);
	
	var currentIndex = currentFirstIndex;
	var children = get_children()
	for yIndex in 96:
		var stripe = children[yIndex];
		stripe.texture = streetImages[currentIndex]
		stripe.position.x = curveOffsetX * (yIndex) / 95
		
		if integerGroupDelta + yIndex < 96:	
			curveValues[yIndex] = curveValues[yIndex + integerGroupDelta]
		
		groupOffset = groupOffset + 1
		if groupOffset >= groupSize:
			groupOffset = 0
			groupSize = max(1, groupSize - 1)
			currentIndex = (currentIndex + 1) % 8
		
		pass
	pass

onready var racer = $"../Batter"
func advanceTrackStripes(delta):
	groupDelta = delta * 200 * racer.racingSpeed;
	currentGroupOffset = currentGroupOffset + delta * 200 * racer.racingSpeed
	if currentGroupOffset >= groupSize:
		currentGroupOffset = 0
		currentFirstIndex = (currentFirstIndex + 1) % 8
	pass

var nextCurveTime = 60
var currentCurveTimer = 0
var isInCurve = false
var curveDirection = 0
func updateCurveLogic():
	if isInCurve:
		updateInCurveLogic()
	else:
		updateOutOfCurveLogic()
	pass

func updateInCurveLogic():
	currentCurveTimer += groupDelta
	if(currentCurveTimer >= nextCurveTime):
		isInCurve = false
		currentCurveTimer = 0
		nextCurveTime = rand_range(60, 300)
	pass
	
func updateOutOfCurveLogic():
	if distanceTravelled > 5000:
		return
	currentCurveTimer += groupDelta
	if(currentCurveTimer >= nextCurveTime):
		isInCurve = true
		currentCurveTimer = 0
		nextCurveTime = rand_range(60, 300)
		curveDirection = rand_range(-0.5, 0.5)
	pass

var distanceTravelled = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateCurveLogic()
	advanceTrackStripes(delta)
	updateTrackStripes()
	
	distanceTravelled += groupDelta
	pass
	
func getCurrentScaleX(y):
	var z = getTrackZFromY(y)
	var t = z / 95.0;
	return  1.0 - t * 0.9
	
func getTrackZFromY(y):
	return ((120 - y) / stripeYScale) + distanceTravelled
	
func getYFromZ(z):
	z -= distanceTravelled
	return 120 - z * stripeYScale

func getScaleXFromZ(z):
	z -= distanceTravelled
	if z < 0:
		return 0.0
		
	var t = z / 95.0;
	return 1.0 - t * 0.9
