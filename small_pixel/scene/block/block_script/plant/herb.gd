extends "../../Plant.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func _free():
	if status:
		Function.msg_group("plane","drop_item",{"name":"herb","num":status,"health":0},get_pos())
