extends "../../FunctionGui.gd"

# class member variables go here, for example:
# var a = 2

onready var pos=get_node("sprite").get_pos()
func _ready():
	if(!onec):
		return
	grid=28
	init()
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func _on_mouse_right():
	var obj=Function.ray(ray,ray_pos+Vector2(0,-32))
	if(obj!=null):
		if(obj.name in Config.open):
			var a=1
		else:
			return
	get_tree().call_group(0,"wood_box","display",1,["items"],self)
func open():
	get_node("sprite").set_texture(Overall.textures.wood_box_open)
	get_node("sprite").set_pos(pos+Vector2(0,-16))
	Function.msg_group("sound","effects","other","box_open",get_pos())
func close():
	get_node("sprite").set_texture(Overall.textures.wood_box)
	get_node("sprite").set_pos(pos)
	
	Function.msg_group("sound","effects","other","box_close",get_pos())