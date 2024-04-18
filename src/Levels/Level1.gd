extends Node3D

var items_dropped = 0
var tasks = []
var stars = 0
@export var highscore:int = 1
@export var lowscore:int = 6
@export var level_name = ""

func _ready():
	rotation.y = deg_to_rad(-45)
	for task in $Tasks.get_children():
		tasks.push_back(task)
	tasks[0].show()

func _process(delta):
	if Input.is_action_just_pressed("start"):
		get_parent().changeState("res://src/testScenes/levelbuttons.tscn")
	
	if !$UI/Score/Suspense.is_stopped():
		$UI/Score.text = str("Items Dropped: ", (randi()%100) + 1)

func _on_object_hit_ground(object):
	items_dropped += 1

func _on_task_body_entered(body):
	if body.is_in_group("player") && $TaskWait.is_stopped():
		tasks[0].hide()
		tasks[0].disconnect("body_entered",Callable(self,"_on_task_body_entered"))
		tasks.pop_front()
		if tasks.size() == 0: _on_level_complete()
		else: 
			tasks[0].show()
		$TaskWait.start()

func _on_level_complete():
	$UI.show()
	$UI/CompleteAnim.play("appear")

func calculate_score():
	$UI/Score.text = str("Items Dropped: ", items_dropped)
	$UI/Score/Suspense2.start()

func _on_complete_anim_animation_finished(anim_name):
	$UI/Score.show()
	$UI/Score/Suspense.start()

func set_score():
	$UI/HBoxContainer/Star1.show()
	stars += 1
	if items_dropped <= lowscore:
		$UI/HBoxContainer/Star2.show()
		stars += 1
		if items_dropped <= highscore:
			$UI/HBoxContainer/Star3.show()
			stars += 1
	$UI/Button.show()
	get_tree().root.get_child(0).LEVEL_DATA[level_name]["rampage"] = true
	get_tree().root.get_child(0).LEVEL_DATA[level_name]["score"] = stars

func _on_button_pressed():
	get_parent().changeState("res://src/testScenes/levelbuttons.tscn")
