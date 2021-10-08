extends "Block.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var direction="static"
var speed=10
var flow=-1
func _ready():
	if(!onec):
		init()
		return
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	connect("input_event",self,"event")
	
	get_node("time").connect("timeout",self,"checkout")
	get_node("sprite").set_z(4)
	
	pass
func init():
	get_node("time").set_wait_time(0.3/speed)
	get_node("time").start()
	init_()
func init_():
	get_node("area").set_gravity(49*speed)
func event(event,index,idx):
	pass
var check_flow=[1,1,1]
func _on_update():
	if(get_node("time").get_time_left()==0):
		get_node("time").start()
func checkout():
	ray_exam("down")
	ray_exam("left")
	ray_exam("right")
	for data in check_flow:
		if(data):return
	get_node("time").stop()
func ray_exam(dire):
	var vec=Vector2(0,0)
	var flow_=flow+1
	var i =0
	if(dire=="left"):
		vec=Vector2(-32,0)
	elif(dire=="right"):
		i=1
		vec=Vector2(32,0)
	elif(dire=="down"):
		i=2
		vec=Vector2(0,32)
		if(flow_<=2):
			flow_=0
		else:
			flow_-=2
	var obj=Function.ray(ray,ray_pos+vec)
	if(obj):
		if((obj.name==name)&&obj.direction!="static"):
			if(obj.direction==dire):
				obj._continue+=0.3/speed
				check_flow[i]=1
			else:
				if(dire=="down"):
					obj.queue_free()
					get_tree().call_group(0,"plane","place_flow",flow_,name,get_pos()+vec,dire)
					check_flow[i]=1
		else:
			if(Config.items_type[obj.name]=="seed"||obj.name=="torch"):
				obj._on_free()
				get_tree().call_group(0,"plane","place_flow",flow_,name,get_pos()+vec,dire) 
				check_flow[i]=1
			elif(obj.name=="dirt_plow"):
				obj._on_water()
				check_flow[i]=0
			else:
				check_flow[i]=0
	else:
		get_tree().call_group(0,"plane","place_flow",flow_,name,get_pos()+vec,dire) 
		check_flow[i]=1
func init_ray_bg():
	pass