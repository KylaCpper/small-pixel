extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group="home"
func _ready():
	add_to_group(group)
	get_node("start").connect("pressed",self,"_on_start_press")
	get_node("load").connect("pressed",self,"show_other_window",["load"])
	get_node("set").connect("pressed",self,"show_other_window",["set"])
	get_node("multiplayer").connect("pressed",self,"show_other_window",["multiplayer"])
	#get_node("help").connect("pressed",self,"show_other_window",["help"])
	get_node("exit").connect("pressed",self,"_on_exit_press")
	
	#set name window
	get_node("set seed/sure").connect("pressed",self,"_on_setseed_press",[1])
	get_node("set seed/close").connect("pressed",self,"_on_setseed_press",[0])
	get_node("set seed/edit").connect("text_entered",self,"_on_setseed")
	
	get_node("sure exit/sure").connect("pressed",self,"_on_exit",[1])
	get_node("sure exit/close").connect("pressed",self,"_on_exit",[0])
	set_process(false)
	pass
func _process(delta):
#	var msg=Steam.run_callbacks()
#	if(msg):
#		print(msg)
	pass
func _on_start_press():
	Overall.Load=0
	get_node("set seed").show()
	get_node("set seed/edit").set_text(str(randi()% 1000000 + 0))
	pass

func _on_setseed_press(select):
	if(select):
		#start game
		var seed_be=get_node("set seed/edit").get_text()
		enter_game(seed_be)
		pass
	else:
		get_node("set seed").hide()
	pass
func _on_setseed(seed_be):
	enter_game(seed_be)
func enter_game(seed_be):
	if(!seed_be):seed_be=randi()% 1000000 + 0
	Overall.Load=0
	Overall.Seed=int(seed_be)
	Global.GoTo_Scene("res://scene/start/start0/start0.tscn","res://scene/main/main.tscn")
func _on_exit_press():
	get_node("sure exit").show()
	pass
func _on_exit(sure):
	if(sure):
		get_tree().quit()
	else:
		get_node("sure exit").hide()
var first=0
func show_other_window(name):
	hide()
	if (name=="load"&&first==0):
		get_node("../load")._on_load()
		first=1
	get_parent().get_node(name).show()
	pass
func close_other_window(name):
	show()
	get_parent().get_node(name).hide()
	pass