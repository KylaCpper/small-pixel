extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var items=[]
export var grid=16
export var group="gui"
var index=0
var that
var show=0
func init():
	for i in range(grid):
		var item_be={}
		Function.init_item(item_be)
		items.append(item_be)
		item_be=null
	for i in range(grid):
		get_node("list/item"+str(i)).set_normal_texture(null)
		get_node("list front/front"+str(i)).connect("input_event",self,"_on_grid_event",[i])
		get_node("list front/front"+str(i)).connect("mouse_enter",self,"_on_grid_enter",[i])
		get_node("list front/front"+str(i)).connect("mouse_exit",self,"_on_grid_exit")
		pass
	init_()
	# Called every time the node is added to the scene.
	# Initialization here
	update()
func init_():
	pass
var hand={}
func _ready():
	hand=OverallGui.hand
	add_to_group(group)
	set_opacity(float(Overall.SetData.gui.op)/100)
func shift_item(index):
	if(items[index].name):
		get_tree().call_group(0,"bag","add_item_pointer",items[index])
func _on_grid_event(event,index):
	#get_node("list bg/bg"+str(index)).
	if(event.is_action_pressed("mouse_left")):
		if(Overall.shift):
			shift_item(index)
			update()
		else:
			select_item_left(items[index])
		_on_grid_press()
	if(event.is_action_pressed("mouse_right")):
		select_item_right(items[index])
		_on_grid_press()
		#if(bag[index].name):
		#	self.index=index
	pass
func _on_grid_exit():
	get_tree().call_group(0,"bar","mouse_item",null)
	OverallGui.item_info()
func _on_grid_enter(index):
	get_tree().call_group(0,"bar","mouse_item",items[index])
	OverallGui.item_info(items[index])
	#get_node("list bg/bg"+str(index)).
	if(Input.is_action_pressed("mouse_left")):
		select_item_left(items[index])
	if(Input.is_action_pressed("mouse_right")):
		if(OverallGui.item_sprite!=null):
			select_item_right(items[index])
		#if(bag[index].name):
		#	self.index=index
	pass
func add_item(item):
	var item_max=Config.items_max[Config.items_type[item.name]]
	for i in range(grid):
		if(!items[i].name):
			Function.give_item(items[i],item)
			update()
			return
		if(items[i].name==item.name):
			
			if((items[i].num+item.num)<=item_max):
				items[i].num+=item.num
				update()
				return
				var num_dif=item_max-items[i].num
				items[i].num+=num_dif
				item.num-=num_dif
				#print(num)
	if(item.num):
		full(item)
	update()
func add_item_pointer(item):
	var item_max=Config.items_max[Config.items_type[item.name]]
	for i in range(grid):
		if(!items[i].name):
			Function.give_item(items[i],item)
			Function.clear_item(item)
			get_tree().call_group(0,"gui","update")
			return
		if(items[i].name==item.name):
			if((items[i].num+item.num)<=item_max):
				items[i].num+=item.num
				Function.clear_item(item)
				get_tree().call_group(0,"gui","update")
				return
			else:
				var num_dif=item_max-items[i].num
				items[i].num+=num_dif
				item.num-=num_dif
				#print(num)
	if(item.num):
		full(item)
	get_tree().call_group(0,"gui","update")
func full(item):
	get_tree().call_group(0,"bag","add_item",item)
	pass
func is_add_space(item):
	var num_be=item.num
	var item_max=Config.items_max[Config.items_type[item.name]]
	for i in range(grid):
		if(!items[i].name):
			return 1
		if(items[i].name==item.name):
			if(items[i].num+num_be<=item_max):
				return 1
			else:
				var num_dif=item_max-items[i].num
				num_be-=num_dif
	if(!num_be):
		return 1
func is_space(item,i):
	var num_be=item.num
	var item_max=Config.items_max[Config.items_type[item.name]]
	if(!items[i].name):
		return 1
	if(items[i].name==item.name):
		if(items[i].num+item.num<=item_max):
			return 1
	return 0
func add_item_designation(item,i):
	var item_max=Config.items_max[Config.items_type[item.name]]
	if(!items[i].name):
		Function.give_item(items[i],item)
		Function.clear_item(item)
	elif(items[i].name==item.name):
		if(items[i].num+item.num<=item_max):
			items[i].num+=item.num
			Function.clear_item(item)
func update():
	for i in range(grid):
		if(items[i].name&&items[i].num>0):
			get_node("list/item"+str(i)).set_normal_texture(Overall.textures[items[i].name])
			get_node("num/num"+str(i)).set_text(str(items[i].num))
			if(Config.items_type[items[i].name]=="tool"):
				var bar_max=Config.tools[items[i].name].health
				if((items[i].health==bar_max)||(items[i].health==0)):
					get_node("health/health"+str(i)).set_opacity(0)
				else:
					get_node("health/health"+str(i)).set_opacity(1)
					get_node("health/health"+str(i)).set_max(bar_max)
					get_node("health/health"+str(i)).set_value(items[i].health)
			else:
				get_node("health/health"+str(i)).set_opacity(0)
		else:
			get_node("list/item"+str(i)).set_normal_texture(Overall.textures.bag_bg)
			get_node("num/num"+str(i)).set_text("")
			Function.clear_item(items[i])
			get_node("health/health"+str(i)).set_opacity(0)
			
	update_()
func update_():
	pass
func _on_grid_press():
	pass
func select_item_right(item):
		if(OverallGui.item_sprite!=null):
			#包里item是否和手里item一致
			if((hand.name==item.name)):
				OverallGui.give_item(item,1)
				update()
				return
			if(!item.name):
				OverallGui.give_item(item,1)
				update()
				return
			return
		if(item.name&&item.num):
			for key in item:
				hand[key]=item[key]
				if(key=="num"):
					var half=int(item[key])/2
					#只剩一个时
					if(half==0):
						Function.give_item(hand,item)
						Function.clear_item(item)
						break
					#11/2==5
					if(int(item[key])-half*2):
						item[key]=half
						hand[key]=half+1
					#整除
					else:
						item[key]=half
						hand[key]=half
			OverallGui.create_sprite()
			update()
func select_item_left(item):
		if(item==hand):return
		if(OverallGui.item_sprite!=null):
			#包里item是否和手里item一致
			if(hand.name==item.name):
				OverallGui.give_item(item)
				update()
				return
			OverallGui.item_info(hand)
			OverallGui.switch_item(item)
			update()
			return
		if(item.name&&item.num):
			Function.give_item(hand,item)
			Function.clear_item(item)
			OverallGui.create_sprite()
			update()
func display(show=0,keys=[],obj=self):
	if(show&&!OverallGui.show):
		for data in keys:
			self[data]=obj[data]
		that=obj
		get_tree().call_group(0,"bag","display",self)
		update()
	if(!show):
		OverallGui.throw_hand_item()
func _on_hide():
	show=0
	_hide()
	hide()
	get_node("area").set_layer_mask_bit(10,0)
	get_node("head").set_layer_mask_bit(10,0)
	OverallGui.item_info()
func _on_show():
	show=1
	_show()
	show()
	get_node("area").set_layer_mask_bit(10,1)
	get_node("head").set_layer_mask_bit(10,1)
func _hide():
	pass
func _show():
	pass