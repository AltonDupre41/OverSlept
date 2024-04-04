extends Node3D

var items_dropped = 0

func _ready():
	rotation.y = deg_to_rad(-45)

func _on_object_hit_ground(object):
	items_dropped += 1
	$Score.text = str("Items Dropped: ", items_dropped)
