extends "../../Function.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var status=0
var liquid=null
var full=4
const TIME=25*4
func _enter_tree():
	if(!onec):
		return
	var time = Timer.new()
	time.set_name("time")
	add_child(time)

func _ready():
	if(!onec):
		return
	add_to_group("_rain")
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	get_node("time").set_one_shot(false)
	get_node("time").connect("timeout",self,"_on_timeout")
	get_node("time").set_wait_time(TIME)
	set_layer_mask_bit(3,false)
	
func _on_rain():
	if(Overall.weather=="rain"):
		if(__check()):
			get_node("time").start()
		ray.set_cast_to(Vector2(0,0))
	else:
		get_node("time").stop()
func _on_timeout():
	if(Overall.weather=="rain"):
		if(__check()):
			if(liquid==null||liquid=="water"):
				liquid="water"
				if(status!=full):
					status+=1
					get_node("sprite").set_texture(Overall.textures["wood_vat"+str(status)])
		get_node("time").start()
		ray.set_cast_to(Vector2(0,0))
func __check():
	ray.set_cast_to(Vector2(0,-3000))
	var obj=Function.ray(ray,get_pos()+Vector2(0,-32))
	if(obj):
		return 0
	else:
		return 1
func _on_mouse_right():
	if(Overall.hand.name in Config.containers_liquid):
		if(liquid==null||liquid==Config.containers_liquid[Overall.hand.name].name):
			liquid=Config.containers_liquid[Overall.hand.name].name
			if(status!=full):
				status+=1
				Overall.hand.name=Config.containers_liquid[Overall.hand.name].change
				Function.msg_group("sound","effects","water","barrel",get_pos())
				Function.msg_group("bar","update")
	elif(Overall.hand.name in Config.containers):
		if(liquid):
			Overall.hand.num-=1
			Function.msg_group("bar","add_item",{"name":Overall.hand.name+"_"+liquid,"num":1,"health":0})
			status-=1
			if(status==0):liquid=null
			Function.msg_group("sound","effects","water","barrel",get_pos())
			Function.msg_group("bar","update")
			Function.msg_group("bag","update")
	else:
		if(status>0):
			if(Overall.hand.name=="wood_bowl"):
				Function.msg_group("sound","effects","water","bottel",get_pos())
				Overall.hand.num-=1
				Function.msg_group("bar","add_item",{"name":Overall.hand.name+"_"+liquid,"num":1,"health":0})
				Function.msg_group("bar","update")
				Function.msg_group("bag","update")
	if(status==0):
		get_node("sprite").set_texture(Overall.textures.wood_vat)
	else:
		get_node("sprite").set_texture(Overall.textures["wood_vat"+str(status)])


	
func _free():
	if(status!=0):
		pass
	pass
func _on_save():
	return {"status":status,"liquid":liquid}
func _on_load(data):
	status=data.status
	liquid=data.liquid
	if(status):
		get_node("sprite").set_texture(Overall.textures["wood_vat"+str(status)])
