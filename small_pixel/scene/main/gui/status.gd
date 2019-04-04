extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var scene=preload("res://scene/main/gui/status/status.tscn")
onready var status=Config.status
onready var list=Overall.status_list
export var group = "status"
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	set_process_input(true)
	if Overall.Load:
		if "status" in Overall.SetData:
			_on_load(Overall.SaveData.status)
func add_status(name="",time=0):
	if(!time):time=status[name].time
	if(list[name]!=null):
		if(list[name].time<time):
			list[name].time=time
		return
	var tscn=scene.instance()
	list[name]=tscn
	get_node("scroll/v").add_child(tscn)
	tscn.time=time
	tscn.info=status[name].info
	tscn.status=name
	tscn.init()
func remove_status(name):
	if(list[name]!=null):
		if(!list[name].is_queued_for_deletion()):
			list[name]._on_free()
func _on_save():
	var data={}
	for key in list:
		if(list[key]!=null):
			data[key]=list[key].time
	return data
func _on_load(data):
	for key in data:
		call_deferred("add_status",key,data[key])
	 
