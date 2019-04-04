extends "../../Light.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	if(!onec):
		return
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
	get_node("collision").set_trigger(true)
	
	pass