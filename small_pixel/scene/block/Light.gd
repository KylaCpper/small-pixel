extends "Block.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	if(!onec):
		return
	
	get_node("sprite").set_z(3)
	var tscn=Overall.scenes.light.instance()
	add_child(tscn)