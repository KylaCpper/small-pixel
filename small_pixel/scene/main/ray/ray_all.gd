extends "Ray.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group="ray"
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass
