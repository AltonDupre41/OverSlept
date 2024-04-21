extends RigidBody3D

signal hit_ground

@export_category("object_settings")
@export var OVERIDE_ROOM_GRAVITY = false
@export var has_GRAVITY = true
@export var can_MOVE = true
@export var floorDetectNode:Node

#The default gravity ive set for objects, 9.8 specifically because its the gravity of the earth
var GRAVITY = -9.8
var motion: Vector3

# Checks if the room node(node that contains all the objects in the game's room) exists and
# before changing the object's gravity to the room's gravity
func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	add_to_group("FloorDetectable")
	connect("body_entered", Callable(self, "_on_body_entered"))
	if get_tree().root.get_child(0).get_child(0) != null and not OVERIDE_ROOM_GRAVITY:
		gravity_scale = get_tree().root.get_child(0).get_child(0).GRAVITY
	

func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("ground") && floorDetectNode != null: # ground objects are in a 'ground' group like the "Floor"
		print("A FloorDetectable object has hit the ground.")
		emit_signal("hit_ground", self)
		# Disconnect the signal after the first ground hit to stop detecting further hits
		await get_tree().process_frame
		floorDetectNode.disconnect("body_entered", Callable(self, "_on_body_entered"))



func _on_object_hit_ground():
	pass # Replace with function body.
