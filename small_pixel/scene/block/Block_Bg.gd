extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var name=""
var big_device=null
var active=0
var group="block_bg"
var onec=1
var bg=1
func _enter_tree():
	if(!onec):
		return
	

func _ready():
	if(!onec):
		return
	onec=0
	add_to_group(group)
	get_node("sprite").set_modulate(Color(0.8,0.8,0.8))
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
	pass

func _on_free(drop=1,tool_ture=false,tool_type="def"):
	if(drop):
		drop_item(tool_ture,tool_type)
	_free()
	queue_free()
	free_()
	if(big_device!=null):
		big_device_cancel()
	if(Config.items_type[name]=="liquid"):return
	var block
	if(name in Config.blocks):
		block=Config.blocks[name]
	else:
		block=Config.blocks.default
	if("sound" in block):
		Function.msg_group("sound","effects","drop",block.sound,get_pos())
	else:
		Function.msg_group("sound","effects","drop","stone",get_pos())
func drop_item(tool_ture,tool_type):
	var drops
	if(tool_ture):
		if(tool_type in Config.drops[name]):
			drops=Config.drops[name][tool_type]
		else:
			drops=Config.drops[name].def
	else:
		if(name in Config.drops):
			drops=Config.drops[name].def
		else:
			drops=Config.drops["default"].def
	if(drops!=null):
		for drop in drops:
			if("min" in drop):
				if("random" in drop):
					if((randi() % 100+0)<drop.random):
						Function.msg_group("plane","drop_item",{"name":drop.name,"num":randi() % drop.num+drop["min"],"health":0},get_pos())
				else:
					Function.msg_group("plane","drop_item",{"name":drop.name,"num":randi() % drop.num+drop["min"],"health":0},get_pos())
			else:
				if("random" in drop):
					if((randi() % 100+0)<drop.random):
						Function.msg_group("plane","drop_item",{"name":drop.name,"num":drop.num,"health":0},get_pos())
				else:
					Function.msg_group("plane","drop_item",{"name":drop.name,"num":drop.num,"health":0},get_pos())

func _free():
	pass
func free_():
	pass
func _on_active(be):
	pass
func _on_total_save():
	var pos=get_pos()
	return {"name":name,"pos":{"x":pos.x,"y":pos.y},"big_device":0,"bg":1}
func _on_load(data):
	pass