extends "../Grid.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group1="bag"
func _ready():
	grid=16
	add_to_group(group1)
	set_process_input(true)
	init()
	if(Overall.Load):
		items=Overall.SaveData.bag
	
	update()
var gui_obj=null
func give_gui(obj):
	gui_obj=obj
func shift_item(index):
	if(gui_obj!=null):
		if(items[index].name):
			gui_obj.add_item_pointer(items[index])
func _input(event):
	if(Overall.cmd):
		return
	if(event.is_action_pressed("bag")):
		display()
	if(event.is_action_pressed("esc")):
		if(OverallGui.show):
			display()
		else:
			Function.msg_group("esc","display")

func display(obj=get_node("../handmade"),hide=0):
	if(OverallGui.show):
		if(!hide):
			_on_hide()
		if(gui_obj!=null):
			gui_obj._on_hide()
			gui_obj==null
		Function.msg_group("bar","show_ani")
		OverallGui.throw_hand_item()
		
	else:
		if(!hide):
			_on_show()
		give_gui(obj)
		obj._on_show()
		Function.msg_group("bar","show_bar")
		
		"""
		var packed_scene = PackedScene.new()
		packed_scene.pack(get_tree().get_current_scene())
		ResourceSaver.save("res://my_scene.tscn", packed_scene)
		"""
	
	OverallGui.show=!OverallGui.show
	get_tree().call_group(0,"player","_on_gui",OverallGui.show)
	

func shift_item_compound(item,obj):
	if(is_add_space(item)):
		add_item(item)
		obj.compound({"put":item.put,"less":item.less})
func full(item):
	Function.msg_group("plane","throw_item",item)
	
func drop_all(pos):
	if(!grid):return
	for i in range(grid):
		if(items[i].name):
			var item_be={}
			Function.give_item(item_be,items[i])
			get_tree().call_group(0,"plane","drop_item",item_be,pos)
			Function.clear_item(items[i])
	update()
	pass
