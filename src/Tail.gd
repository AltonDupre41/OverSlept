extends RigidBody3D

@export var pull_force = 1
@export var pull_fade = 0.5
var player


func _ready():
	for i in get_tree().get_nodes_in_group("player"):
		player = i

func _physics_process(delta):
	
	if player.velocity != Vector3.ZERO:
		apply_pull(delta)
	
	pass

func apply_pull(delta):
	#var pos = global_position
	var rel_vel
	if  get_parent() is CharacterBody3D:
		apply_central_force(get_parent().velocity - linear_velocity)
	elif get_parent() is RigidBody3D:
		apply_central_force(get_parent().linear_velocity - linear_velocity)
	#var spring = pos * pull_force + rel_vel * pull_fade
	#apply_central_force(rel_vel * mass)

