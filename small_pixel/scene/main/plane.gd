extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
#var tiles
export var group="plane"
var script=Overall.script
var place_scene=preload("res://scene/block/block.tscn")
var place_scene_bg=preload("res://scene/block/block_bg.tscn")
var place_liquid=preload("res://scene/block/liquid.tscn")
var drop_item_scene=preload("res://scene/drop_item/drop_item.tscn")
var select_scene=preload("res://scene/block/select.tscn")
#var mutex=Mutex.new()
var noise
var place_flow_scene=[
	preload("res://scene/block/liquid/liquid_0.tscn"),
	preload("res://scene/block/liquid/liquid_1.tscn"),
	preload("res://scene/block/liquid/liquid_2.tscn"),
	preload("res://scene/block/liquid/liquid_3.tscn"),
	preload("res://scene/block/liquid/liquid_4.tscn")
]
var pig=preload("res://scene/anm/ani.tscn")
var str_res="res://scene/block/"
var flow_vec=[
	[Vector2(16, -16),Vector2(16, 16),Vector2(-16, 16),Vector2(-16, -8)],
	[Vector2(16, -8),Vector2(16, 16),Vector2(-16, 16),Vector2(-16, 0)],
	[Vector2(16, 0),Vector2(16, 16),Vector2(-16, 16),Vector2(-16, 8)],
	[Vector2(16, 8),Vector2(16, 16),Vector2(-16, 16),Vector2(-16, 15)],
	
	[Vector2(16, -8),Vector2(16, 16),Vector2(-16, 16),Vector2(-16, -16)],
	[Vector2(16, 0),Vector2(16, 16),Vector2(-16, 16),Vector2(-16, -8)],
	[Vector2(16, 8),Vector2(16, 16),Vector2(-16, 16),Vector2(-16, 0)],
	[Vector2(16, 15),Vector2(16, 16),Vector2(-16, 16),Vector2(-16, 8)]
]
var plane_num=0
var block_num=0
var plane_scene=preload("res://scene/block/plane.tscn")
var chunks_scene={}
func _enter_tree():
	var plane=plane_scene.instance()
	plane.set_name("plane0")
	add_child(plane)
	for x in range(11):
		chunks_scene[x]={}
		for y in range(10):
			plane=plane_scene.instance()
			chunks_scene[x][y]=plane
			plane.set_name("chunk"+str(x)+str(y))
	pass
	
func _ready():
	add_to_group(group)
	for key in Config.scripts:
		script[key]=load("res://scene/block/block_script/"+Config.scripts[key]+".gd")
	for x in range(11):
		chunks[x]={}
		chunks_init[x]={}
		for y in range(10):
			chunks[x][y]=0
			chunks_init[x][y]={}
			
	if(Overall.Load):
#		var big_devices=[]
#		for block in Overall.SaveData.plane:
#			var pos=Vector2(block.pos.x,block.pos.y)
#			block.pos=pos
#			var obj=null
#			if(!block.big_device):
#				if(block.bg):
#					if(Config.items_type[block.name]=="gear"):
#						obj=place_gear(block.name,pos,block.bg)
#					else:
#						obj=place(block.name,pos,block.bg)
#				else:
#					if(Config.items_type[block.name]=="liquid"):
#						obj=place_liquid(block.name,pos)
#					elif(Config.items_type[block.name]=="gear"):
#						obj=place_gear(block.name,pos,block.bg)
#					else:
#						obj=place(block.name,pos,block.bg)
#				if(obj!=null):
#					obj.call_deferred("_on_load",block)
#			else:
#				big_devices.append(block)
#		for big_device in big_devices:
#			var obj=null
#			if(Config.items_type[big_device.name]=="liquid"):
#				obj=place_liquid(big_device.name,big_device.pos)
#			elif(Config.items_type[big_device.name]=="gear"):
#				obj=place_gear(big_device.name,big_device.pos,big_device.bg)
#			else:
#				obj=place(big_device.name,big_device.pos,big_device.bg)
#			if(obj!=null):
#					obj.call_deferred("_on_load",big_device)
		var player_pos=Overall.SaveData.player_info.pos
		var x=int((player_pos.x/32+100)/32)
		var y=int((player_pos.y/32+140)/32)
		c_chunk=[x,y]
		p_chunk=[x,y]
		init_map()
	else:
		c_chunk=[3,4]
		p_chunk=[3,4]
		init_map()
	player=get_node("../player")
	get_node("time").connect("timeout",self,"check_chunk")
	get_node("time").set_wait_time(1)
	get_node("time").start()
	# Called every time the node is added to the scene.
	# Initialization here
	var tscn=select_scene.instance()
	tscn.set_pos(Vector2(0,0))
	var node=add_child(tscn)
	Overall.select=tscn

func create_pig(pos):
	var tscn=pig.instance()
	tscn.set_pos(pos)
	_add_child(tscn)
