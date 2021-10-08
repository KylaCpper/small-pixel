extends "FunctionGui.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var out_item=[]
var fuel=[{}]
var out_item_be=[]
var burning=0
var fueling=0
var gui_pointer=0
var out_grid=1
var msg_group=""
var stove_table_key="def"
onready var drop_pos=get_pos()
func _enter_tree():
	if(!onec):
		return
	
	var time = Timer.new()
	time.set_name("time")
	add_child(time)
	var lib = SampleLibrary.new()
	var sample=Config.sounds.stove
	sample.set_loop_format(sample.LOOP_FORWARD)
	sample.set_loop_begin(0)
	sample.set_loop_end(100000000)
	lib.add_sample("stove", Config.sounds.stove)
	var sound = SamplePlayer2D.new()
	sound.set_sample_library(lib)
	sound.set_name("sound")
	add_child(sound)
func _ready():
	if(!onec):
		return
	Function.init_item(fuel[0])
	var fuel_time = Timer.new()
	fuel_time.set_name("fuel_time")
	add_child(fuel_time)
	get_node("time").set_one_shot(true)
	get_node("fuel_time").set_one_shot(true)
	get_node("time").connect("timeout",self,"burn_over")
	get_node("fuel_time").connect("timeout",self,"fuel_over")
	
	#get_node("ani").add_animation("open",preload("res://scene/block/ani/wood_box_open.anm"))
	#get_node("ani").add_animation("close",preload("res://scene/block/ani/wood_box_close.anm"))
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func init_():
	for i in range(out_grid):
		var item_be={}
		Function.init_item(item_be)
		out_item.append(item_be)
		item_be=null
	for i in range(5):
		var item_be={}
		Function.init_item(item_be)
		out_item_be.append(item_be)
		out_item_be[i]["min"]=-1
		out_item_be[i]["random"]=100
		item_be=null
#烧制完成
func burn_over():
	burning=0
	if(msg_group=="high_stone_stove"):
		if(randi() % 101<20):
			for data in out_item_be:
				Function.clear_item(data)
			return
	if((out_item[0].name==out_item_be[0].name)||(out_item[0].name==null)):
		for i in range(out_grid):
			if(out_item_be[i].name):
				var _max=Config.items_max[Config.items_type[out_item_be[i].name]]
				if((out_item[i].name==out_item_be[i].name)||(out_item[i].name==null)):
					if(out_item[i].num+out_item_be[i].num<=_max):
						if((randi() % 101)<out_item_be[i].random):
							if(out_item_be[i]["min"]!=-1):
								out_item_be[i].num=randi() % (out_item_be[i].num+1)+out_item_be[i]["min"]
							out_item[i].name=out_item_be[i].name
							out_item[i].num+=out_item_be[i].num
						Function.clear_item(out_item_be[i])
		for data in out_item_be:
			if(data.name):
				if((randi() % 101)< 50):
					if((randi() % 101)<data.random):
						if(data["min"]!=-1):
							data.num=randi() % (data.num+1)+data["min"]
					get_tree().call_group(0,"plane","drop_item",{"name":data.name,"num":data.num,"health":data.health},drop_pos)
				Function.clear_item(data)
	if(gui_pointer):
		get_tree().call_group(0,msg_group,"burn_over")
	update()
#开始烧制
func burn_start(time,jmp=0):
	if(!fueling):return
	if(burning):return
	burning=1
	if(!jmp):
		for i in range(grid):
			if(items[i].name):
				items[i].num-=1
				if(items[i].num==0):
					Function.clear_item(items[i])
	get_node("time").set_wait_time(time)
	get_node("time").start()
	if(gui_pointer):
		get_tree().call_group(0,msg_group,"burn_start",time)
	#get_node("ani_arrow").play("arrow",-1,1/float(time))
	update()
func stove_combustion(start):
	if(start):
		get_node("sprite").set_texture(Overall.textures.stone_stove_combustion)
	else:
		get_node("sprite").set_texture(Overall.textures.stone_stove)
#开始燃烧
func fuel_start(time):
	fueling=1
	get_node("sound").play("stove")
	stove_combustion(1)
	get_node("fuel_time").set_wait_time(time)
	get_node("fuel_time").start()
	if(gui_pointer):
		get_tree().call_group(0,msg_group,"fuel_start",time)
	update()
#燃烧结束
func fuel_over():
	fueling=0
	if(check_burn()):
		if(!check_fuel()):
			get_node("sound").stop_all()
			stove_combustion(0)
			burn_break()
			if(gui_pointer):
				get_tree().call_group(0,msg_group,"fuel_over")
		else:
			
			fueling=1
	else:
		get_node("sound").stop_all()
		stove_combustion(0)
		if(gui_pointer):
			get_tree().call_group(0,msg_group,"fuel_over")
	update()
func check_out_item():
	if((out_item[0].name==out_item_be[0].name)||(out_item[0].name==null)):
		if(out_item_be[0].name):
			var _max=Config.items_max[Config.items_type[out_item_be[0].name]]
			if(out_item[0].num+out_item_be[0].num<=_max):
				pass
			else:
				burn_break()
		else:
			burn_break()
	else:
		burn_break()
