extends Node3D

var paused = false

var music_player

var items_dropped = 0
var tasks = []
var stars = 0
var time:float = 0
var best_time: float = INF  # Initialize best time with infinity
var stopwatch = false
@export var highscore:int = 1
@export var lowscore:int = 6
@export var level_name = ""
@export var rampage = false
@export var rampage_goal = 4
var level_complete = false

func _ready():
	load_best_time()
	rotation.y = deg_to_rad(-45)
	if !rampage:
		for task in $Tasks.get_children():
			tasks.push_back(task)
			task.monitoring = false
		tasks[0].show()
		tasks[0].monitoring = true
		$UI/BestTimeLabel.hide()
	else:
		for task in $Tasks.get_children():
			task.monitoring = false
		stopwatch = true
		$Stopwatch.show()
		time = 0  # Reset time on level start
		#$Stopwatch/Timer.start()
	

func _process(delta):
	if stopwatch:
		time += delta
		$Stopwatch.text = String.num(time, 2)
	
	if Input.is_action_just_pressed("select"):
		get_parent().changeState("res://src/testScenes/levelbuttons.tscn")
	
	if !$UI/Score/Suspense.is_stopped():
		$UI/Score.text = str("Items Dropped: ", (randi()%100) + 1)

func _on_object_hit_ground(object):
	if object.is_in_group("FloorDetectable"):
		items_dropped += 1
		object.remove_from_group("FloorDetectable")
		if rampage && items_dropped == rampage_goal:
			stopwatch = false
			_on_level_complete()

func _on_task_body_entered(body):
	if body.is_in_group("player") && $TaskWait.is_stopped():
		tasks[0].hide()
		tasks[0].disconnect("body_entered",Callable(self,"_on_task_body_entered"))
		tasks.pop_front()
		if tasks.size() == 0: _on_level_complete()
		else: 
			tasks[0].show()
			tasks[0].monitoring = true
		$TaskWait.start()

func _on_level_complete():
	level_complete = true
	if rampage and time < best_time:
		best_time = time
	$UI.show()
	$UI/CompleteAnim.play("appear")



func update_best_time_display():
	$UI/BestTimeLabel.text = "Best Time: " + String.num(best_time, 2) # Update the label's text


func calculate_score():
	if !rampage: 
		$UI/Score.text = str("Items Dropped: ", items_dropped)
		$UI/Score/Suspense2.start()
	else: 
		$UI/Score.text = str("Your time: ",String.num(time,2))
		$UI/Complete2.hide()
		if time <= best_time:
			$UI/Score.text += " (New Best!)"
			save_best_time()
		update_best_time_display()
		$UI/Button.show()
		$UI/Button.grab_focus()
	

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

func pause(extra):
	paused = extra
	if paused:
		process_mode = Node.PROCESS_MODE_DISABLED
		$Paused.show()
	else:
		process_mode = Node.PROCESS_MODE_ALWAYS
		$Paused.hide()
		
func save_best_time():
	var file = FileAccess.open("user://%s_best_time.save" % level_name, FileAccess.WRITE)
	file.store_var(best_time)

func load_best_time():
	if FileAccess.file_exists("user://%s_best_time.save" % level_name):
		var file = FileAccess.open("user://%s_best_time.save" % level_name, FileAccess.READ)
		if file:
			best_time = file.get_var(best_time)
			file.close()
		else:
			print("Failed to load the best time.")
	else:
		best_time = INF  # No best time saved yet

