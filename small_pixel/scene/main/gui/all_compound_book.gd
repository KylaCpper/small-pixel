extends "./Gui.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group="all_compound_book"
onready var scene=preload("compound_table/compound_table.tscn")
onready var scene_stove=preload("compound_table/stove.tscn")
var keys=[null,null]
var compound_name="workbench"
var nodes_name=["workbench","stove","high_stove","big_block"]
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here
	
	_on_all()
	get_node("all").connect("pressed",self,"_on_all")
	
	
	for node_name in nodes_name:
		get_node("v/"+node_name+"/all").connect("pressed",self,"_on_select",[node_name])
		get_node("v/"+node_name+"/all").connect("mouse_enter",self,"_on_enter",[node_name])
		get_node("v/"+node_name+"/all").connect("mouse_exit",self,"_on_exit")
	
	
func _on_enter(name):
	OverallGui.item_info({"name":name},0)
func _on_exit():
	OverallGui.item_info()
	pass
func _on_select(name):
	compound_name=name
	for node_name in nodes_name:
		get_node(node_name).hide()
	get_node(compound_name).show()
func _on_all():
	if(compound_name=="workbench"):
		get_tree().call_group(0,compound_name+"_","queue_free")
		var i=0
		for key in Config.compound_table:
			i=create_tscn(i,keys,key)
	elif(compound_name=="stove"||compound_name=="high_stove"):
		get_tree().call_group(0,compound_name+"_","queue_free")
		for key in Config.stove_table:
			create_tscn(0,0,key,compound_name)

func _to(name):
	get_node(compound_name).set_v_scroll(0)
	OverallGui.item_info()
	get_tree().call_group(0,compound_name+"_","queue_free")
	if(compound_name=="workbench"):
		var i=0
		for key in Config.compound_table:
			if(key.find(name)!=-1):
				i=create_tscn(i,keys,key)
		if(i==1):
			var tscn_=scene.instance()
			tscn_.keys[0]=keys[0]
			tscn_.keys[1]=null
			tscn_.group=compound_name+"_"
			get_node(compound_name+"/v").add_child(tscn_)
			tscn_.init()
	elif(compound_name=="stove"||compound_name=="high_stove"):
		for key in Config.stove_table:
			if(key.find(name)!=-1):
				create_tscn(0,0,key,compound_name)
func _from(name):
	get_node(compound_name).set_v_scroll(0)
	OverallGui.item_info()
	get_tree().call_group(0,compound_name+"_","queue_free")
	if(compound_name=="workbench"):
		var i=0
		for key in Config.compound_table:
			if(Config.compound_table[key].name==name):
				i=create_tscn(i,keys,key)
		if(i==1):
			var tscn_=scene.instance()
			tscn_.keys[0]=keys[0]
			tscn_.keys[1]=null
			tscn_.group=compound_name+"_"
			get_node(compound_name+"/v").add_child(tscn_)
			tscn_.init()
	elif(compound_name=="stove"):
		for key in Config.stove_table:
			if(!"def" in Config.stove_table[key]):continue
			for data in Config.stove_table[key].def:
				if(data.name==name):
					create_tscn(0,0,key,compound_name)
					break
	elif(compound_name=="high_stove"):
		for key in Config.stove_table:
			if(!"high_stove" in Config.stove_table[key]):continue
			for data in Config.stove_table[key].high_stove:
				if(data.name==name):
					create_tscn(0,0,key,compound_name)
					break
func create_tscn(i,keys,key,mode="workbench"):
	if(mode=="workbench"):
		keys[i]=key
		i+=1
		if(i==2):
			var tscn=scene.instance()
			tscn.keys[0]=keys[0]
			tscn.keys[1]=keys[1]
			tscn.group=compound_name+"_"
			get_node(compound_name+"/v").add_child(tscn)
			tscn.init()
			i=0
		return i
	elif(mode=="stove"||mode=="high_stove"):
		var tscn=scene_stove.instance()
		tscn.key=key
		tscn.group=compound_name+"_"
		get_node(compound_name+"/v").add_child(tscn)
		tscn.init()
	elif(mode=="big_block"):
		pass
	