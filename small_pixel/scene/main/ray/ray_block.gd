extends "ray.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group="ray_block"
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	pass

func place_block(block,obj,index,func_name,self_block):
	get_tree().call_group(0,"plane",func_name,block.name,obj.get_pos()-direction_arr[index].vector) 
	block.num-=1
	Function.msg_group("player","_on_place_sound",block.name,obj.get_pos()-direction_arr[index].vector)
	if(self_block!=null):
		self_block._on_free()
	get_tree().call_group(0,"bar","update")

func _on_check(name,obj_name,index):
	if(Config.items_type[obj_name]=="liquid"):
		return 0
	if(obj_name=="torch"):
		return 0
	if(Config.items_type[name]=="seed"):
		if(obj_name=="dirt_plow"||obj_name=="dirt"||obj_name=="grass_dirt"):
			if(index!=1):
				return 0
		else:
			return 0
	if(name=="button"):
		if(index==1||index==3):
			return 0
	if(name=="pressure_board"):
		if(index!=1):
			return 0
	return 1
func place_bg(pos,block,index=0,func_name="place",self_block=null):
	set_pos(Vector2(pos))
	if(!index):
		set_cast_to(Vector2(0,0))
		force_raycast_update()
		if(is_colliding()):
			return
	set_pos(Vector2(pos)+direction_arr[index].vector)
	force_raycast_update()
	if(is_colliding()):
		var obj=get_collider()
		if(collision_filtration(obj)):return
		if(block.num>0):
			get_tree().call_group(0,"ray_bg","place_block",block,obj,index,func_name,1)
			
	else:
		if(index!=3):
			place_bg(pos,block,index+1,func_name,self_block)