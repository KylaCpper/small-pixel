extends "../../Function.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var clam=0
var time=0
const TIMEMAX=5
func _enter_tree():
	if(!onec):
		return
	var time = Timer.new()
	time.set_name("time")
	add_child(time)
func _ready():
	if(!onec):
		return
	get_node("time").set_one_shot(false)
	get_node("time").connect("timeout",self,"_on_timeout")
	var obj=Function.ray(ray,ray_pos+Vector2(0,-32))
	if(obj!=null):
		if(obj.name=="water"):
			if((randi() % 101+0)<50):
				clam=1
			if(clam):
				set_clam()
		
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
	pass
func _on_timeout():
	var obj=Function.ray(ray,ray_pos+Vector2(0,-32))
	if(obj!=null):
		if(obj.name=="water"):
			time+=1
		else:
			time-=1
	else:
		time-=1
	if(time>TIMEMAX):
		time=0
		var obj=Function.ray(ray,ray_pos+Vector2(-32,0))
		if(obj!=null):
			if(obj.name=="sand"||obj.name=="dirt"):
				if(!obj.clam):
					obj.set_clam()
					return
		obj=Function.ray(ray,ray_pos+Vector2(32,0))
		if(obj!=null):
			if(obj.name=="sand"||obj.name=="dirt"):
				if(!obj.clam):
					obj.set_clam()
		
	elif(time<=0):
		clear_clam()
		time=0

func clear_clam():
	get_node("sprite").set_texture(Overall.textures.sand)
	clam=0
	get_node("time").stop()
	
func set_clam():
	get_node("sprite").set_texture(Overall.textures.sand_clam)
	clam=1
	get_node("time").start()
func _on_mouse_right():
	if(Overall.hand.name==null):
		if(clam):
			clear_clam()
			Overall.hand.name="clam"
			Overall.hand.num+=1
	elif(Overall.hand.name=="clam"):
			if(!clam):
				set_clam()
				Overall.hand.num-=1
				if(Overall.hand.num<=0):
					Overall.hand.name=null
	Function.msg_group("bar","update")

func _free():
	if(clam):
		Function.msg_group("plane","drop_item",{"name":"clam","num":1,"health":0},get_pos())
func _on_save():
	return {"clam":clam}
func _on_load(data):
	clam=data.clam
	if(clam):
		set_clam()