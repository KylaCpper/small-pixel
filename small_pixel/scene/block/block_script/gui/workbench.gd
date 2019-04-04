extends "../../FunctionGui.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	if(!onec):
		return
	# Called every time the node is added to the scene.
	# Initialization here

	pass
func _on_mouse_right():
		get_tree().call_group(0,"workbench","display",1,[],self)
		
func _free():
	get_tree().call_group(0,"workbench","_on_hide")