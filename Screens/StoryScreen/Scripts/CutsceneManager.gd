extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var scenes = [
	[
	"[BG STADIUM, Reporter center]",
	"Reppy: Since the dawn of humanity, hitting and riding have been the fundamental basis of humanity.",
	"Reppy: And it all climaxes today, in the battle for the Bosoking throne as the 5th generation head of all M City delinquents (legally binding with tax benefits)!!",
	"[Trips center]",
	"Reppy: Our first contestants are the legendary 4th generation head Julian and his team, the Trups! Fables and tv dramas have been writing about their adventures! Plus a feature film with Tom Cruise is in the works!",
	"[Utz center]",
	"Reppy: The challengers are an up-and-coming team full of sexy womanizers with deftly toned bodies, it's the Ütz and their fearless leader Joooooo!",
	"[Utz2 center]",
	"Jo: Haha, I'm not just sexy, I am a rocket scientist too, don't forget that! E=MC^2 to all you girls at home!",
	"[Reporter center]",
	"Reppy: Who will take the crown tonight?! Who will make it past the game with the seesaws?! Let the battle begin!"		
	]	
	,
	[
	"[BG STADIUM, Reporter center]",
	"Reppy: THEY WON! THEY WON! ÜTZ WON AGAINST THE 4TH GENERATION HEAD MAKING THEM THE NEW TOP DELINQUENTS OF M CITY! THE READER MUST BE BREAKING OUT IN TEARS TOO, AFTER ALL THE BUILDUP!",
	"Reppy: AS IS TRADITION, THEY WILL NOW LEAD \"THE GREAT PROCESSION\" DOWN MAIN STREET, WITH ALL OTHER DELINQUENTS FOLLOWING THEM BEHIND ON THEIR BIKES!",
	"[Utz2 center]",
	"Jo: It wasn't much, for a rocket scientist such as myself.",
	"[delinquent_males center]",
	"Randos: Please make us your rocket science underlings, 5th generation head!",
	"[delinquent_females center]",
	"Randis: Please let us have your rocket scientist children, 5th generation head!",
	"[delinquent_bankers center]",
	"Randums: Please take all our rocket scientism money as a token of appreciation, 5th generation head!",
	"[Utz center]",
	"All: Jo! Jo! Jo! Jo! Jo! Jo!",
	"[BG SCHOOL, Jo center]",
	"Jo: So that's how it would pretty much go down, more or less. What do you think?",
	"[David center]",
	"David: ...",
	"[Woz center]",
	"Woz: ...",
	"[David center]",
	"David: He's an idiot, right?",
	"[Woz center]",
	"Woz: He's an idiot.",
	"[BG CONTINUE]",
	"???: TO BE CONTINUED!",
	"[You center]",
	"???: BOSO-THANKS A BOSO-LOT FOR BOSO-PLAYING!!",
	"???: BOSO!"
	]


]

# Called when the node enters the scene tree for the first time.
func _ready():
	loadScript()
	startScript()
	pass # Replace with function body.

var scriptLines = []
func loadScript():
	# TODO: rewrite with ResourceLoader
	#var textFileLocation = "res://Screens/StoryScreen/Cutscenes/" + GameManager.getStoryScriptName() + ".txt"
	#var f = File.new()
	#f.open(textFileLocation, File.WRITE_READ)
	#while not f.eof_reached():
	#	var line = f.get_line()
	#	line = sanitizeScriptLine(line)
	#	if !line.empty():
	#		scriptLines.push_back(line)

	#f.close()
	
	var index
	if GameManager.getStoryScriptName() == "1":
		index = 0
	else:
		index = 1
	for line in scenes[index]:
		scriptLines.push_back(line)
		pass
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

var currentStoryIndex = -1
func startScript():
	currentStoryIndex = -1;
	loadNextStoryIndex()
	pass
	
onready var fadeout = $"../FadeOut"
func loadNextStoryIndex():
	while true:
		currentStoryIndex += 1;
		if currentStoryIndex == scriptLines.size():
			var cb = funcref(self, "gotoGameScreen")
			fadeout.startFadeout(1.0, cb)
			return
		if currentStoryIndex > scriptLines.size():
			return
		
		var rawLine = scriptLines[currentStoryIndex]
		if isSetupLine(rawLine):
			handleSetupLine(rawLine)
		elif isTextLine(rawLine):
			handleTextLine(rawLine)
			break
		else:
			printerr("Unable to parse line:");
			printerr(rawLine)
	pass
	
