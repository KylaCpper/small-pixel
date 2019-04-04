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
	if randi()%2:
		get_node("sprite").set_flip_h(true)
	var obj = Function.ray(ray,ray_pos+Vector2(0,-32))
	if(obj==null):
		get_tree().call_group(0,"plane","place","door0",get_pos()+Vector2(0,-32))
	else:
		if Config.items_type[obj.name]=="liquid":
			obj._on_free()
			get_tree().call_group(0,"plane","place","door0",get_pos()+Vector2(0,-32))
		else:
			_on_free()
	pass
func _active():
	_msg_door()
	get_node("sprite").set_texture(Overall.textures.door1)
	Function.msg_group("sound","effects","other","door_open",get_pos())
	pass
func _unactive():
	_msg_door()
	get_node("sprite").set_texture(Overall.textures.door2)
	Function.msg_group("sound","effects","other","door_close",get_pos())
	pass
func _on_mouse_right():
	_on_active(!active)
func _msg_door():
	if(active):
		get_node("ani").play("open")
		set_layer_mask_bit(3,false)
		
	else:
		get_node("ani").play("close")
		set_layer_mask_bit(3,true)
	var obj = Function.ray(ray,ray_pos+Vector2(0,-32))
	if(obj!=null):
		if(obj.name=="door0"):
			obj._on_active(active)
func _free():
	var obj = Function.ray(ray,ray_pos+Vector2(0,-32))
	if(obj!=null):
		if(obj.name=="door0"):
			obj._on_free(0)
func _on_save():
	var h=0
	if get_node("sprite").is_flipped_h():
		h=1
	return {"h":h}
func _on_load(data):
	if "h" in data:
		get_node("sprite").set_flip_h(data.h)