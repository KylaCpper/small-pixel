extends "../Grid.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group1="bar"
export var distance=74

func _ready():
	grid=9
	add_to_group(group1)
	init()
	items[0].name="torch"
	items[0].num=10
	items[1].name="apple"
	items[1].num=10
	items[2].name="clam"
	items[2].num=2
	items[3].name="wood_pickaxe"
	items[3].num=1
	items[6].health=10
	items[4].name="all_compound_book"
	items[4].num=1
#	items[5].name="wood"
#	items[5].num=99
#	items[6].name="iron_pickaxe"
#	items[6].num=1
#	items[6].health=500
#	items[7].name="transmission_wood_stick"
#	items[7].num=99
#	items[8].name="apple"
#	items[8].num=99
	if(Overall.Load):
		items=Overall.SaveData.bar
	update()
	select_item(0)
	set_process_input(true)
	show_ani()
func pull_item(name):
	if(name in Config.items_type):
		items[index].name=name
		items[index].num=Config.items_max[Config.items_type[name]]
		if(Config.items_type[name]=="tool"):
			items[index].health=Config.tools[name].health
		update()
		Function.msg_group("cmd","add_msg","get "+name)
	else:
		Function.msg_group("cmd","add_msg","not find item "+name,2)
func full(item):
	get_tree().call_group(0,"bag","add_item",item)
var two=true
func _input(event):
	if(!OverallGui.show):
		if(event.type==InputEvent.MOUSE_BUTTON):
			two=!two
			if(!two):return
			if(event.button_index==BUTTON_WHEEL_UP):
				show_ani()
				var index_be=index-1
				if(index_be<0):index_be=8
				select_item(index_be)
			if(event.button_index==BUTTON_WHEEL_DOWN):
				show_ani()
				var index_be=index+1
				if(index_be>8):index_be=0
				select_item(index_be)
	if(Overall.cmd):return
	if(event.type==InputEvent.KEY):
		for i in range(grid):
			if(event.unicode==i+49):
				if(!OverallGui.show):
					select_item(i)
					show_ani()
				else:
					show_bar()
					if(mouse_item!=null):
						#输出口
						if(out_obj!=null):
							if(mouse_item.name):
								if(is_space(mouse_item,i)):
									add_item_designation(mouse_item,i)
									out_obj.compound({"put":mouse_item.put,"less":mouse_item.less})
									update()
						else:
							OverallGui.switch_item_bar(mouse_item,items[i])
func _on_grid_enter(index):
	get_tree().call_group(0,"bar","mouse_item",items[index])
	OverallGui.item_info(items[index])
func _on_grid_event(event,index):
	#get_node("list bg/bg"+str(index)).
	var mouse_left=event.is_action_pressed("mouse_left")
	var mouse_right=event.is_action_pressed("mouse_right")
	if(OverallGui.show):
		if(mouse_left):
			select_item_left(items[index])
		if(mouse_right):
			select_item_right(items[index])
	else:
		if(mouse_left):
			select_item(index)
	pass
func show_ani():
	get_node("ani").play("bar")
func show_bar():
	get_node("ani").stop()
	set_opacity(1)

func select_item(index):
		self.index=index
		get_node("current").set_pos(Vector2(distance*index,0))
		Overall.hand=items[index]
		get_tree().call_group(0,"player","_on_bar_current",items[index])
var mouse_item=null
var out_obj=null
func mouse_item(item=null,out_obj=null):
	self.out_obj=out_obj
	mouse_item=item
func update_():
	select_item(index)
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