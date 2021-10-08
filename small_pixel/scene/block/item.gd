extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var name=""
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	get_node("collision").set_trigger(true)
	pass