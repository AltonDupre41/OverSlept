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

func _input(event):
	if Input.is_action_just_pressed("start") && get_child(1).name.begins_with("Level") && !get_child(1).level_complete:
		get_child(1).pause(!get_child(1).paused)

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
		var music_player = $MusicPlayer
		#music_player.volume_db = 0.0
		music_player.play()
