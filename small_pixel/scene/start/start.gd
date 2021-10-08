extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	get_node("start").connect("pressed",self,"_on_set_name")
	get_node("load").connect("pressed",self,"_on_load")
	get_node("set").connect("pressed",self,"_on_set")
	get_node("set name/sure").connect("pressed",self,"_on_start")
	get_node("set name/edit").connect("text_entered",self,"_on_start")
	get_node("set name/close").connect("pressed",self,"_on_close")
	get_node("set_control/esc").connect("pressed",self,"_on_esc")
	set_process_input(true)
	pass
func _input(event):
	if(event.is_action_pressed("esc")):
		if(get_node("set name").is_visible()):
			get_node("set name").hide()
		elif(get_node("help/window").is_visible()):
			get_node("help")._on_close()
		elif(get_node("donate window").is_visible()):
			get_node("donate window")._on_close()
		elif(get_node("donate list window").is_visible()):
			get_node("donate list window")._on_close()
		else:
			get_tree().call_group(0,"set","_display")
	pass
func _on_esc():
	var ev = InputEvent()
	ev.set_as_action("esc", true)
	Input.parse_input_event(ev)
	pass
func _on_set_name():
	get_node("set name").show()
	pass

func _on_start(name_=null):
	var name=get_node("set name/edit").get_text()
	if(name):
		Overall.SetName(name)
		Global.GoTo_Scene("res://scene/main.tscn")
	pass
func _on_close():
	get_node("set name").hide()
	pass
func _on_load():
	Global.GoTo_Scene("res://scene/load.tscn")
func _on_set():
	get_node("set window")._display()
	

	
	
#func _ready():
 #   set_process(true)

#func _process(delta):
    # do something...
