extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var hardness=0.4
var name="dirt"
func _ready():
	if(!onec):
		return
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test()
	connect("mouse_enter",self,"_on_mouse_enter")
	pass
func _on_mouse_enter():
	get_tree().call_group(0,"player","_on_block_enter",self)