extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var name="grass_dirt"
var num=1
var health=0
func _ready():
	add_to_group("drop_item")
	if(name in Config.blocks):
		if("friction" in Config.blocks[name]):
			set_friction(Config.blocks[name].friction)
		if("bounce" in Config.blocks[name]):
			set_bounce(Config.blocks[name].bounce)
	
	get_node("area").connect("body_enter",self,"_on_enter")
	get_node("time").connect("timeout",self,"_on_time_out")
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func _on_enter(obj):
	if(str(obj.get_name())=="player"):
		if(!obj.over):
			get_tree().call_group(0,"bar","add_item",{"name":name,"num":num,"health":health})
			Function.msg_group("sound","effects","other","pick",get_pos())
			queue_free()
		pass
func _on_time_out():
	queue_free()
func check_chunk(chunk):
	var pos=get_pos()
	var x=int((pos.x/32+100)/32)
	var y=int((pos.y/32+140)/32)
	if abs(chunk[0]-x)>2||abs(chunk[1]-y)>2:
		set_sleeping(true)
	else:
		set_sleeping(false)
	
	