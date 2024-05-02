extends CharacterBody3D

enum MOVEMENT{TANK,TURN}

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
@export var rotSpeed = 5

#The default gravity ive set for objects, 9.8 specifically because its the gravity of the earth
var ROTATING = false
var GRAVITY = -9.8
var motion: Vector3
var previous_rot
var drag_threshold = 15

# Checks if the room node(node that contains all the objects in the game's room) exists and
# before changing the object's gravity to the room's gravity
func _ready():
	if get_tree().root.get_child(0).get_child(0) != null && !OVERIDE_ROOM_GRAVITY:
		GRAVITY =  get_tree().root.get_child(0).get_child(0).GRAVITY


func _physics_process(delta):
	previous_rot = $Mesh.rotation
	var input_vector = Input.get_vector("left", "right", "up", "down")
	#test_input()
	process_input(delta, input_vector)
	process_turn_input(delta)
	process_collision(input_vector)
	#if input_vector.length() > 0 && !$Mesh/hopeThisWorks/QuickRigCharacter_Reference/AnimationPlayer.is_playing():
		#$Mesh/hopeThisWorks/QuickRigCharacter_Reference/AnimationPlayer.play("Walk")

#Handles movement input
func process_input(delta,input):
	#gets the y value of velocity
	velocity.y += GRAVITY * delta
	
	#gets the x and z value for the valocity
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	movement_dir = movement_dir.normalized()
	movement_dir.rotated(movement_dir,deg_to_rad(45)).normalized()
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
	if is_on_floor() and Input.is_action_just_pressed("accept"):
		velocity.y = JUMP_VELOCITY

#processing pushing objects
func process_collision(input):
	for object in get_slide_collision_count():
		var col = get_slide_collision(object)
		if col.get_collider() is RigidBody3D && input != Vector2.ZERO:
			col.get_collider().apply_central_impulse(-col.get_normal() * push_FORCE)

func process_turn_input(delta):
	match get_tree().root.get_child(0).movementType:
		MOVEMENT.TANK:
			pass
		MOVEMENT.TURN:
			var input_vector = Input.get_vector("left", "right", "up", "down")
			if abs(input_vector) != Vector2.ZERO:
				var setAngle = atan2(velocity.x,velocity.z) - deg_to_rad(45)
				$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, setAngle, delta * rotSpeed)
				ROTATING = true

func get_input():
	var input_vector = Input.get_vector("left", "right", "up", "down")
	return input_vector

func test_input():
	if Input.is_action_just_pressed("down"): print("down")
	if Input.is_action_just_pressed("up"): print("up")
	if Input.is_action_just_pressed("left"): print("left")
	if Input.is_action_just_pressed("right"): print("right")
