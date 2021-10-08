extends "Grid.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var out_item=[]
var out_item_be=[]
var fuel=[{}]
export var group1="stove"
var burning=0
var fueling=0
var out_grid=0
func _ready():
	Function.init_item(fuel[0])
	add_to_group(group1)
	get_node("fuel/front").connect("input_event",self,"_on_fuel_event")
	get_node("fuel/front").connect("mouse_enter",self,"_on_fuel_enter")
	get_node("fuel/front").connect("mouse_exit",self,"_on_out_exit")
	get_node("arrow").set_value(0)
	get_node("arrow_fuel").set_value(0)
func init_():
	for i in range(out_grid):
		var item_be={}
		Function.init_item(item_be)
		out_item.append(item_be)
		item_be=null
		item_be={}
		Function.init_item(item_be)
		out_item_be.append(item_be)
		item_be=null
		
	for i in range(out_grid):
		get_node("output/list/item"+str(i)).set_normal_texture(null)
		get_node("output/list front/front"+str(i)).connect("input_event",self,"_on_out_event",[i])
		get_node("output/list front/front"+str(i)).connect("mouse_enter",self,"_on_out_enter",[i])
		get_node("output/list front/front"+str(i)).connect("mouse_exit",self,"_on_out_exit")
		pass
func _on_out_event(event,i):
	if(event.is_action_pressed("mouse_left")):
		if(Overall.shift):
			shift_item(index)
			update()
		else:
			if(OverallGui.item_sprite==null):
				select_item_left(out_item[i])
	if(event.is_action_pressed("mouse_right")):
		if(OverallGui.item_sprite==null):
			select_item_right(out_item[i])
	check_out_item()

func _on_out_enter(i):
	get_tree().call_group(0,"bar","mouse_item",out_item[i])
	OverallGui.item_info(out_item[i])
	#get_node("list bg/bg"+str(index)).
	if(Input.is_action_pressed("mouse_left")):
		if(OverallGui.item_sprite==null):
			select_item_left(out_item[i])
	if(Input.is_action_pressed("mouse_right")):
		if(OverallGui.item_sprite==null):
			select_item_right(out_item[i])
	check_out_item()
func _on_fuel_event(event):
	if(event.is_action_pressed("mouse_left")):
		if(Overall.shift):
			shift_item(index)
			update()
		else:
			select_item_left(fuel[0])
	if(event.is_action_pressed("mouse_right")):
		select_item_right(fuel[0])
	check_out_item()
func _on_fuel_enter():
	get_tree().call_group(0,"bar","mouse_item",fuel[0])
	OverallGui.item_info(fuel[0])
	#get_node("list bg/bg"+str(index)).
	if(Input.is_action_pressed("mouse_left")):
		select_item_left(fuel[0])
	if(Input.is_action_pressed("mouse_right")):
		if(OverallGui.item_sprite!=null):
			select_item_right(fuel[0])
	check_out_item()
func check_out_item():
	that.check_out_item()
	that.update()
func burn_break():
	get_node("ani_arrow").stop()
	arrow_over()
func _on_out_exit():
	get_tree().call_group(0,"bar","mouse_item",null)
	OverallGui.item_info()
	
	
	
	
func arrow_over():
	get_node("arrow").set_value(0)

#开始烧制
func burn_start(time):
	if(!that.fueling):return
	get_node("ani_arrow").play("arrow",-1,1/float(time))
	update()
#烧制完成
func burn_over():
	arrow_over()
	update()
func arrow_fuel_over():
	get_node("arrow_fuel").set_value(0)

#开始燃烧
func fuel_start(time):
	get_node("ani_arrow_fuel").play("arrow_fuel",-1,1/float(time))
	update()
func update_():
	#update 输出栏 燃料栏
	for i in range(out_grid):
		if(out_item[i].name):
			get_node("output/list/item"+str(i)).set_normal_texture(Overall.textures[out_item[i].name])
			get_node("output/num/num"+str(i)).set_text(str(out_item[i].num))
			get_node("output/health/health"+str(i)).set_opacity(0)
		else:
			get_node("output/list/item"+str(i)).set_normal_texture(Overall.textures.bag_bg)
			get_node("output/num/num"+str(i)).set_text("")
			get_node("output/health/health"+str(i)).set_opacity(0)
	if(fuel[0].name):
		get_node("fuel/item").set_normal_texture(Overall.textures[fuel[0].name])
		get_node("fuel/num").set_text(str(fuel[0].num))
		get_node("fuel/health").set_opacity(0)
	else:
		get_node("fuel/item").set_normal_texture(Overall.textures.bag_bg)
		get_node("fuel/num").set_text("")
		get_node("fuel/health").set_opacity(0)
func _on_grid_press():
	that.update()
func _show():
	that.gui_pointer=1
	var time=that.get_time()
	if(time.time!=null):
		get_node("ani_arrow").play("arrow",-1,1/float(time.time.total))
		get_node("ani_arrow").seek(1-(1/time.time.total)*time.time.current)
	if(time.fuel_time!=null):
		get_node("ani_arrow_fuel").play("arrow_fuel",-1,1/float(time.fuel_time.total))
		get_node("ani_arrow_fuel").seek(1-(1/time.fuel_time.total)*time.fuel_time.current)
func _hide():
	that.gui_pointer=0
	burn_break()
	#fuel_break
	get_node("fuel_time").stop()
	get_node("ani_arrow_fuel").stop()
	arrow_fuel_over()