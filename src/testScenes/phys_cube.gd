extends RigidBody3D

@export_category("object_settings")
@export var OVERIDE_ROOM_GRAVITY = false
@export var has_GRAVITY = true
@export var can_MOVE = true

#The default gravity ive set for objects, 9.8 specifically because its the gravity of the earth
var GRAVITY = -9.8
var motion: Vector3

# Checks if the room node(node that contains all the objects in the game's room) exists and
# before changing the object's gravity to the room's gravity
func _ready():
	if get_tree().root.get_child(0).get_child(0) != null && !OVERIDE_ROOM_GRAVITY:
		gravity_scale =  get_tree().root.get_child(0).get_child(0).GRAVITY


func _process(delta):
	pass
