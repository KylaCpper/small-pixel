extends "../../Function.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const TIME=25*24
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
	get_node("time").set_wait_time(TIME)
	get_node("time").connect("timeout",self,"glow_grass")
	get_node("time").start()
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
func _on_mouse_right():
	if(Config.items_type[Overall.hand.name]=="tool"):
		if(Config.tools[Overall.hand.name].type=="hoe"):
			Overall.hand.health-=1
			if(Overall.hand.health<=0):
				Function.clear_item(Overall.hand)
			_free()
			Function.msg_group("plane","replace",self,"dirt_plow")
			
	Function.msg_group("bar","update")
func glow_grass():
		if randi()%100<4:
			var pos=get_pos()
			pos.y-=32
			Function.msg_group("plane","create_pig",pos)
		var obj=Function.ray(ray,ray_pos+Vector2(-32,0))
		if(obj):
			if(obj.name=="dirt"):
				if(!Function.ray(ray,ray_pos+Vector2(-32,-32))):
					if(!obj.clam):
						Function.msg_group("plane","replace",obj,"grass_dirt",2)
						Function.msg_group("sound","effects","place","grass",get_pos())
						return
		
		obj=Function.ray(ray,ray_pos+Vector2(32,0))
		if(obj):
			if(obj.name=="dirt"):
				if(!Function.ray(ray,ray_pos+Vector2(32,-32))):
					if(!obj.clam):
						Function.msg_group("plane","replace",obj,"grass_dirt",2)
						Function.msg_group("sound","effects","place","grass",get_pos())
						return
		obj=Function.ray(ray,ray_pos+Vector2(0,-32))
		if(obj):
			obj=Function.ray(ray,ray_pos+Vector2(-32,-32))
			if(obj):
				if(obj.name=="dirt"):
					if(!Function.ray(ray,ray_pos+Vector2(-32,-64))):
						if(!obj.clam):
							Function.msg_group("plane","replace",obj,"grass_dirt",2)
							Function.msg_group("sound","effects","place","grass",get_pos())
							return
			obj=Function.ray(ray,ray_pos+Vector2(32,-32))
			if(obj):
				if(obj.name=="dirt"):
					if(!Function.ray(ray,ray_pos+Vector2(32,-64))):
						if(!obj.clam):
							Function.msg_group("plane","repeat",obj,"grass_dirt",2)
							Function.msg_group("sound","effects","place","grass",get_pos())
							return
func _free():
	if(randi()%101+0<18):
		var seeds=["wheat_seed","wheat_seed","paddy_seed","paddy_seed","herb"]
		var seed_random=randi()%5+0
		
		Function.msg_group("plane","drop_item",{"name":seeds[seed_random],"num":1,"health":0},get_pos())
