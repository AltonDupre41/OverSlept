extends Control


func _on_button_pressed():
	get_parent().changeState("res://src/testScenes/levelbuttons.tscn")


func _input(event):
	if Input.is_action_just_pressed("start"):
		_on_button_pressed()
