extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var icon
export var line=4
export var width=100
export var height=100
var save_names={"0":0}
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("close").connect("pressed",self,"_on_close_press")
	get_node("sure").connect("pressed",self,"_on_sure_press")
	get_node("delete_window/close").connect("pressed",self,"_on_delete_close_press")
	get_node("delete_window/sure").connect("pressed",self,"_on_delete_sure_press")
	get_node("delete").connect("pressed",self,"_on_delete_press")
	pass
func _on_load():
	var list=get_node("list")
	list.connect("item_selected",self,"_on_select")
	icon = load("res://icon.png")
	list.set_max_text_lines(line)
	list.set_fixed_icon_size(Vector2(width,height))
	var files_=Function.get_dir("user://")
	var files=files_.files
	var index=0
	for i in files:
		if(i=="set.save"):continue
		var data=Function.GetSaveDataRow(i,"kyla")
		if(data==0):
			list.add_item("null",icon)
			save_names[index]=0
		else:
			save_names[index]=i
			list.add_item("time:"+str(data.day)+"day,"+str(data.hour)+"hour",icon)
		index+=1
func _on_close_press():
	get_tree().call_group(0,"home","close_other_window","load")
	pass
var id="0"
func _on_select(index):
	id=index
func _on_sure_press():
	if(!save_names[id]):return
	var data=Function.GetSaveData(save_names[id],"kyla")
	if(data!=0):
		Overall.Load=1
		Overall.SaveData=data
		Overall.player=Overall.SaveData.player
		Overall.SaveName=save_names[id]
		Overall.time=data.time
		Global.GoTo_Scene("res://scene/start/start0/start0.tscn","res://scene/main/main.tscn")

func _on_delete_press():
	if(save_names[id]):
		get_node("delete_window").show()
func _on_delete_close_press():
	get_node("delete_window").hide()
func _on_delete_sure_press():
	if(save_names[id]):
		var dir = Directory.new()
		dir.remove("user://"+save_names[id])
		get_node("list").remove_item(int(id))
		save_names[id]=0
		for i in save_names:
			if(typeof(i)==TYPE_INT):
				if(!save_names[i]):
					if i+1 in save_names:
						save_names[i]=save_names[i+1]
						save_names[i+1]=0
	id="0"
	get_node("delete_window").hide()