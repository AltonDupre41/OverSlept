extends CollisionShape3D

func _ready():
	get_parent().get_child((randi()%3) + 1).show()
