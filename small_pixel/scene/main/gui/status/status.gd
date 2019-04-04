extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var status=0
var info="asdasdsad"
var time=3
func _ready():
	
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("time").connect("timeout",self,"_on_timeout")
	pass
func init():
	add_to_group(status)
	add_to_group("player_status")
	get_node("icon").set_normal_texture(Overall.textures[status])
	get_node("name").set_text(status)
	
	get_node("info").set_text(info)
	get_node("time_text").set_text(str(time))
	get_node("time").start()
	change_offset()
	pass
func _on_timeout():
	time-=1
	get_node("time_text").set_text(str(time))
	if(time<=0):
		_on_free()
func _on_free():
	Overall.status_list[status]=null
	change_offset()
	queue_free()
func change_offset():
	var list=Overall.status_list
	var speed=1
	var food=1
	for key in list:
		if(list[key]!=null):
			if("speed" in Config.status[key]):
				speed*=1/float(Config.status[key].speed)
			if("food" in Config.status[key]):
				food*=Config.status[key].food
	Function.msg_group("player","change_offset","status_pro",speed)
	Function.msg_group("player","change_offset","food_pro",food)
	
	