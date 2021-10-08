extends "../../Switch.gd"
# class member variables go here, for example:
# var a = 2       
# var b = "textvar"
var direction="down"
var dire_num=-1
func _ready():
	if(!onec):
		return
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
	
	for i in range(4):
		if(check_block(i)):
			break
		if(i==3):
			_on_free()
			
	pass
var dire=[{"vec":Vector2(0,32),"rot":0,"dire":"down"},
		{"vec":Vector2(-32,0),"rot":-90,"dire":"left"},
		{"vec":Vector2(32,0),"rot":90,"dire":"right"},
		{"vec":Vector2(0,-32),"rot":180,"dire":"up"},
]
func check_block(i):
	var obj=Function.ray(ray,ray_pos+dire[i].vec)
	if(obj!=null):
		if(Config.items_type[obj.name]=="block"||Config.items_type[obj.name]=="gear"):
			direction=dire[i].dire
			get_node("sprite").set_rotd(dire[i].rot)
			dire_num=i
			return 1
		else:
			return 0
	else:
		return 0
func _on_update():
	if(dire_num==-1):return
	if(!check_block(dire_num)):
		_on_free()
		
func _on_mouse_right():
	Function.msg_group("sound","effects","switch","pull_rod",get_pos())
	_on_active(!active)

func _active():
	get_node("sprite").set_flip_h(1)
func _unactive():
	get_node("sprite").set_flip_h(0)
	pass
func ray_msg():
	var vec=Vector2(0,32)
	for data in dire:
		if(direction==data.dire):
			vec=data.vec
			break
	var obj=Function.ray(ray,ray_pos+vec)
	if(obj!=null):
		obj._on_active(active)
	obj=Function.ray(ray_bg,ray_bg_pos+vec)
	if(obj!=null):
		obj._on_active(active)
	pass
