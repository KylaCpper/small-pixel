extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group="sound"
func _ready():
	add_to_group(group)
	#get_node("SamplePlayer2D").set_param()
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("time").connect("timeout",self,"time_out")
	get_node("music").connect("finished",self,"music_end")
	get_node("time").start()
	pass
func move(name):
	get_node("move").play(name)
func music(n_name):
	get_node(n_name).play()
func stop(n_name):
	get_node(n_name).stop()
func effects(n_name,name,pos):
	set_pos(pos)
	get_node(n_name).play(name)
func time_out():
	var time=randi()% 100 + 30
	get_node("time").set_wait_time(time)
	get_node("music").play()
func music_end():
	get_node("time").start()
func eat():
	if(!get_node("eat").is_active()):
		get_node("eat").play("eat")
func eat_stop():
	get_node("eat").stop_all()

	
	