func replace(obj,name,mode=1,bg=0):
	var pos=obj.get_pos()
	if(mode==1):
		obj._on_free(0)
	elif(mode==0):
		obj.free()
	elif(mode==2):
		obj.queue_free()
	if(!bg):
		if(Config.items_type[name]=="liquid"):
			place_liquid(name,pos)
		elif(Config.items_type[name]=="gear"):
			place_gear(name,pos)
		else:
			place(name,pos)
	else:
		if(Config.items_type[name]=="gear"):
			place_gear(name,pos,bg)
			
		else:
			place(name,pos,bg)
func place_flow(index,name,pos,dire="left"):
	var x=int((pos.x/32+100)/32)
	var y=int((pos.y/32+140)/32)
	if x<0:x=0
	if x>10:x=10
	if y<0:y=0
	if y>9:y=9
	if chunks[x][y]==0:return
	if !has_node(chunks_scene[x][y].get_name()):return
	var tscn
	if(dire=="down"):
		tscn=place_flow_scene[4].instance()
	else:
		tscn=place_flow_scene[index].instance()
	var offset=0
	if(dire=="right"):
		offset=4
	tscn.get_node("sprite").set_texture(Overall.textures[name])
	if(dire!="down"):
		if(index+offset>7):
			tscn.queue_free()
			return
		tscn.get_node("sprite").set_polygon(flow_vec[index+offset])
	tscn.name=name
	tscn.flow=index
	tscn.speed=Config.liquids[name].speed
	tscn.direction=dire
	tscn.init()
	tscn.set_pos(pos)
	_add_child(tscn)
	return tscn
func place_gear(name,pos,bg=0):
	var tscn
	if(bg):
		tscn=place_scene_bg.instance()
		tscn.get_node("sprite").set_modulate(Color(0.8,0.8,0.8))
	else:
		tscn=place_scene.instance()
	tscn.set_script(script[Config.blocks[name].script])
	tscn.get_node("sprite").set_texture(Overall.textures[name])
	if(bg):tscn._ray_="ray_bg"
	tscn.name=name
	tscn.set_pos(pos)
	_add_child(tscn)
	tscn.init()
	return tscn
func place_liquid(name,pos,bg=0):
	var tscn=place_liquid.instance()
	tscn.get_node("sprite").set_texture(Overall.textures[name])
	tscn.set_script(script[Config.liquids[name].script])
	tscn.name=name
	tscn.speed=Config.liquids[name].speed
	tscn.init()
	tscn.set_pos(pos)
	_add_child(tscn)
	return tscn

func place(name,pos,bg=0):
	var tscn
	if(bg):
		tscn=place_scene_bg.instance()
		tscn.set_script(script["block_bg"])
	else:
		tscn=place_scene.instance()
		tscn.set_script(script[Config.blocks[name].script])
	tscn.get_node("sprite").set_texture(Overall.textures[name])
	tscn.name=name
	tscn.set_pos(pos)
	_add_child(tscn)
	
	if(!bg):
		tscn.init()
	return tscn
	#tscn.set_owner(self)
func drop_item(item,pos,vec=Vector2(0,0)):
	var tscn=drop_item_scene.instance()
	tscn.get_node("sprite").set_texture(Overall.textures[item.name])
	Function.give_item(tscn,item)
	Function.clear_item(item)
	tscn.set_pos(pos)
	tscn.set_linear_velocity(vec)
	get_node("drop").add_child(tscn)
	#tscn.set_owner(self)
func damage(obj,tool_ture,tool_type):
	obj._on_free(1,tool_ture,tool_type)
func throw_item(item,num=1):
	var vec
	var offset
	var player=get_node("../player")
	
	if(player.direction=="left"):
		vec=Vector2(-200,0)
		offset=Vector2(-15,0)
	else:
		vec=Vector2(200,0)
		offset=Vector2(15,0)
	drop_item(item,player.get_pos()+offset,vec)
var player_direction="left"
var player
var player_pos=Vector2(0,0)
func _on_direction(direction,pos):
	player_direction=direction
	player_pos=pos
func _add_child(tscn,add=0):
	var pos=tscn.get_pos()
	var x=int((pos.x/32+100)/32)
	var y=int((pos.y/32+140)/32)
#	if has_node("chunk"+str(x)+str(y)):
#		get_node("chunk"+str(x)+str(y)).add_child(tscn)
#	else:
	if x<0:x=0
	if x>10:x=10
	if y<0:y=0
	if y>9:y=9
	
	if !tscn.bg:
		Overall.map[int(pos.x/32)][int(pos.y/32)]=tscn
	else:
		Overall.map_bg[int(pos.x/32)][int(pos.y/32)]=tscn
	chunks_scene[x][y].add_child(tscn)
	
	"""
	if(block_num<1000):
		get_node("plane"+str(plane_num)).add_child(tscn)
		tscn.set_owner(self)
		block_num+=1
	else:
		var plane=plane_scene.instance()
		plane.set_name("plane"+str(plane_num+1))
		add_child(plane)
		get_node("plane"+str(plane_num)).add_child(tscn)
		tscn.set_owner(self)
		plane_num+=1
		block_num=0
	"""
