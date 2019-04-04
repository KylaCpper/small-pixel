extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var keys=[null,null]
var group
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	pass
func init():
	add_to_group(group)
	for i in range(9):
		get_node("grid0/list/item"+str(i)).set_opacity(0)
		get_node("grid1/list/item"+str(i)).set_opacity(0)
	get_node("grid0/output/item").set_normal_texture(null)
	get_node("grid1/output/item").set_normal_texture(null)
	var i=0
	for data in keys:
		if(!data):
			get_node("grid1").queue_free()
			return
		var datas=data.split(",")
		if(datas.size()==1):
			get_node("grid"+str(i)+"/list/item0").set_normal_texture(Overall.textures[datas[0]])
			get_node("grid"+str(i)+"/list/item0").set_opacity(1)
			get_node("grid"+str(i)+"/list front/front0").connect("input_event",self,"_on_grid_event",[datas[0]])
			get_node("grid"+str(i)+"/list front/front0").connect("mouse_enter",self,"_on_grid_enter",[datas[0]])
			get_node("grid"+str(i)+"/list front/front0").connect("mouse_exit",self,"_on_grid_exit")
		else:
			var status=0
			var num=int(int(datas[0].left(1))-1)
			if(num==-1):
				if(int(datas[1].left(1))-1 ==-1):
					status=2
				else:
					status=1
			var index=0
			
			for data_ in datas:
				var left="0"
				var right=data_
				if(status==0):
					left=str(int(data_.left(1))-1)
					right=data_.right(1)
				elif(status==1):
					if(index!=0):
						left=str(data_.left(1))
						right=data_.right(1)
				else:
					left=str(index)
				index+=1
				get_node("grid"+str(i)+"/list/item"+left).set_normal_texture(Overall.textures[right])
				get_node("grid"+str(i)+"/list/item"+left).set_opacity(1)
				get_node("grid"+str(i)+"/list front/front"+left).connect("input_event",self,"_on_grid_event",[right])
				get_node("grid"+str(i)+"/list front/front"+left).connect("mouse_enter",self,"_on_grid_enter",[right])
				get_node("grid"+str(i)+"/list front/front"+left).connect("mouse_exit",self,"_on_grid_exit")
		#get_node("grid"+str(i)+"/list/item"+str(ii)).set_normal_texture(Overall.textures[])
		get_node("grid"+str(i)+"/output/item").set_normal_texture(Overall.textures[Config.compound_table[data].name])
		get_node("grid"+str(i)+"/output/num").set_text(str(Config.compound_table[data].num))
		
		get_node("grid"+str(i)+"/output/front").connect("input_event",self,"_on_grid_event",[Config.compound_table[data].name])
		get_node("grid"+str(i)+"/output/front").connect("mouse_enter",self,"_on_grid_enter",[Config.compound_table[data].name])
		get_node("grid"+str(i)+"/output/front").connect("mouse_exit",self,"_on_grid_exit")
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