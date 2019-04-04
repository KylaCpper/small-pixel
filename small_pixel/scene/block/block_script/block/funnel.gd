extends "../../Block.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
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
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
	pass
func _on_timeout():
	var obj=Function.ray(ray,ray_pos+Vector2(0,32))
	if(!obj):
		var item=Function.ray(get_node("../../ray_item"),ray_pos+Vector2(-16,-17))
		if(item):
			var pos=get_pos()
			item.set_pos(pos+Vector2(0,17))
	elif(obj.name in Config.box):
		var item=Function.ray(get_node("../../ray_item"),ray_pos+Vector2(-16,-17))
		if(item):
			var item_={"name":item.name,"num":item.num,"health":item.health}
			if(obj.add_item(item_)):
				item.queue_free()
			else:
				item.num=item_.num
				item_.clear()