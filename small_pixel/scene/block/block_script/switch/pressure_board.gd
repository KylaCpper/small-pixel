extends "../../Switch.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _enter_tree():
	if(!onec):
		return
	var time = Timer.new()
	time.set_name("time")
	time.set_wait_time(0.5)
	time.set_one_shot(true)
	add_child(time)
	var area=Overall.scenes.pressure_board.instance()
	area.set_name("area")
	add_child(area)
func _ready():
	
	get_node("time").connect("timeout",self,"_on_close")
	get_node("area").connect("body_enter",self,"_on_enter")
	get_node("area").connect("body_exit",self,"_on_exit_")
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func _on_mouse_right():
	pass
func _on_update():
	var obj=Function.ray(ray,ray_pos+Vector2(0,32))
	if obj==null:
		_on_free()
func _on_close():
	get_node("sprite").set_texture(Overall.textures.pressure_board)
	Function.msg_group("sound","effects","switch","bounce",get_pos())
	_on_active(0)
	
	pass
func _on_enter(obj):
	if obj.get_type()=="StaticBody2D":return
	get_node("time").stop()
	get_node("sprite").set_texture(Overall.textures.pressure_board1)
	Function.msg_group("sound","effects","switch","on",get_pos())
	_on_active(1)
	pass
func _on_exit_(obj):
	get_node("time").start()
	pass
func ray_msg():
	var vecs=[Vector2(-32,0),Vector2(32,0),Vector2(0,32)]
	for vec in vecs:
		var obj=Function.ray(ray,ray_pos+vec)
		if(obj!=null):
			obj._on_active(active)
		obj=Function.ray(ray_bg,ray_bg_pos+vec)
		if(obj!=null):
			obj._on_active(active)
func _on_load(data):
	pass