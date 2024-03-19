extends Node2D

@export_category("DEBUG")
@export var startState: String 
var gamestate_scene: PackedScene
var GAMESTATE

func changeState(path):
	if get_child_count() > 0: remove_child(GAMESTATE)
	if path != "":
		gamestate_scene = load(path)
	GAMESTATE = gamestate_scene.instantiate()
	add_child(GAMESTATE,true)

func _ready():
	if startState != null:
		changeState(startState)
