extends Light2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group = "gui_light"
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func _on_light(num):
	set_energy(num)