#-100 244
#-140 175
var chunks={}
var chunks_init={}
var c_chunk=[0,0]
var p_chunk=[0,0]
func init_map():
	
	add_chunk([c_chunk[0]-1,c_chunk[1]])
	add_chunk([c_chunk[0]-1,c_chunk[1]-1])
	add_chunk([c_chunk[0]-1,c_chunk[1]+1])
	add_chunk([c_chunk[0],c_chunk[1]])
	add_chunk([c_chunk[0],c_chunk[1]-1])
	add_chunk([c_chunk[0],c_chunk[1]+1])
	add_chunk([c_chunk[0]+1,c_chunk[1]])
	add_chunk([c_chunk[0]+1,c_chunk[1]-1])
	add_chunk([c_chunk[0]+1,c_chunk[1]+1])
func check_chunk():
#	if Overall.thread[0]==0:
#		var x=int((player_pos.x/32+100)/32)
#		var y=int((player_pos.y/32+140)/32)
#		if x>10:x=10
#		if x<0:x=0
#		if y>9:y=9
#		if y<0:y=0
#		if abs(x-p_chunk[0])<2||abs(y-p_chunk[1])<2:
#			Overall.thread[0]==1
#			if Overall._thread[0].is_active():
#				Overall._thread[0].wait_to_finish()
#			Overall._thread[0].start(self,"check_chunk_thread","help")
#		else:
#			check_chunk_thread(["main"])
#	else:
	check_chunk_thread(["main"])
func check_chunk_thread(userdata):
	player_pos=player.get_pos()
	player.load_plane=1
	var x=int((player_pos.x/32+100)/32)
	var y=int((player_pos.y/32+140)/32)
	if x>10:x=10
	if x<0:x=0
	if y>9:y=9
	if y<0:y=0
	c_chunk[0]=x
	c_chunk[1]=y
	#if x!=p_chunk[0]||y!=p_chunk[1]:
	var drop_item=0
	if x!=p_chunk[0]:
		var num=abs(p_chunk[0]-x)
		if num>2:num=2
		if x<p_chunk[0]:
			for i in range(num):
				remove_chunk([p_chunk[0]+1-i,p_chunk[1]])
				remove_chunk([p_chunk[0]+1-i,p_chunk[1]-1])
				remove_chunk([p_chunk[0]+1-i,p_chunk[1]+1])
				add_chunk([c_chunk[0]-1+i,c_chunk[1]])
				add_chunk([c_chunk[0]-1+i,c_chunk[1]-1])
				add_chunk([c_chunk[0]-1+i,c_chunk[1]+1])
		else:
			for i in range(num):
				remove_chunk([p_chunk[0]-1+i,p_chunk[1]])
				remove_chunk([p_chunk[0]-1+i,p_chunk[1]-1])
				remove_chunk([p_chunk[0]-1+i,p_chunk[1]+1])
				add_chunk([c_chunk[0]+1-i,c_chunk[1]])
				add_chunk([c_chunk[0]+1-i,c_chunk[1]-1])
				add_chunk([c_chunk[0]+1-i,c_chunk[1]+1])
		drop_item=1
	if y!=p_chunk[1]:
		var num=abs(p_chunk[1]-y)
		if num>2:num=2
		if y<p_chunk[1]:
			for i in range(num):
				remove_chunk([p_chunk[0],p_chunk[1]+1-i])
				remove_chunk([p_chunk[0]-1,p_chunk[1]+1-i])
				remove_chunk([p_chunk[0]+1,p_chunk[1]+1-i])
				add_chunk([c_chunk[0],c_chunk[1]-1+i])
				add_chunk([c_chunk[0]-1,c_chunk[1]-1+i])
				add_chunk([c_chunk[0]+1,c_chunk[1]-1+i])
		else:
			for i in range(num):
				remove_chunk([p_chunk[0],p_chunk[1]-1+i])
				remove_chunk([p_chunk[0]-1,p_chunk[1]-1+i])
				remove_chunk([p_chunk[0]+1,p_chunk[1]-1+i])
				add_chunk([c_chunk[0],c_chunk[1]+1-i])
				add_chunk([c_chunk[0]-1,c_chunk[1]+1-i])
				add_chunk([c_chunk[0]+1,c_chunk[1]+1-i])
		drop_item=1
	if drop_item:
		Function.msg_group("drop_item","check_chunk",c_chunk)
	p_chunk[0]=c_chunk[0]
	p_chunk[1]=c_chunk[1]
	player.load_plane=0
	Overall.thread[0]=0
	
func remove_chunk(chunk):
	if chunk[0]<0||chunk[0]>10||chunk[1]<0||chunk[1]>9:
		return
	if has_node(chunks_scene[chunk[0]][chunk[1]].get_name()):
		#thread
		remove_child(chunks_scene[chunk[0]][chunk[1]])
func add_chunk(chunk):
	if chunk[0]<0||chunk[0]>10||chunk[1]<0||chunk[1]>9:
		return
	if !has_node(chunks_scene[chunk[0]][chunk[1]].get_name()):
		
		if(!chunks[chunk[0]][chunk[1]]):
			#main
			add_child(chunks_scene[chunk[0]][chunk[1]])
			nadd_blocks(chunk)
		else:
			#thread
			add_child(chunks_scene[chunk[0]][chunk[1]])
