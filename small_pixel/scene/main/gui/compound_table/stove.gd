extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var group
var key=null
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	pass
func init():
	add_to_group(group)
	for i in range(4):
		get_node("grid0/list/item"+str(i)).set_opacity(0)
	for i in range(2):
		get_node("grid0/output/list/item"+str(i)).set_opacity(0)
	var i=0
	var def="def"
	if(group=="high_stove_"):
		def="high_stove"
	if(!def in Config.stove_table[key]):
		queue_free()
		return
	var datas=key.split(",")
	if(datas.size()==1):
		get_node("grid0/list/item0").set_normal_texture(Overall.textures[datas[0]])
		get_node("grid0/list/item0").set_opacity(1)
		get_node("grid0/list front/front0").connect("input_event",self,"_on_grid_event",[datas[0]])
		get_node("grid0/list front/front0").connect("mouse_enter",self,"_on_grid_enter",[datas[0]])
		get_node("grid0/list front/front0").connect("mouse_exit",self,"_on_grid_exit")
	else:
		var index=0
		for data_ in datas:
			var left=str(index)
			var right=data_
			index+=1
			get_node("grid0/list/item"+left).set_normal_texture(Overall.textures[right])
			get_node("grid0/list/item"+left).set_opacity(1)
			get_node("grid0/list front/front"+left).connect("input_event",self,"_on_grid_event",[right])
			get_node("grid0/list front/front"+left).connect("mouse_enter",self,"_on_grid_enter",[right])
			get_node("grid0/list front/front"+left).connect("mouse_exit",self,"_on_grid_exit")
		#get_node("grid"+str(i)+"/list/item"+str(ii)).set_normal_texture(Overall.textures[])
	i =0
	for data in Config.stove_table[key][def]:
		get_node("grid0/output/list/item"+str(i)).set_normal_texture(Overall.textures[data.name])
		get_node("grid0/output/list/item"+str(i)).set_opacity(1)
		get_node("grid0/output/num/num"+str(i)).set_text(str(data.num))
		get_node("grid0/output/list front/front"+str(i)).connect("input_event",self,"_on_grid_event",[data.name])
		get_node("grid0/output/list front/front"+str(i)).connect("mouse_enter",self,"_on_grid_enter",[data.name])
		get_node("grid0/output/list front/front"+str(i)).connect("mouse_exit",self,"_on_grid_exit")
		i+=1

func _on_grid_event(event,name):
	if(event.is_action_pressed("mouse_left")):
		get_tree().call_group(0,"all_compound_book","_to",name)
		pass
	if(event.is_action_pressed("mouse_right")):
		get_tree().call_group(0,"all_compound_book","_from",name)
		pass
	pass
func _on_grid_enter(name):
	OverallGui.item_info({"name":name},0)
	pass
func _on_grid_exit():
	OverallGui.item_info()
	pass