func burn_break():
	burning=0
	get_node("time").stop()
	if(gui_pointer):
		get_tree().call_group(0,msg_group,"burn_break")
func update():
	var stove_key=""
	var count=0
	for i in range(grid):
		if(items[i].name):
			if(count):
				stove_key+=","+items[i].name
			else:
				stove_key+=items[i].name
			count+=1

	#炉子物品是否可烧制
	if(!burning||!fueling):
		if(out_item_be[0].name==null):
			if(stove_key in Config.stove_table):
				var _stove_table_key=stove_table_key
				if(!(stove_table_key in Config.stove_table[stove_key])):
					
					return
					#_stove_table_key="def"
				#输出口是否堵塞
				if((Config.stove_table[stove_key][_stove_table_key][0].name==out_item[0].name)||(out_item[0].name==null)):
					var _name=Config.stove_table[stove_key][_stove_table_key][0].name
					var _num=Config.stove_table[stove_key][_stove_table_key][0].num
					#输出口是否会大于max
					if(out_item[0].num+_num<=Config.items_max[Config.items_type[_name]]):
						check_fuel()
						if(!fueling):return
						out_item_be[0].time=Config.stove_table[stove_key].time
						var data = Config.stove_table[stove_key][_stove_table_key]
						for i in range(data.size()):
							if(i < Config.stove_table[stove_key][_stove_table_key].size()):
								out_item_be[i].name=data[i].name
								out_item_be[i].num=data[i].num
								if("random" in data[i]):
									out_item_be[i].random=data[i].random
								else:
									out_item_be[i].random=100
								if("min" in data[i]):
									out_item_be[i]["min"]=data[i]["min"]
								else:
									out_item_be[i]["min"]=-1
						#out_item_be[0].random=
						burn_start(Config.stove_table[stove_key].time)
		else:
			if((out_item_be[0].name==out_item[0].name)||(out_item[0].name==null)):
				var _name=out_item_be[0].name
				var _num=out_item_be[0].num
				if(out_item[0].num+out_item_be[0].num<=Config.items_max[Config.items_type[_name]]):
					check_fuel()
					if(!fueling):return
					burn_start(out_item_be[0].time,1)
func check_burn():
	#炉子物品是否可烧制
	var stove_key=""
	var count=0
	for i in range(grid):
		if(items[i].name):
			if(count):
				stove_key+=","+items[i].name
			else:
				stove_key+=items[i].name
			count+=1

		if(out_item_be[0].name==null):
			if(stove_key in Config.stove_table):
				var _stove_table_key=stove_table_key
				if(!(stove_table_key in Config.stove_table[stove_key])):
					return 0
					#_stove_table_key="def"
				#输出口是否堵塞
				if((Config.stove_table[stove_key][_stove_table_key][0].name==out_item[0].name)||(out_item[0].name==null)):
					var _name=Config.stove_table[stove_key][_stove_table_key][0].name
					var _num=Config.stove_table[stove_key][_stove_table_key][0].num
					#输出口是否会大于max
					if(out_item[0].num+_num<=Config.items_max[Config.items_type[_name]]):
						return 1
			return 0
		else:
			if(out_item_be[0].name==out_item[0].name||out_item[0].name==null):
				var _name=out_item_be[0].name
				var _num=out_item_be[0].num
				if(out_item[0].num+_num<=Config.items_max[Config.items_type[_name]]):
					return 1
			return 0
func check_fuel():
	#炉子燃料是否可燃烧
	if(fuel[0].name&&(!fueling)&&fuel[0].num>0):
		if(fuel[0].name in Config.fuels):
			fuel[0].num-=1
			fuel_start(Config.fuels[fuel[0].name].time)
			if(fuel[0].num==0):
				Function.clear_item(fuel[0])
			return 1
	return 0
func get_time():
	var time={"total":get_node("time").get_wait_time(),"current":get_node("time").get_time_left()}
	var fuel_time={"total":get_node("fuel_time").get_wait_time(),"current":get_node("fuel_time").get_time_left()}
	if(!burning):
		time=null
	if(!fueling):
		fuel_time=null
	return {"time":time,"fuel_time":fuel_time}
func _on_gui_end():
	pass
func stove_key_sort(stove_key):
	return stove_key
func _on_mouse_right():
	get_tree().call_group(0,msg_group,"display",1,["items","out_item","fuel","out_item_be"],self)
func __free():
	for i in range(out_grid):
		if(out_item[i].name):
			var out_item_be={}
			Function.give_item(out_item_be,out_item[i])
			get_tree().call_group(0,"plane","drop_item",out_item_be,get_pos())
	if(fuel[0].name):
		var fuel_be={}
		Function.give_item(fuel_be,fuel[0])
		get_tree().call_group(0,"plane","drop_item",fuel_be,get_pos())
		
	pass
func _on_save():
	return {"items":items,"out_items":out_item,"fuel":fuel}
func _on_load(data):
	items=data.items
	out_item=data.out_items
	fuel=data.fuel
	call_deferred("update")