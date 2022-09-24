extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var inning = 0
var isFirstHalf = true

var balls = 0
var strikes = 0
var outs = 0
var basePlayers = ["", "", ""]
var currentBatter = 0
var pitchCount = 0
var currentPitcher = 0
var inningCount = 3

class TeamStats:
	var drives = 0
	var hits = 0
	var errors = 0
	var inningDrives = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	var teamSize = 0
	var playerNames = []

var teamStats = [TeamStats.new(), TeamStats.new()]

func resetGameState():
	inning = 1
	
	balls = 0
	strikes = 0
	outs = 0
	pitchCount = 0
	
	for i in range(0, 3):
		basePlayers[i] = ""
	
	for i in range(0, 2):
		teamStats[i].drives = 0
		teamStats[i].hits = 0
		teamStats[i].errors = 0
		for j in range(0, inningCount):
			teamStats[i].inningDrives[j] = 0
		
	teamStats[0].teamSize = 3
	teamStats[0].playerNames = []
	teamStats[0].playerNames.push_back("julian")
	teamStats[0].playerNames.push_back("persian")
	teamStats[0].playerNames.push_back("killer")
	
	teamStats[1].teamSize = 3
	teamStats[1].playerNames = []
	teamStats[1].playerNames.push_back("david")
	teamStats[1].playerNames.push_back("jo")
	teamStats[1].playerNames.push_back("woz")
		
	pass

func popBatterStartDistance(name):
	for i in range(0, 3):
		if basePlayers[i] == name:
			basePlayers[i] = ""
			return i + 1
	return 0
	
func addPlayerToBase(name, index):
	basePlayers[index - 1] = name
	pass

func gotoNextBatter():
	balls = 0
	strikes = 0
	pitchCount += 1
	currentBatter = (currentBatter + 1) % teamStats[1].teamSize
	currentPitcher = int(rand_range(0.0, 2.99))
	pass

func getBatterName():
	return teamStats[1].playerNames[currentBatter]

func getPitcherName():
	return teamStats[0].playerNames[currentPitcher]

func gotoNextInning():
	inning += 1
	
	balls = 0
	strikes = 0
	outs = 0
	pitchCount = 0
	
	for i in range(0, 3):
		basePlayers[i] = ""
		
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	totalReset()
	pass # Replace with function body.

func totalReset():
	resetGameState()
	resetPrologue()
	pass
	
var currentPrologue = 0
func resetPrologue():
	currentPrologue = 0
	pass

func increasePrologue():
	currentPrologue += 1
	pass

func addStrike():
	strikes += 1
	pass
	
func addOut():
	outs += 1
	pass
	
func addDrive():
	teamStats[1].drives += 1
	teamStats[1].inningDrives[inning] += 1
	pass

func simulateEnemyRound():
	teamStats[0].inningDrives[inning - 1] = int(rand_range(0, 3.99))
	pass
	
func reloadBattingScreen():
	var _changed = get_tree().change_scene("res://Screens/MainGameScreen/MainGameScreen.tscn");
	pass
	
func skipToFinalInning():
	resetGameState()
	for i in range(0, inningCount - 2):
		var drivesThisInning = int(rand_range(0.0, 1.99))
		teamStats[0].inningDrives[i] = drivesThisInning
		teamStats[1].inningDrives[i] = drivesThisInning
		teamStats[0].drives += drivesThisInning
		teamStats[1].drives += drivesThisInning
		gotoNextInning()
	teamStats[0].drives += 1
	teamStats[0].inningDrives[inning] += 1
	pass
	
var scriptName = "2"
func setStoryScriptName(name):
	scriptName = name
	pass
	
func getStoryScriptName():
	return scriptName

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
