extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateEnemyGeneration()
	pass

var activeEnemies = []
var activeEnemyCount = 0
func updateEnemyGeneration():
	if !isInRacingPhase():
		return
	
	if isEnemyNecessary():
		generateEnemy()
		pass
	pass
	
onready var racer = $"../Batter"
func isInRacingPhase():
	return racer.state == racer.PlayerState.RACING
	pass

func isEnemyNecessary():
	if activeEnemyCount >= 1:
		return false
		
	return racer.racingSpeed == 1.0
	pass
	
onready var enemyPrefab = preload("res://Screens/MainGameScreen/Prefabs/EnemyRacer.tscn")
func generateEnemy():
	var newEnemy = enemyPrefab.instance()
	newEnemy.position.x = -20
	newEnemy.position.y = 300
	self.add_child(newEnemy)
	activeEnemyCount += 1
	pass
	
