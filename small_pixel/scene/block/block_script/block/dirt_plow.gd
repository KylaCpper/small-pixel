extends "../../Function.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var water=0
const TIMEMAX=1200
var time=0
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
	get_node("time").start()
func _on_water():
	water=1
	get_node("sprite").set_texture(Overall.textures.dirt_plow_water)
	get_node("time").start()
	#Function.msg_group("sound","effects","water","barrel",get_pos())
	time=0
func _on_timeout():
	if(time>=TIMEMAX):
		get_node("sprite").set_texture(Overall.textures.dirt_plow)
		get_node("time").stop()
		water=0
		time=0
	time+=1
func _on_save():
	return {"water":water,"time":time}
func _on_load(data):
	water=data.water
	time=data.time