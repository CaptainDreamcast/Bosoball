extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var baseY
# Called when the node enters the scene tree for the first time.
func _ready():
	baseY = self.position.y
	pass # Replace with function body.


var wasHit = false
var existTime = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateWobbling()
	updateHitMovement(delta)
	existTime += delta
	pass
	
func updateWobbling():
	if wasHit:
		return
	
	self.position.y = baseY + sin(existTime * 10) * 3
	pass

onready var fadeout = $"../FadeOut"
func hit():
	wasHit = true
	var cb = funcref(self, "gotoPrologue")
	fadeout.startFadeout(1.5, cb)

func gotoPrologue():
	var _changed = get_tree().change_scene("res://Screens/PrologueScreen/PrologueScreen.tscn");
	pass

func updateHitMovement(delta):
	if !wasHit:
		return
		
	self.rotation_degrees += delta * 1000
	self.scale.x = max(0, self.scale.x - delta)
	self.scale.y = max(0, self.scale.y - delta)
	self.position.y -= delta * 100