func isSetupLine(rawLine):
	return rawLine.find("[") != -1 && rawLine.find_last("]") != -1
	
func handleSetupLine(rawLine):
	
	var startIndex = rawLine.find("[")
	var endIndex = rawLine.find_last("]");
	assert(startIndex != -1)
	assert(endIndex != -1)
	assert(endIndex > startIndex)
	
	var lineContent = rawLine.substr(startIndex + 1, endIndex - (startIndex + 1))
	var commands = lineContent.split(",", false)
	
	self.currentSpriteIndex = 0
	for command in commands:
		command = sanitizeScriptLine(command)
		if isBGCommand(command):
			handleBGCommand(command)
			pass
		elif isSpriteCommand(command):
			handleSpriteCommand(command)
		else:
			printerr("Unable to parse command:")
			printerr(command)
		pass
	pass

func isBGCommand(command):
	var words = command.split(" ", false);
	return words[0].to_lower() == "bg" && words.size() == 2;

onready var bgSprite = $"../BG/Sprite"
func handleBGCommand(command):
	for spriteRoot in spriteRoots:
		spriteRoot.visible = false
	
	var words = command.split(" ", false);
	var path = "res://Screens/StoryScreen/Textures/BG/" + words[1] + ".png"
	var texture = load(path)
	bgSprite.set_texture(texture)
	pass

func isSpriteCommand(command):
	var words = command.split(" ", false);
	return words.size() == 2;

onready var spriteRoots = [$"../CutsceneSprite", $"../CutsceneSprite2", $"../CutsceneSprite3"]
var currentSpriteIndex = 0
func handleSpriteCommand(command):
	if currentSpriteIndex == 0:
		for spriteRoot in spriteRoots:
			spriteRoot.visible = false
			
	assert(currentSpriteIndex < spriteRoots.size())
	var words = command.split(" ", false);
	assert(words.size() >= 2)
	
	var characterName = words[0].to_lower()
	var animationPath = "res://Screens/StoryScreen/Cutscenes/Characters/" + characterName + ".tres"
	var newAnimation = load(animationPath)
	var sprite = spriteRoots[currentSpriteIndex].get_node("Sprite")
	sprite.frames = newAnimation
	
	spriteRoots[currentSpriteIndex].position.x = parsePositionXFromWord(words[1])
	
	sprite.play("default")
	spriteRoots[currentSpriteIndex].visible = true;
	
	currentSpriteIndex += 1
	pass

func parsePositionXFromWord(characterPosition):
	characterPosition = characterPosition.to_lower()
	if characterPosition == "center":
		return 0.0;
	elif characterPosition == "left":
		return -80.0;
	elif characterPosition == "right":
		return 80.0;
	else:
		printerr("Unable to parse character position:")
		printerr(characterPosition)
		return 0.0;


func isTextLine(rawLine):
	return rawLine.split(":", false, 1).size() == 2
	
onready var textbox = $"../Textbox"
func handleTextLine(rawLine):
	var words = rawLine.split(":", false, 1);
	var characterName = sanitizeScriptLine(words[0])
	var text = sanitizeScriptLine(words[1])
	textbox.setText(text, characterName, true)
	pass
	
func sanitizeScriptLine(line):
	var returnLine = "";
	var isEmpty = true;
	for c in line:
		if c == '\t':
			continue
		if c != ' ':
			isEmpty = false
		elif isEmpty:
			continue
			
		returnLine += c
		pass
		
	if isEmpty:
		return "";
	else:
		return returnLine;

func gotoGameScreen():
	if GameManager.scriptName == "1":
		GameManager.skipToFinalInning()
		var _changed = get_tree().change_scene("res://Screens/MainGameScreen/MainGameScreen.tscn");
	else:
		var _changed = get_tree().change_scene("res://Screens/TitleScreen/TitleScreen.tscn");
	pass
