extends "Grid.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var out_item=[{}]
var pull=[]

export var group1="Compound"
func _ready():
	Function.init_item(out_item[0])
	out_item[0].put=[]
	out_item[0].less=0
	add_to_group(group1)
	get_node("output/front").connect("input_event",self,"_on_out_event")
	get_node("output/front").connect("mouse_enter",self,"_on_out_enter")
	get_node("output/front").connect("mouse_exit",self,"_on_out_exit")
	# Called every time the node is added to the scene.
	# Initialization here
	"""
	set_process_input(true)
	set_process(true)
	"""
	"""
	func _process(delta):
		if(click):
			get_node("list bg/bg"+str(index)).set_ignore_mouse(false)
			get_node("list/item"+str(index)).set_ignore_mouse(false)
			get_node("list front/front"+str(index)).set_ignore_mouse(false)
			click=0
	func _input(event):
		if(event.type==InputEvent.MOUSE_BUTTON):
			var mouse_right=event.is_action_pressed("mouse_right")
			var mouse_left=event.is_action_pressed("mouse_left")
			if(mouse_right):
				click=1
				get_node("list bg/bg"+str(index)).set_ignore_mouse(true)
				get_node("list/item"+str(index)).set_ignore_mouse(true)
				get_node("list front/front"+str(index)).set_ignore_mouse(true)
				if(test[index]):
						select_item(index)
			if(mouse_left):
				if(test[index]):
					select_item(index)
	func _on_grid_exit(index):
		test[index]=0
	"""
func _on_out_event(event):
	if(event.is_action_pressed("mouse_left")):
		if(Overall.shift):
			if(out_item[0].name):
				get_tree().call_group(0,"bag","shift_item_compound",out_item[0],self)
		else:
			select_item_left_out(out_item[0])
	if(event.is_action_pressed("mouse_right")):
		select_item_left_out(out_item[0])

func _on_out_enter():
	get_tree().call_group(0,"bar","mouse_item",out_item[0],self)
	OverallGui.item_info(out_item[0])
func _on_out_exit():
	get_tree().call_group(0,"bar","mouse_item",null,self)
	OverallGui.item_info()
func set_compound_val(pro):
	get_node("arrow").set_value(pro)
func compound(item):
	if(item.put.size()>0):
		for i in item.put:
			Function.msg_group("bag","add_item",{"name":i,"num":1,"health":0})
	for i in range(grid):
		if(items[i].name):
			if(!item.less):
				items[i].num-=1
				if(items[i].num==0):
					Function.clear_item(items[i])
			else:
				if(Config.items_type[items[i].name]=="tool"):
					items[i].health-=item.less
					if(items[i].health<=0):
						Function.clear_item(items[i])
				else:
					items[i].num-=1
					if(items[i].num==0):
						Function.clear_item(items[i])
	update()
	if(Overall.shift):
		if(out_item[0].name):
			
			get_tree().call_group(0,"bag","shift_item_compound",out_item[0],self)
	Function.clear_item(item)

func _on_compound(index=0):
	var compound_key=""
	var count=0
	if(index==0):
		for i in range(grid):
			if(items[i].name):
				if(count):
					compound_key+=","+str(i+1)+items[i].name
				else:
					compound_key+=str(i+1)+items[i].name
				count+=1
		if(count==1):
			compound_key=compound_key.right(1)
	elif(index==1):
		var one_grid=0
		for i in range(grid):
			if(items[i].name):
				if(count):
					compound_key+=","+str(i+1-one_grid)+items[i].name
				else:
					one_grid=i+1
					compound_key+=items[i].name
				count+=1
	else:
		for i in range(grid):
			if(items[i].name):
				if(count):
					compound_key+=","+items[i].name
				else:
					compound_key+=items[i].name
				count+=1
			
	if(compound_key in Config.compound_table):
		out_item[0].name=Config.compound_table[compound_key].name
		out_item[0].num=Config.compound_table[compound_key].num
		var put=[]
		var less=0
		if("put" in Config.compound_table[compound_key]):
			put=Config.compound_table[compound_key].put
		if("less" in Config.compound_table[compound_key]):
			less=Config.compound_table[compound_key].less
		out_item[0].put=put
		out_item[0].less=less
		if(Config.items_type[out_item[0].name]=="tool"):
			out_item[0].health=Config.tools[out_item[0].name].health
		else:
			out_item[0].health=0
	else:
		if(count==1):
			Function.clear_item(out_item[0])
			return
		if(index!=2):
			_on_compound(index+1)
		else:
			Function.clear_item(out_item[0])
	
func update_():
	_on_compound()

	#output update
	if(out_item[0].name):
		set_compound_val(100)
		get_node("output/item").set_normal_texture(Overall.textures[out_item[0].name])
		get_node("output/num").set_text(str(out_item[0].num))
		get_node("output/health").set_opacity(0)
	else:
		set_compound_val(0)
		get_node("output/item").set_normal_texture(Overall.textures.bag_bg)
		get_node("output/num").set_text("")
		get_node("output/health").set_opacity(0)
func select_item_left_out(item):
		var item_be={}
		for key in item:
			item_be[key]=item[key]
		if(item==hand):return
		if(OverallGui.item_sprite!=null):
			#包里item是否和手里item一致
			if(hand.name==item.name):
				var success=OverallGui.get_compound_item(item)
				if(success):
					compound(item_be)
				update()
				return
			return
		if(item.name&&item.num):
			Function.give_item(hand,item)
			Function.clear_item(item)
			OverallGui.create_sprite()
			compound(item_be)
			update()
func _hide():
	for i in range(grid):
		if(items[i].name):
			OverallGui.throw_item(items[i],items[i].num)
	update()
