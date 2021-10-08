extends "../../Block.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	if(!onec):
			return
	
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
	pass

func drop_item(tool_ture,tool_type):
	if(tool_ture):
		var stone="crushed_stone"
		if(randi()%101+0<15):
			stone="stone"
		Function.msg_group("plane","drop_item",{"name":stone,"num":1,"health":0},get_pos())
