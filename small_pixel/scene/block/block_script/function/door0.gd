extends "../../Function.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _enter_tree():
	if(!onec):
			return
	
	var ani = AnimationPlayer.new()
	ani.set_name("ani")
	ani.add_animation("open",Overall.anms.door_open)
	ani.add_animation("close",Overall.anms.door_close)
	add_child(ani)
	
func _ready():
	if(!onec):
		return
	
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
	get_node("ani").play("close")
	set_bounce(1)
	get_node("sprite").set_texture(Overall.textures.door2)
	var obj=Function.ray(ray,ray_pos+Vector2(0,32))
	get_node("sprite").set_flip_h (obj.get_node("sprite").is_flipped_h())
	active=obj.active
	if active:
		get_node("ani").play("open")
		set_layer_mask_bit(3,false)
	pass
func _on_mouse_right():
	_on_active(!active)

func _active():
	_msg_door()
	get_node("sprite").set_texture(Overall.textures.door0)
	pass
func _unactive():
	_msg_door()
	get_node("sprite").set_texture(Overall.textures.door2)
	pass
func _msg_door():
	if(active):
		get_node("ani").play("open")
		set_layer_mask_bit(3,false)
		
	else:
		get_node("ani").play("close")
		set_layer_mask_bit(3,true)
		
	var obj = Function.ray(ray,ray_pos+Vector2(0,32))
	if(obj!=null):
		if(obj.name=="door"):
			obj._on_active(active)
func _free():
	var obj = Function.ray(ray,ray_pos+Vector2(0,32))
	if(obj!=null):
		if(obj.name=="door"):
			obj.queue_free()
func _on_total_save():
	return null