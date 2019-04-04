extends "../../Light.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _enter_tree():
	if(!onec):
		return
	var time = Timer.new()
	time.set_name("time")
	time.set_wait_time(0.5)
	add_child(time)
var torch=-1
func _ready():
	if(!onec):
		return
	get_node("time").connect("timeout",self,"change_texture")
	get_node("time").start()
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
	get_node("collision").set_trigger(true)
	set_layer_mask_bit(3,false)
	pass
func change_texture():
	torch+=1
	if torch==2:
		torch=-1
	if torch==-1:
		get_node("sprite").set_texture(Overall.textures.torch)
	else:
		get_node("sprite").set_texture(Overall.textures["torch"+str(torch)])
	