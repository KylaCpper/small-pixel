extends "./Gui.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group="esc"
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("set").connect("pressed",self,"_on_set")
	get_node("save").connect("pressed",self,"_on_save_thread")
	get_node("return").connect("pressed",self,"_on_return")
	get_node("exit").connect("pressed",self,"_on_exit")

	pass
func _on_save_thread():
	if(!Overall.thread[1]):
		Overall.thread[1]=1
		Overall._thread[1].start(self,"_on_save")
		Function.msg_group("cmd","add_msg",tr("saveing"),0)
		set_process(true)
		
func _process(delta):
	if !Overall.thread[1]:
		Overall._thread[1].wait_to_finish()
		set_process(false)

func _on_save(userdata):
	var data={"plane":[]}
	data.bar=get_tree().get_nodes_in_group("bar")[0].items
	data.bag=get_tree().get_nodes_in_group("bag")[0].items
	data.player=Overall.player
	var player_info=get_tree().get_nodes_in_group("player")[0]._on_save()
	data.player_info=player_info
	data.time=Overall.time
	data.status=get_tree().get_nodes_in_group("status")[0]._on_save()
	var chunks=get_node("../../plane").chunks_scene
	for key_ in chunks:
		for key in chunks[key_]:
			for _data_ in chunks[key_][key].get_children():
				if _data_.name!="pig":
					if Config.items_type[_data_.name]=="liquid":
						if _data_.direction!="static":continue
				var data_=_data_._on_total_save()
				if data_!=null:
					data.plane.append(data_)
	var map=Overall.map
	var map_data=Overall.map_data
	var map_bg=Overall.map_bg
	var map_bg_data=Overall.map_bg_data
	for x in map:
		for y in map[x]:
			if typeof(map[x][y])==TYPE_STRING:
				var data_=map_data[x][y]
				if data_==null:
					data_={"name":map[x][y],"pos":{"x":x*32,"y":y*32},"big_device":null,"bg":0}
				data.plane.append(data_)
	for x in map_bg:
		for y in map_bg[x]:
			if typeof(map_bg[x][y])==TYPE_STRING:
				var data_=map_bg_data[x][y]
				if data_==null:
					var data_={"name":map_bg[x][y],"pos":{"x":x*32,"y":y*32},"big_device":null,"bg":1}
				data.plane.append(data_)
#	for x in Overall.map_bg:
#		for y in Overall.map_bg[x]:
#			if map_bg[x][y]:
#				var data_=map_data[x][y]
#				data.plane.append(data_)
#	for i in get_tree().get_nodes_in_group("block"):
#		var data_=i._on_total_save()
#		data.plane.append(data_)
#	for i in get_tree().get_nodes_in_group("block_bg"):
#		var data_=i._on_total_save()
#		data.plane.append(data_)
	if(Overall.SaveName==null):
		var index=0
		while (1):
			var name="small_pixel"+str(index)+".save"
			if(Function.GetSaveData(name,"kyla")==0):
				Overall.SaveName=str(name)
				break
			index+=1
	Function.SetSaveData(Overall.SaveName,data,"kyla")
	Overall.thread[1]=0
	Function.msg_group("cmd","add_msg",tr("save_end"),0)
	
func _on_set():
	get_node("set").hide()
	get_node("save").hide()
	get_node("return").hide()
	get_node("exit").hide()
	
	get_node("set_page").show()
	pass
func _on_return():
	display()
	pass
func _on_exit():
	display()
	_on_init()
	Global.GoTo_Scene("res://scene/start/start.tscn")
	
	pass
func _on_init():
	Overall.Load=0
	Overall.player={
		"health":{"val":10,"max":10},
		"food":{"val":10,"max":10,"time":60},
		"water":{"val":10,"max":10,"time":60},
		"animal":{"val":10,"max":10,"time":60},
		"plant":{"val":10,"max":10,"time":60}
	}
	Overall.SaveData=0
	Overall.SaveName=0
	Overall.shift=0
	Overall.mode=0
	Overall.cmd=0
	Overall.map={}
	Overall.map_bg={}
	Overall.map_data={}
	Global.map=Overall.map
	Global.map_bg=Overall.map_bg
	Global.map_data=Overall.map_data
	Overall.weather="sunny"
	Overall.status_list={
	"hungry":null,
	"thirst":null,
	"parasite":null,
	"weak":null,
	"malnutrition":null,
	}
	Overall.time={"day":0,"hour":9,"minute":0}
	Overall.hand={}
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		pass