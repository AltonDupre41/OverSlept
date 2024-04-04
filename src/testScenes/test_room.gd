extends Node3D

@export var detected_test_good:Color


func _on_phys_cube_2_hit_ground(object):
	$Detect_Floor_Group.color = detected_test_good
