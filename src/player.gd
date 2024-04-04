extends CharacterBody3D

@export_category("object_settings")
@export var OVERIDE_ROOM_GRAVITY = false
@export var has_GRAVITY = true
@export var can_MOVE = true

@export_category('Movement')
@export var ACCEL = 5.0
@export var DEACCEL = 16.0
@export var MAX_SPEED = 20.0
@export var JUMP_VELOCITY = 4.5
@export var MAX_SLOPE_ANGLE = 40
@export	 var push_FORCE = 0.5

#The default gravity ive set for objects, 9.8 specifically because its the gravity of the earth
var GRAVITY = -9.8
var motion: Vector3

# Checks if the room node(node that contains all the objects in the game's room) exists and
# before changing the object's gravity to the room's gravity
func _ready():
	if get_tree().root.get_child(0).get_child(0) != null && !OVERIDE_ROOM_GRAVITY:
		GRAVITY =  get_tree().root.get_child(0).get_child(0).GRAVITY


func _physics_process(delta):
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	process_input(delta, input_vector)
	process_collision(input_vector)

#Handles movement input
func process_input(delta,input):
	#gets the y value of velocity
	velocity.y += GRAVITY * delta
	
	#gets the x and z value for the valocity
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	movement_dir = movement_dir.normalized()
	movement_dir.rotated(movement_dir.normalized(),deg_to_rad(45))
	velocity.x = movement_dir.x
	velocity.z = movement_dir.z
	
	var target = velocity
	target.y = 0
	target *= MAX_SPEED
	var hvel = velocity
	hvel.y = 0
	
	var accel
	if velocity.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = target.lerp(target, accel * delta)
		
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY

#processing pushing objects
func process_collision(input):
	for object in get_slide_collision_count():
		var col = get_slide_collision(object)
		if col.get_collider() is RigidBody3D && input != Vector2.ZERO:
			col.get_collider().apply_central_impulse(-col.get_normal() * push_FORCE)