func nadd_blocks(chunk):
	chunks_init[chunk[0]][chunk[1]]=1
	var map=Overall.map
	var map_bg=Overall.map_bg
	var map_data=Overall.map_data
	var map_bg_data=Overall.map_bg_data
	var big_devices=[]
	for x in range(chunk[0]*32-100,chunk[0]*32-100+32):
		for y in range(chunk[1]*32-140,chunk[1]*32-140+32):
			#实例化并且添加
			if map[x][y]:
				var obj=map[x][y]
				if(obj):
					#name
					if obj=="pig":
						create_pig(Vector2(x,y)*32)
					else:
						var _map=1
						var save_data=map_data[x][y]
						if save_data!=null:
							if(save_data.big_device):
								_map=0
						if _map:
							if Config.items_type[map[x][y]]=="liquid":
								obj=place_liquid(map[x][y],Vector2(x,y)*32)
							elif Config.items_type[map[x][y]]=="gear":
								obj=place_gear(map[x][y],Vector2(x,y)*32)
							else:
								obj=place(map[x][y],Vector2(x,y)*32)
								if map[x][y].name=="dirt":
									if map[x][y-1]!=null:
										var _water_=0
										if typeof(map[x][y-1])==TYPE_STRING:
											if map[x][y-1]=="water":
												_water_=1
										else:
											if map[x][y-1].name=="water":
												_water_=1
										if _water_:
											if(randi()%101<50):
												obj.call_deferred("set_clam")
										
							if save_data!=null:
								obj.call_deferred("_on_load",save_data)
						else:
							big_devices.append([obj,save_data])
			if map_bg[x][y]:
				var obj_bg=map_bg[x][y]
				var save_bg_data=map_bg_data[x][y]
				var _map_bg=1
				if save_bg_data!=null:
					if(save_bg_data.big_device):
						_map_bg=0
				if obj_bg:
					if _map_bg:
						if Config.items_type[map_bg[x][y]]=="gear":
							obj_bg=place_gear(map_bg[x][y],Vector2(x,y)*32,1)
						else:
							obj_bg=place(map_bg[x][y],Vector2(x,y)*32,1)
						if save_bg_data!=null:
							obj_bg.call_deferred("_on_load",save_bg_data)
					else:
						big_devices.append([obj_bg,save_bg_data])
	for big_device in big_devices:
		var obj
		if Config.items_type[big_device[0]]=="liquid":
			obj=place_liquid(big_device[0],Vector2(big_device[1].pos.x,big_device[1].pos.y))
		elif Config.items_type[big_device[0]]=="gear":
			obj=place_gear(big_device[0],Vector2(big_device[1].pos.x,big_device[1].pos.y),big_device[1].bg)
		else:
			obj=place(big_device[0],Vector2(big_device[1].pos.x,big_device[1].pos.y),big_device[1].bg)
		if obj!=null:
			obj.call_deferred("_on_load",big_device[1])
#	for x in objs:
#		for y in objs[x]:
#			map[x][y]=objs[x][y]
#	for x in objs_bg:
#		for y in objs_bg[x]:
#			map_bg[x][y]=objs_bg[x][y]
	chunks[chunk[0]][chunk[1]]=1

				#map[x][y]=obj
