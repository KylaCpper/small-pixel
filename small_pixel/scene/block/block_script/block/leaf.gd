extends "../../Block.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var status=0
var wood=0
func _enter_tree():
	if(!onec):
			return
	
	var time = Timer.new()
	time.set_name("time")
	add_child(time)
func _ready():
	if(!onec):
		return
	get_node("time").set_wait_time(10)
	get_node("time").connect("timeout",self,"_on_died")

	pass
func _on_died():
	if(!status):
		get_node("sprite").set_texture(Overall.textures.leaf_dead)
		name="leaf_dead"
	else:
		_on_free(1)
	status+=1
func _on_update():
	var wood=0
	for vec in Overall.vec:
		if(check_leaf(vec,1)):
			get_node("time").stop()
			return
	get_node("time").start()
func check_leaf(vec,index):
	var obj= Function.ray(ray,ray_pos+vec*index)
	if(obj!=null):
		if(obj.name=="wood"):
			return 1
		elif(obj.name=="leaf"):
			if(index==3):
				return 0
			else:
				return check_leaf(vec,index+1)
		else:
			return 0
	else:
		return 0