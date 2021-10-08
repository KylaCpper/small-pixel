extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("close").connect("pressed",self,"_on_close_press")
	
	get_node("ali").connect("pressed",self,"_on_open_window",["ali"])
	get_node("wechat").connect("pressed",self,"_on_open_window",["wechat"])
	
	get_node("ali window/close").connect("pressed",self,"_on_close_window",["ali"])
	get_node("wechat window/close").connect("pressed",self,"_on_close_window",["wechat"])
	
	get_node("ali window/big").connect("pressed",self,"_on_big_window",["ali"])
	get_node("wechat window/big").connect("pressed",self,"_on_big_window",["wechat"])
	get_node("ali window/open").connect("pressed",self,"_on_open_ali")
	
	get_node("ali window/enlarge").connect("input_event",self,"_on_small_window",["ali"])
	get_node("wechat window/enlarge").connect("input_event",self,"_on_small_window",["wechat"])
	pass
func _on_close_press():
	get_tree().call_group(0,"home","close_other_window","donate")
	pass
func _on_open_ali():
	OS.shell_open("https://qr.alipay.com/FKX08349RKEXLZ4DXWDL4D")
func _on_open_window(name):
	get_node(name+" window").show()
func _on_close_window(name):
	get_node(name+" window").hide()
func _on_big_window(name):
	get_node(name+" window/enlarge").show()
func _on_small_window(event,name):
	if(event.is_action_released("mouse_left")):
		get_node(name+" window/enlarge").hide()