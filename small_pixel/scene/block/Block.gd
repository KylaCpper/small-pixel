extends StaticBody2D
#block 0,1,3
#area 2
#drop 1
#shapeblock 3

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var name=null
onready var ray=get_node("../../ray")
onready var ray_pos=get_pos()
var big_device=null
onready var ray_bg=get_node("../../ray_bg")
onready var ray_bg_pos=get_pos()
var bg=0
var active=0
var group="block"
var onec=1
var _onec_=1
func _enter_tree():
	if(!_onec_):onec=0
	if(!onec):return
	_onec_=0
func _ready():
	if(!onec):
		return
	
	if(name in Config.blocks):
		if("friction" in Config.blocks[name]):
			call_deferred("set_friction",Config.blocks[name].friction)
		if("bounce" in Config.blocks[name]):
			call_deferred("set_bounce",Config.blocks[name].bounce)
		
	if(Config.items_type[name]!="liquid"):
		var block
		if(name in Config.blocks):
			block=Config.blocks[name]
		else:
			block=Config.blocks.default
		if("sound" in block):
			Function.msg_group("sound","effects","place",block.sound)
		else:
			Function.msg_group("sound","effects","place","stone")
	get_node("sprite").set_z(2)
	#get_node("mask").set_z(4)
	#get_node("select").set_z(4)
	#get_node("crack").set_z(4)
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#get_node("collision").set_trigger(true)
	#connect("exit_tree",self,"_on_free")
	call_deferred("check_gear")
	call_deferred("_on_check")
	call_deferred("_on_update")
	pass
func check_gear():
	var i=0
	for vec in Overall.vec:
		var obj=Function.ray(ray,ray_pos+vec)
		if(obj):
			if(Config.items_type[obj.name]=="gear"):
				if(obj.direction[Overall.vec_op[i]]!=null):
					if(obj.active):
						_on_active(1)
						return
		i+=1
	var obj=Function.ray(ray_bg,ray_bg_pos)
	if(obj):
		if(Config.items_type[obj.name]=="gear"):
			if(obj.active):
				_on_active(1)
func init():
	pass
func _on_update():
	pass
func _on_check():
	for i in range(4):
		var obj=Function.ray(ray,ray_pos+Overall.vec[i])
		if(obj):
			obj.call_deferred("_on_update")
func _on_free(drop=1,tool_ture=false,tool_type="def"):
	if(drop):
		drop_item(tool_ture,tool_type)
	_free()
	#get_parent().remove_child(self)
	queue_free()
	_on_check()
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
		
func _on_active(be):
	if(active!=be):
		active=be
		if(active):
			_active()
		else:
			_unactive()
	pass
func _active():
	pass
func _unactive():
	pass
func _free():
	pass
func free_():
	pass
func drop_item(tool_ture,tool_type):
	var drops=Config.drops["default"].def
	if(tool_ture):
		if(tool_type in Config.drops[name]):
			drops=Config.drops[name][tool_type]
		else:
			drops=Config.drops[name].def
	else:
		if(name in Config.drops):
			drops=Config.drops[name].def
	if(drops==null):return
	for drop in drops:
		if("min" in drop):
			if("random" in drop):
				if((randi() % 101+1)<drop.random):
					for i in range(randi() % (drop.num+1)+drop["min"]):
						Function.msg_group("plane","drop_item",{"name":drop.name,"num":1,"health":0},get_pos())
			else:
				for i in range(randi() % (drop.num+1)+drop["min"]):
					Function.msg_group("plane","drop_item",{"name":drop.name,"num":1,"health":0},get_pos())
		else:
			if("random" in drop):
				if((randi() % 101+1)<drop.random):
					for i in range(drop.num):
						Function.msg_group("plane","drop_item",{"name":drop.name,"num":1,"health":0},get_pos())
			else:
				for i in range(drop.num):
					Function.msg_group("plane","drop_item",{"name":drop.name,"num":1,"health":0},get_pos())
func big_device_cancel():
	big_device._on_cancel()
func _on_total_save():     
	var pos=get_pos()
	var data=_on_save()
	data.name=name
	data.pos={"x":pos.x,"y":pos.y}
	if(!"big_device" in data):
		data.big_device=0
	data.bg=0
	return data
func _on_load(data):
	pass
func _on_save():
	return {}