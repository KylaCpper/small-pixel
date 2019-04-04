extends "../../Switch.gd"
# class member variables go here, for example:
# var a = 2       
# var b = "textvar"
func _enter_tree():
	if(!onec):
		return
	var ani = AnimationPlayer.new()
	ani.set_name("ani")
	add_child(ani)
	get_node("ani").add_animation("button",Overall.anms.button)
var dire=[
		{"vec":Vector2(-32,0),"h":0,"pos":Vector2(-15,0),"dire":"left"},
		{"vec":Vector2(32,0),"h":1,"pos":Vector2(15,0),"dire":"right"},
]
var dire_num=-1
var direction="left"
func _ready():
	if(!onec):
		return
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
	get_node("ani").connect("finished",self,"_on_ani_end")
	for i in range(2):
		if(check_block(i)):
			break
		if(i==1):
			_on_free()
			
	pass
func _on_update():
	if(dire_num==-1):return
	if(!check_block(dire_num)):
		_on_free()
func check_block(i):
	var obj=Function.ray(ray,ray_pos+dire[i].vec)
	if(obj!=null):
		if(Config.items_type[obj.name]=="block"||Config.items_type[obj.name]=="gear"):
			direction=dire[i].dire
			get_node("sprite").set_pos(dire[i].pos)
			get_node("sprite").set_flip_h(dire[i].h)
			dire_num=i
			return 1
		else:
			return 0
	else:
		return 0
func _on_active(be):
	active=be
	if(active):
		_activate()
	ray_msg()
func _activate():
	_on_ani()
func ray_msg():
	var vec
	if(direction=="left"):
		vec=Vector2(-32,0)
	else:
		vec=Vector2(32,0)
	var obj=Function.ray(ray,ray_pos+vec)
	if(obj!=null):
		obj._on_active(active)
	obj=Function.ray(ray_bg,ray_bg_pos+vec)
	if(obj!=null):
		obj._on_active(active)
	
	pass
func _on_ani():
	Function.msg_group("sound","effects","switch","button",get_pos())
	get_node("ani").play("button")
func _on_ani_end():
	Function.msg_group("sound","effects","switch","button",get_pos())
	_on_active(0)
func _on_load(data):
	pass