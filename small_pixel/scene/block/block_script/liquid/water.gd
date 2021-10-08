extends "../../Liquid.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const TIME = 25*8
func _enter_tree():
	if(!onec):
			return
	
	var time = Timer.new()
	time.set_name("time1")
	add_child(time)

func _ready():
	if(!onec):
			return
	
	add_to_group("_rain")
	add_to_group("water")
	get_node("time1").set_one_shot(false)
	get_node("time1").connect("timeout",self,"_on_timeout")
	get_node("time1").set_wait_time(TIME)
func _on_rain():
	if(Overall.weather=="rain"):
		if(__check()):
			get_node("time1").start()
		ray.set_cast_to(Vector2(0,0))
	else:
		get_node("time1").stop()
func _on_timeout():
	if(Overall.weather=="rain"):
		if(__check()):
			Function.msg_group("plane","place_liquid","water",get_pos()+Vector2(0,-32))
		ray.set_cast_to(Vector2(0,0))
func __check():
	ray.set_cast_to(Vector2(0,-3000))
	var obj=Function.ray(ray,get_pos()+Vector2(0,-32))
	if(obj):
		if(obj.name=="water"):
			if(obj.direction!="static"):
				obj=Function.ray(ray,get_pos()+Vector2(0,-64))
				if(!obj):
					return 1
	else:
		return 1


