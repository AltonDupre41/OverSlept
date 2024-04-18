extends Node2D

var LEVEL_DATA = {
	"BEDROOM":{
		"rampage":false,
		"score":0,
		"ramscore":0
	},
	"KITCHEN":{
		"rampage":false,
		"score":0,
		"ramscore":0
	},
}

#enum MOVEMENT{TANK, TURN}
#@export var movementType = MOVEMENT
@export_enum("TANK","TURN") var movementType:int

@export_category("DEBUG")
@export var startState: String 
var gamestate_scene: PackedScene
var GAMESTATE

func changeState(path,rampage = false):
	if get_child_count() > 0: remove_child(GAMESTATE)
	if path != "":
		gamestate_scene = load(path)
	GAMESTATE = gamestate_scene.instantiate()
	if rampage: GAMESTATE.rampage = rampage
	add_child(GAMESTATE,true)

func _ready():
	if startState != null:
		changeState(startState)
