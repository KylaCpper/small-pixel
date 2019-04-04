extends "Block.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	if(!onec):
		return
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	connect("input_event",self,"_on_event")
	#Input.warp_mouse_pos(get_viewport().get_mouse_pos())
func init():
	pass
func _on_event(a,event,c):
	if(event.is_action_pressed("mouse_right")):
		if(Function.hand_distance_use(self)):
			_on_mouse_right()
func _on_mouse_right():
	pass