func add_chunks(chunk):
	var map=Overall.map
	for x in range(chunk[0]*32-100,chunk[0]*32-100+32):
		for y in range(chunk[1]*32-140,chunk[1]*32-140+32):
			if map[x][y]:
				if Config.items_type[map[x][y]]=="liquid":
					place_liquid(map[x][y],Vector2(x,y)*32)
				elif Config.items_type[map[x][y]]=="gear":
					place_gear(map[x][y],Vector2(x,y)*32)
				else:
					var obj=place(map[x][y],Vector2(x,y)*32)
					if map[x][y]=="dirt":
						if map[x][y-1]=="water":
							if(randi()%101<50):
								obj.call_deferred("set_clam")
	"""
	var _fx=0
	var fx_=0+1
	var step=1
	var _fy=-140
	var fy_=175+1
	for x in range(_fx,fx_,step):
		if(typeof(datas[1])==TYPE_INT):
			if x<datas[0]:continue
			if x>datas[1]:break
		elif(datas[1]=="left"):
			if x>datas[0]:continue
		else:
			if x<datas[0]:continue
		for y in range(_fy,fy_,1):
			if y<datas[2]:continue
			if y>datas[3]:break
			if map[x][y]:
				if Config.items_type[map[x][y]]=="liquid":
					place_liquid(map[x][y],Vector2(x,y)*32)
				elif Config.items_type[map[x][y]]=="gear":
					place_gear(map[x][y],Vector2(x,y)*32)
				else:
					var obj=place(map[x][y],Vector2(x,y)*32)
					if map[x][y]=="dirt":
						if map[x][y-1]=="water":
							if(randi()%101<50):
								obj.call_deferred("set_clam")
	_fx=xx_min
	fx_=xx_max+1
	step=1
	for x in range(_fx,fx_,step):
		if(typeof(datas[1])==TYPE_INT):
			if x<datas[0]:continue
			if x>datas[1]:break
		elif(datas[1]=="left"):
			if x>datas[0]:continue
		else:
			if x<datas[0]:continue
		for y in range(_fy,fy_,1):
			if y<datas[2]:continue
			if y>datas[3]:break
			if map_bg[x][y]:
				if Config.items_type[map_bg[x][y]]=="gear":
					place_gear(map_bg[x][y],Vector2(x,y)*32,1)
				else:
					place(map_bg[x][y],Vector2(x,y)*32,1)
	if !datas.size()<=4:
		Overall.thread[datas[4]]=0
	"""
	"""
	#-90,235
	#-120,150

	1 coal 1,1,1
	2 coal,copper,tin 1,2,1   1,1,1  1,1,1
	3 coal,copper,tin,zinc, 1,2,2   1,2,1   1,2,1
	4 coal,copper,tin.zinc,iron 2,2,2   1,2,2  1,2,2  1,2,2  1,1,1 
	5 coal,copper,tin,zinc,iron,silver 1,2,1  1,2,1  1,2,1  1,2,1   1,2,1  1,1,1
	6 copper,tin,zinc,iron,gold,silver,diamod 1,1,1  1,1,1  1,1,1  1,2,2  1,1,1   1,2,1  1,1,1
	7 iron,gold,silver,diamod  2,2,2   1,2,1  1,2,2  1,2,1
	
	"""
	"""
func init_map():
	#Random
	noise = noise_gd.SoftNoise.new(Overall.Seed)
	#Passing a seed
	#-90   244

	var xx_min=0
	var xx_max=10
	for i in range(-140,175):
		#emit_signal("place_block","unknown_block",Vector2(xx*32,i*32))
		#emit_signal("place_block","unknown_block",Vector2(yy*32,i*32))
		place("unknown_block",Vector2(xx_min*32,i*32))
		place("unknown_block",Vector2(xx_max*32,i*32))
	for i in range(xx_min,xx_max):
		#emit_signal("place_block","unknown_block",Vector2(i*32,175*32))
		place("unknown_block",Vector2(i*32,175*32))
	
	var offset=0
	var offset_=0
	#dirt
	var tree=0
	
	for h in range(1):
		var x=xx_min
		while(1):
			if(x>xx_max):break
			#water
			if((randi()% 101)<3):
				if(x>=xx_min+1&&x<=xx_max-3):
					for water_x in range(3):
						for water_y in range(3):
							var y=noise.openSimplex2D((x+water_x)*0.01, h*0.01)
							var obj=Function.ray(get_node("ray"),Vector2(x*32+water_x*32,int(y*30)*32+water_y*32))
							if(!obj):
								
								place_liquid("water",Vector2(x*32+water_x*32,int(y*30)*32+water_y*32))
							else:
								replace(obj,"water",0)
				x+=3
			
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if((randi()% 101)<2):
				if(x>(xx_min-30)):
					for i in range(30):
						var obj=Function.ray(get_node("ray"),Vector2((x+i)*32,int(y*30)*32))
						if(!obj):
							#emit_signal("place_block","grass_dirt",Vector2((x+i)*32,int(y*30)*32))
							place("grass_dirt",Vector2((x+i)*32,int(y*30)*32))
						else:
							replace(obj,"grass_dirt",0)
						if((randi()% 100 + 0)<10 && tree<=0):
							if(x>(xx_min-2)&&x<(xx_max-3)):
								#tree
								tree=4
								place_tree((x+i)*32,int(y*30-1)*32)
							
						tree-=1
					x+=30
				
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30)*32))
			if(!obj):
				#emit_signal("place_block","grass_dirt",Vector2(x*32,int(y*30)*32))
				place("grass_dirt",Vector2(x*32,int(y*30)*32))
				if((randi()% 100 + 0)<5 && tree<=0):
					if(x>(xx_min-2)&&x<(xx_max-3)):
					#tree
						tree=4
						place_tree(x*32,int(y*30-1)*32)
			var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,int(y*30)*32))
			if(!obj_bg):
				#emit_signal("place_block","dirt",Vector2(x*32,int(y*30)*32),1)
				place("dirt",Vector2(x*32,int(y*30)*32),1)
			tree-=1
			x+=1

	
	#dirt
	
	
	for h in range(1,200):
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,int(y*30)*32))
			if(!obj_bg):
				place("dirt",Vector2(x*32,int(y*30)*32),1)
			get_node("ray").set_cast_to(Vector2(0,3000))
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30)*32))
			get_node("ray").set_cast_to(Vector2(0,0))
			if(obj):
				if(!"name" in obj):print(obj.get_name())
				if(obj.name=="grass_dirt"||obj.name=="leaf"||obj.name=="wood"):continue
				if(obj.name=="water"):
					if(obj.direction=="static"):continue
			
			obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30)*32))
			if(!obj):
				var dirt=place("dirt",Vector2(x*32,int(y*30)*32))
				var obj_be=Function.ray(get_node("ray"),Vector2(x*32,int(y*30-1)*32))
				if(obj_be):
					if(obj_be.name=="water"):
						dirt.set_clam()
	
	offset_=offset-1
	offset=10
	for h in range(1,100):
		offset_+=1
		for x in range(xx_min,xx_max):
			
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			#bg block
			if(offset_<offset):
				var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,offset_*32))
				if(!obj_bg):
					#emit_signal("place_block","dirt",Vector2(x*32,offset_*32),1)
					place("dirt",Vector2(x*32,offset_*32),1)
			get_node("ray").set_cast_to(Vector2(0,3000))
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			get_node("ray").set_cast_to(Vector2(0,0))
			if(obj):
				if(obj.name=="grass_dirt"||obj.name=="leaf"||obj.name=="wood"):continue
				if(obj.name=="water"):
					if(obj.direction=="static"):continue
			
			obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			if(!obj):
				#emit_signal("place_block","dirt",Vector2(x*32,int(y*30+offset)*32))
				place("dirt",Vector2(x*32,int(y*30+offset)*32))
	
	offset_=offset-1
	offset=20
	for h in range(100,200):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			#bg block
			if(offset_<offset):
				var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,offset_*32))
				if(!obj_bg):
					#emit_signal("place_block","dirt",Vector2(x*32,offset_*32),1)
					place("dirt",Vector2(x*32,offset_*32),1)
					
			get_node("ray").set_cast_to(Vector2(0,3000))
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			if(obj):
				if(obj.name=="grass_dirt"||obj.name=="leaf"||obj.name=="wood"):continue
				if(obj.name=="water"):
					if(obj.direction=="static"):continue
			get_node("ray").set_cast_to(Vector2(0,0))
			obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			if(!obj):
				#emit_signal("place_block","dirt",Vector2(x*32,int(y*30+offset)*32))
				place("dirt",Vector2(x*32,int(y*30+offset)*32))
	
	
	#stone
	#1 ground 
	#coal 1,1,1
	offset_=offset-1
	offset=40
	
	
	for h in range(200,300):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,offset_*32))
				if(!obj_bg):
					#emit_signal("place_block","stone",Vector2(x*32,offset_*32),1)
					place("stone",Vector2(x*32,offset_*32),1)
					if(randi()% 101+0<50):
						place_ores_bg("coal_ore",1,x,offset_,2,1)
						place_ores_bg("copper_ore",1,x,offset_,2,1)
						place_ores_bg("tin_ore",1,x,offset_,2,1)
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			if(!obj):
				#emit_signal("place_block","stone",Vector2(x*32,int(y*30+offset)*32))
				place("stone",Vector2(x*32,int(y*30+offset)*32))
				if(randi()% 101+0<50):
					place_ores("coal_ore",1,x,h,2,1,offset)
					place_ores("copper_ore",1,x,h,2,1,offset)
					place_ores("tin_ore",1,x,h,2,1,offset)
	
	#2 coal,copper,tin 1,2,1   1,1,1  1,1,1
	offset_=offset-1
	offset=60
	for h in range(300,400):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,offset_*32))
				if(!obj_bg):
					#emit_signal("place_block","stone",Vector2(x*32,offset_*32),1)
					place("stone",Vector2(x*32,offset_*32),1)
					if(randi()% 101+0<50):
						place_ores_bg("coal_ore",1,x,offset_,2,2)
						place_ores_bg("copper_ore",1,x,offset_,2,1)
						place_ores_bg("tin_ore",1,x,offset_,2,1)
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			if(!obj):
				#emit_signal("place_block","stone",Vector2(x*32,int(y*30+offset)*32))
				place("stone",Vector2(x*32,int(y*30+offset)*32))
				if(randi()% 101+0<50):
					place_ores("coal_ore",1,x,h,2,2,offset)
					place_ores("copper_ore",1,x,h,2,1,offset)
					place_ores("tin_ore",1,x,h,2,1,offset)
					
				
	
	#3 coal,copper,tin,zinc, 1,2,2   1,2,1   1,2,1
	offset_=offset-1
	offset=80
	for h in range(400,500):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,offset_*32))
				if(!obj_bg):
					#emit_signal("place_block","stone",Vector2(x*32,offset_*32),1)
					place("stone",Vector2(x*32,offset_*32),1)
					if(randi()% 101+0<50):
						place_ores_bg("zinc_ore",1,x,offset_,2,1)
						place_ores_bg("coal_ore",2,x,offset_,2,2)
						place_ores_bg("copper_ore",1,x,offset_,2,1)
						place_ores_bg("tin_ore",1,x,offset_,2,1)
						
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			if(!obj):
				#emit_signal("place_block","stone",Vector2(x*32,int(y*30+offset)*32))
				place("stone",Vector2(x*32,int(y*30+offset)*32))
				if(randi()% 101+0<50):
					place_ores("zinc_ore",1,x,h,2,1,offset)
					place_ores("coal_ore",2,x,h,2,2,offset)
					place_ores("copper_ore",1,x,h,2,1,offset)
					place_ores("tin_ore",1,x,h,2,1,offset)
					
					
	
	#4
	#coal,copper,tin.zinc,iron 2,2,2   1,2,2  1,2,2  1,2,2  1,1,1 
	offset_=offset-1
	offset=100
	for h in range(500,600):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,offset_*32))
				if(!obj_bg):
					#emit_signal("place_block","stone",Vector2(x*32,offset_*32),1)
					place("stone",Vector2(x*32,offset_*32),1)
					if(randi()% 101+0<50):
						place_ores_bg("zinc_ore",1,x,offset_,2,2)
						place_ores_bg("coal_ore",2,x,offset_,2,2)
						place_ores_bg("copper_ore",1,x,offset_,2,2)
						place_ores_bg("tin_ore",1,x,offset_,2,2)
						
						place_ores_bg("iron_ore",1,x,offset_,2,1)
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			if(!obj):
				#emit_signal("place_block","stone",Vector2(x*32,int(y*30+offset)*32))
				place("stone",Vector2(x*32,int(y*30+offset)*32))
				if(randi()% 101+0<50):
					place_ores("zinc_ore",1,x,h,2,2,offset)
					place_ores("coal_ore",2,x,h,2,2,offset)
					place_ores("copper_ore",1,x,h,2,2,offset)
					place_ores("tin_ore",1,x,h,2,2,offset)
					
					place_ores("iron_ore",1,x,h,2,1,offset)
					
	
	#5
	#5 coal,copper,tin,zinc,iron,silver 1,2,1  1,2,1  1,2,1  1,2,1   1,2,1  1,1,1
	offset_=offset-1
	offset=120
	for h in range(600,700):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,offset_*32))
				if(!obj_bg):
					#emit_signal("place_block","stone",Vector2(x*32,offset_*32),1)
					place("stone",Vector2(x*32,offset_*32),1)
					if(randi()% 101+0<50):
						place_ores_bg("coal_ore",1,x,offset_,2,2)
						place_ores_bg("copper_ore",1,x,offset_,2,1)
						place_ores_bg("tin_ore",1,x,offset_,2,1)
						#place_ores_bg("zinc_ore",1,x,offset_,2,1)
						place_ores_bg("iron_ore",1,x,offset_,2,2)
						place_ores_bg("silver_ore",1,x,offset_,1,1)
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			if(!obj):
				#emit_signal("place_block","stone",Vector2(x*32,int(y*30+offset)*32))
				place("stone",Vector2(x*32,int(y*30+offset)*32))
				if(randi()% 101+0<50):
					place_ores("coal_ore",1,x,h,2,2,offset)
					place_ores("copper_ore",1,x,h,2,1,offset)
					place_ores("tin_ore",1,x,h,2,1,offset)
					#place_ores("zinc_ore",1,x,h,2,1,offset)
					place_ores("iron_ore",1,x,h,2,2,offset)
					place_ores("silver_ore",1,x,h,1,1,offset)
					
	
	#6  copper,tin,zinc,iron,gold,silver,diamod 1,1,1  1,1,1  1,1,1  1,2,2  1,1,1   1,2,1  1,1,1
	offset_=offset-1
	offset=140
	for h in range(600,700):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,offset_*32))
				if(!obj_bg):
					#emit_signal("place_block","stone",Vector2(x*32,offset_*32),1)
					place("stone",Vector2(x*32,offset_*32),1)
					if(randi()% 101+0<50):
						place_ores_bg("coal_ore",1,x,offset_,2,1)
						#place_ores_bg("copper_ore",1,x,offset_,1,1)
						#place_ores_bg("tin_ore",1,x,offset_,1,1)
						#place_ores_bg("zinc_ore",1,x,offset_,1,1)
						place_ores_bg("iron_ore",2,x,offset_,2,2)
						place_ores_bg("silver_ore",1,x,offset_,2,1)
						place_ores_bg("gold_ore",1,x,offset_,1,1)
			get_node("ray").set_cast_to(Vector2(0,-2000))
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			if(obj):
				get_node("ray").set_cast_to(Vector2(0,0))
				if(obj.name!="unknown_block"):
					obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
					if(!obj):
						#emit_signal("place_block","stone",Vector2(x*32,int(y*30+offset)*32))
						place("stone",Vector2(x*32,int(y*30+offset)*32))
						if(randi()% 101+0<50):
							place_ores("coal_ore",1,x,h,2,1,offset)
							#place_ores("copper_ore",1,x,h,1,1,offset)
							#place_ores("tin_ore",1,x,h,1,1,offset)
							#place_ores("zinc_ore",1,x,h,1,1,offset)
							place_ores("iron_ore",2,x,h,2,2,offset)
							place_ores("silver_ore",1,x,h,2,1,offset)
							place_ores("gold_ore",1,x,h,1,1,offset)
							
	
	#7 iron,gold,silver,diamod  2,2,2   1,2,1  1,2,2  1,2,1
	offset_=offset-1
	offset=160
	for h in range(600,700):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				var obj_bg=Function.ray(get_node("ray_bg"),Vector2(x*32,offset_*32))
				if(!obj_bg):
					#emit_signal("place_block","stone",Vector2(x*32,offset_*32),1)
					place("stone",Vector2(x*32,offset_*32),1)
					if(randi()% 101+0<50):
						place_ores_bg("coal_ore",1,x,offset_,1,1)
						place_ores_bg("iron_ore",2,x,offset_,2,2)
						place_ores_bg("silver_ore",1,x,offset_,2,1)
						place_ores_bg("gold_ore",1,x,offset_,2,1)
						place_ores_bg("diamond_ore",1,x,offset_,2,1)
			get_node("ray").set_cast_to(Vector2(0,-3000))
			var obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
			get_node("ray").set_cast_to(Vector2(0,0))
			if(obj):
				if(obj.name!="unknown_block"):
					obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
					if(!obj):
						#emit_signal("place_block","stone",Vector2(x*32,int(y*30+offset)*32))
						place("stone",Vector2(x*32,int(y*30+offset)*32))
						if(randi()% 101+0<50):
							place_ores("coal_ore",1,x,h,1,1,offset)
							place_ores("iron_ore",2,x,h,2,2,offset)
							place_ores("silver_ore",1,x,h,2,1,offset)
							place_ores("gold_ore",1,x,h,2,1,offset)
							place_ores("diamond_ore",1,x,h,2,1,offset)

			else:
				obj=Function.ray(get_node("ray"),Vector2(x*32,int(y*30+offset)*32))
				if(!obj):
					#emit_signal("place_block","stone",Vector2(x*32,int(y*30+offset)*32))
					place("stone",Vector2(x*32,int(y*30+offset)*32))
					if(randi()% 101+0<50):
						place_ores("coal_ore",1,x,h,1,1,offset)
						place_ores("iron_ore",2,x,h,2,2,offset)
						place_ores("silver_ore",1,x,h,2,1,offset)
						place_ores("gold_ore",1,x,h,2,1,offset)
						place_ores("diamond_ore",1,x,h,2,1,offset)
	"""
	"""
	for i in range(174):
		var obj=Function.ray(get_node("ray"),Vector2(430,i*32))
		if(obj):
			obj.queue_free()
	"""
	#-90,235
	#-120,150
	"""
	1 coal 1,1,1
	2 coal,copper,tin 1,2,1   1,1,1  1,1,1
	3 coal,copper,tin,zinc, 1,2,2   1,2,1   1,2,1
	4 coal,copper,tin.zinc,iron 2,2,2   1,2,2  1,2,2  1,2,2  1,1,1 
	5 coal,copper,tin,zinc,iron,silver 1,2,1  1,2,1  1,2,1  1,2,1   1,2,1  1,1,1
	6 copper,tin,zinc,iron,gold,silver,diamod 1,1,1  1,1,1  1,1,1  1,2,2  1,1,1   1,2,1  1,1,1
	7 iron,gold,silver,diamod  2,2,2   1,2,1  1,2,2  1,2,1
	
	"""
