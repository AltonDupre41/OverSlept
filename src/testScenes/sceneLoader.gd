extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed(num):
	match num:
		0:
			get_tree().root.get_child(0).changeState("res://src/Levels/level_1.tscn")
		1:
			get_tree().root.get_child(0).changeState()
