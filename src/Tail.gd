extends CharacterBody3D

enum {PULL, FOLLOW}
var dragType = FOLLOW

@export var pull_force = 1
@export var pull_fade = 0.5
@export var PULLABLE = false
@export var push_FORCE = 0.1

@export var rotSpeed = 3
@export var drag_rotSpeed = 5

var player
var playerMesh
var previous_rot = deg_to_rad(0)


func _ready():
	for i in get_tree().get_nodes_in_group("player"):
		player = i
		playerMesh = i.get_child(1)

func _physics_process(delta):
	previous_rot = rotation
	if player.velocity != Vector3.ZERO && PULLABLE:
		match dragType:
			PULL:
				#apply_pull(delta)
				#apply_drag(delta)
				pass
			FOLLOW:
				pass
	process_collision()

func apply_pull(delta):
	var normal_rot = previous_rot
	if get_parent() is CharacterBody3D:
		normal_rot = player.previous_rot
	elif get_parent() is RigidBody3D:
		normal_rot = get_parent().previous_rot
	rotation.y = lerp_angle(rotation.y, normal_rot.y, delta * rotSpeed )
	

func apply_drag(delta):
	if player.ROTATING:
		rotation.y = lerp_angle(rotation.y, 0, delta * drag_rotSpeed)
		

func process_collision():
	var input = player.get_input()
	for object in get_slide_collision_count():
		var col = get_slide_collision(object)
		if col.get_collider() is RigidBody3D && input != Vector2.ZERO:
			col.get_collider().apply_central_impulse(-col.get_normal() * push_FORCE)
