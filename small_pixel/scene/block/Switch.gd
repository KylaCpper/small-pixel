extends "Function.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var energy=1
func _ready():
	if(!onec):
		return
	set_layer_mask_bit(3,false)
	get_node("collision").set_trigger(1)
	#get_node("ani").add_animation("gear",preload("res://scene/block/ani/gear.tres"))
	#get_node("ani").connect("finished",self,"_on_rot_gear_end")
	connect("mouse_exit",self,"_on_exit")
	"""
	var obj=Function.ray(ray,ray_pos+vec)
	if(obj!=null&&!obj.is_queued_for_deletion()):
		if(Config.items_type[obj.name]=="gear"):
			add_strick(data)
			obj.add_strick(opposite)
	"""
	pass
func _on_exit():
	pass
func _on_mouse_right():
	_on_active(1)

func _on_active(be):
	if(active!=be):
		active=be
		if(active):
			_active()
		else:
			_unactive()
	ray_msg()
	pass
func ray_msg():
	pass
func _on_save():
	return {"active":active}
func _on_load(data):
	_on_active(data.active)