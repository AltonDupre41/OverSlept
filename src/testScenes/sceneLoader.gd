extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$GridContainer/BEDROOM.grab_focus()
	for level in $GridContainer.get_children():
		level.get_node("Rampage").visible = get_parent().LEVEL_DATA[level.name]["rampage"]
		for i in range(0,get_parent().LEVEL_DATA[level.name]["score"]):
			level.get_node("Stars").get_child(i).visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_vector = Input.get_vector("left", "right", "up", "down")


func _on_pressed(num, rampage = false):
	match num:
		0:
			get_tree().root.get_child(0).changeState("res://src/Levels/level_1.tscn",rampage)
		1:
			get_tree().root.get_child(0).changeState("res://src/Levels/level_2.tscn",rampage)