func place_tree(x,y):
	var vecs={
		"wood":[Vector2(0,0),Vector2(0,-32),Vector2(0,-64),Vector2(0,-96),Vector2(32,-64),Vector2(-32,-64)],
		"leaf":[Vector2(32,-32),Vector2(-32,-32),Vector2(64,-64),Vector2(-64,-64),Vector2(32,-96),Vector2(-32,-96),
				Vector2(64,-96),Vector2(-64,-96),Vector2(0,-128),Vector2(32,-128),Vector2(-32,-128),Vector2(0,-160),
		]
	}
	for vec in vecs.wood:
		var obj=Function.ray(get_node("ray"),Vector2(x,y)+vec)
		if(!obj):
			place("wood",Vector2(x,y)+vec)
		else:
			replace(obj,"wood",0)
	for vec in vecs.leaf:
		var obj=Function.ray(get_node("ray"),Vector2(x,y)+vec)
		if(!obj):
			place("leaf",Vector2(x,y)+vec)
		else:
			replace(obj,"leaf",0)
	
func place_ores(name,random,offset_x,offset_h,x_,y_,offset_block,bg=0):
	if(randi()% 101 + 0<random):
		for block_x in range(x_):
			for block_y in range(y_):
				if(randi()% 101 + 0<30):
					if(block_x!=0):continue
				var y=noise.openSimplex2D((offset_x+block_x)*0.01, (offset_h+block_y)*0.01)
				var obj=Function.ray(get_node("ray"),Vector2(offset_x*32+block_x*32,int(y*30+offset_block)*32+block_y*32))
				if(!obj):
					place(name,Vector2(offset_x*32+block_x*32,int(y*30+offset_block)*32+block_y*32),bg)
				else:
					if(obj.name!="unknown_block"):
						replace(obj,name,0,bg)
func place_ores_bg(name,random,offset_x,offset_h,x_,y_):
	if(randi()% 101 + 0<random):
		for block_x in range(x_):
			for block_y in range(y_):
				if(randi()% 101 + 0<50):
					if(block_x!=0):continue
				var obj=Function.ray(get_node("ray_bg"),Vector2(offset_x*32+block_x*32,offset_h*32+block_y*32))
				if(!obj):
					place(name,Vector2(offset_x*32+block_x*32,offset_h*32+block_y*32),1)
				else:
					if(obj.name!="unknown_block"):
						replace(obj,name,0,1)
func time_(str_):
	print(int((OS.get_ticks_msec() - time_before)/1000),str_)
func _time():
	time_before=OS.get_ticks_msec()
var time_before=0