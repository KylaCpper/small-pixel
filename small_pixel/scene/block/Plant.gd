extends "Function.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var status=0
var status_count=0
var time=0
var time_max=1200
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
	get_node("collision").set_trigger(true)
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#Input.warp_mouse_pos(get_viewport().get_mouse_pos())
	get_node("sprite").set_z(3)
	set_layer_mask_bit(3,false)
	pass
func _on_update():
	var obj=Function.ray(ray,ray_pos+Vector2(0,32))
	if(obj==null):
		_on_free()
func init():
	time_max=Config.plants[name].time
	status_count=Config.plants[name].status.size()-1
	get_node("sprite").set_texture(Overall.textures[Config.plants[name].status[0]])
	get_node("time").start()
var time_be=0
func _on_timeout():
	if(time>=time_max):
		_on_grow()
		time=0
	var obj=Function.ray(ray,ray_pos+Vector2(0,32))
	if(obj!=null):
		if(obj.name=="dirt_plow"):
			if(obj.water):
				time+=1
		else:
			_on_free()
func _on_grow():
	if(status<status_count):
		status+=1
		get_node("sprite").set_texture(Overall.textures[Config.plants[name].status[status]])
	pass
func _free():
	if(status==status_count):
		if(Config.plants[name].drop.size()>0):
			for drop in Config.plants[name].drop:
				if("min" in drop):
					if("random" in drop):
						if((randi() % 101+1)<drop.random):
							for i in range(randi() % (drop.num+1)+drop["min"]):
								Function.msg_group("plane","drop_item",{"name":drop.name,"num":1,"health":0},get_pos())
					else:
						for i in range(randi() % (drop.num+1)+drop["min"]):
							Function.msg_group("plane","drop_item",{"name":drop.name,"num":1,"health":0},get_pos())
				else:
					if("random" in drop):
						if((randi() % 101+1)<drop.random):
							for i in range(drop.num):
								Function.msg_group("plane","drop_item",{"name":drop.name,"num":1,"health":0},get_pos())
					else:
						for i in range(drop.num):
							Function.msg_group("plane","drop_item",{"name":drop.name,"num":1,"health":0},get_pos())
func _on_save():
	return {"status":status,"time":time}
func _on_load(data):
	status=data.status
	time=data.time
	get_node("sprite").set_texture(Overall.textures[Config.plants[name].status[status]])