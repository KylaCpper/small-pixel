extends RayCast2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar
var length=32
var direction_arr=[

		{
			"direction":"left",
			"vector":Vector2(-length,0)
		},
		{
			"direction":"down",
			"vector":Vector2(0,length)
		},
		{
			"direction":"right",
			"vector":Vector2(length,0)
		},
		{
			"direction":"up",
			"vector":Vector2(0,-length)
		}
		
	]
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func change_loop(be):
	set_fixed_process(be)
func place(pos,block,index=0,func_name="place",self_block=null):
	set_pos(Vector2(pos))
	if(!index):
		set_cast_to(Vector2(0,0))
		force_raycast_update()
		if(is_colliding()):
			var obj=get_collider()
			if(Config.items_type[obj.name]=="liquid"):
				if(obj.name==block.name):
					if(obj.flow==-1):
						return
				self_block=obj
				#obj._on_free()
				#place(pos,block,index+1,func_name)
			else:
				return
	set_pos(Vector2(pos)+direction_arr[index].vector)
	force_raycast_update()
	if(is_colliding()):
		var obj=get_collider()
		if(collision_filtration(obj)):return
		if(block.num>0):
			if(_on_check(block.name,obj.name,index)):
				if(self_block!=null):
					place_block(block,obj,index,func_name,self_block)
				else:
					place_block(block,obj,index,func_name,self_block)
			else:
				if(index!=3):
					place(pos,block,index+1,func_name,self_block)
				else:
					ray_null(pos,block,func_name)
	else:
		if(index!=3):
			place(pos,block,index+1,func_name,self_block)
		else:
			ray_null(pos,block,func_name)
func _on_check(name,obj_name,index):
	return 1
func collision_filtration(obj):
	return 0
func ray_null(pos,block,func_name):
	pass
func place_block(block,obj,index,func_name,self_block):
		get_tree().call_group(0,"plane",func_name,block.name,obj.get_pos()-direction_arr[index].vector)
		block.num-=1
		if(self_block!=null):
			self_block._on_free()
		get_tree().call_group(0,"bar","update")