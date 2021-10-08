extends "ray.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group="ray_bg"

func _ready():
	add_to_group(group)
	
	# Called every time the node is added to the scene.
	# Initialization here

	pass
func ray_null(pos,block,func_name):
	get_tree().call_group(0,"ray_block","place_bg",pos,block,0,func_name)

func place_block(block,obj,index,func_name,self_block):
	get_tree().call_group(0,"plane",func_name,block.name,obj.get_pos()-direction_arr[index].vector,1) 
	block.num-=1
	Function.msg_group("player","_on_place_sound",block.name,obj.get_pos()-direction_arr[index].vector)
	get_tree().call_group(0,"bar","update")
	