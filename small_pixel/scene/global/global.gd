extends Node

var current_scene = null
var noise_gd=preload("res://scene/lib/noise.gd")
#var resource=preload("res://scene/lib/resource_queue.gd")
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
var loader
func GoTo_Scene(path,load_scene=0):
    # This function will usually be called from a signal callback,
    # or some other function from the running scene.
    # Deleting the current scene at this point might be
    # a bad idea, because it may be inside of a callback or function of it.
    # The worst case will be a crash or unexpected behavior.

    # The way around this is deferring the load to a later time, when
    # it is ensured that no code from the current scene is running:
	if(load_scene):
		if(path):
			call_deferred("GoTo_Scene_Deferred",path)
		loader = ResourceLoader.load_interactive(load_scene)
#		aa(load_scene)
#		self.path=load_scene
		set_process(true)
	else:
		call_deferred("GoTo_Scene_Deferred",path)
var time_max=0.5
var pro=0
var start_thread=0
var init_map_data_pro=0
var noise=null
func _process(delta):
#	
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	"""
	if wait_frames > 0: # wait for frames to let the "loading" animation to show up
		wait_frames -= 1
		 return
	"""
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
		# poll your loader
		var err = loader.poll()
		if err == ERR_FILE_EOF: # load finished
			if !start_thread:
				#开启线程
				noise = noise_gd.SoftNoise.new(Overall.Seed)
				Overall.thread[0]=1
				Overall._thread[0].start(self,"init_map_data")
				start_thread=1
			else:
				if(Overall.thread[0]==0):
					noise=null
					start_thread=0
					init_map_data_pro=0
					Overall._thread[0].wait_to_finish()
					#切换场景
					var resource = loader.get_resource()
					loader = null
					current_scene.queue_free()
					current_scene = resource.instance()
					get_tree().get_root().add_child(current_scene)
					get_tree().set_current_scene( current_scene )
					
			pro=0
			break
		elif err == OK:
			pro = float(loader.get_stage()) / loader.get_stage_count()*100
		else: # error during loading
			loader = null
			break
		
#	if queue == null:
#		# no need to process anymore
#		set_process(false)
#		return
#	if queue.is_ready(path):
#		current_scene.queue_free()
#		current_scene = queue.get_resource(path).instance()
#		
#		get_tree().get_root().add_child(current_scene)
#		get_tree().set_current_scene( current_scene )
#		pro=0
#		queue.cancel_resource(path)
#		queue=null
#		return
#	else:
#	    pro=queue.get_progress(path)
#		# no need to process anymore
		
		
func GoTo_Scene_Deferred(path):

    # Immediately free the current scene,
    # there is no risk here.
    current_scene.queue_free()

    # Load new scene

    var scene_be = ResourceLoader.load(path)

    # Instance the new scene
    current_scene = scene_be.instance()

    # Add it to the active scene, as child of root
    
    get_tree().get_root().add_child(current_scene)
    
    # optional, to make it compatible with the SceneTree.change_scene() API
    get_tree().set_current_scene( current_scene )
onready var map=Overall.map
onready var map_bg=Overall.map_bg
onready var map_data=Overall.map_data
onready var map_bg_data=Overall.map_bg_data
var xx_min=-100#-100
var xx_max=244#244
var ingot=["coal","copper_ingot","tin_ingot","zinc_ingot","bronze_ingot","iron_ingot","steel_ingot","silver_ingot","gold_ingot","diamond"]
var item_def=["torch","wood_board","wood","herb","wheat_seed","paddy_seed","bread","wheat","paddy","rice_ball","book","ladder"]
var random_item=["ingot","item_def"]
var tools=["wood","stone","copper","bronze","steel","iron","silver","gold","diamond"]
var tools_=["hoe","pickaxe","axe","shovel","sword","pickaxe","pickaxe"]
func random_box(x,y):
	var items=[]
	var grid=28
	for i in range(grid):
		var item_be={}
		Function.init_item(item_be)
		items.append(item_be)
	
	for i in range(grid):
		if randi()%101<18:
			var r_i=randi()%2
			var item=self[random_item[r_i]][randi()%self[random_item[r_i]].size()]
			items[i].name=item
			items[i].num=randi()%10+1
	add_tool(items)
	if randi()%101<50:
		add_tool(items)
	map_data[x][y]={"name":"wood_box","pos":{"x":x*32,"y":y*32},"big_device":0,"bg":0,"items":items}

	var walls=["wood_board","relic_stone"]
	var wall=walls[randi()%2]
	#板子下面块
	map[x-4][y+2]=wall
	map[x+4][y+2]=wall
	#板子
	map[x-4][y+1]="pressure_board"
	map[x+4][y+1]="pressure_board"
	
	for i_x in range(-3,4):
		map[x+i_x][y-2]=wall
		map[x+i_x][y+2]=wall
		if i_x!=-3||i_x!=3:
			map[x+i_x][y-1]=null
			map[x+i_x][y+0]=null
			map[x+i_x][y+1]=null
		map_bg[x+i_x][y-2]=wall
		map_bg[x+i_x][y-1]=wall
		map_bg[x+i_x][y+0]=wall
		map_bg[x+i_x][y+1]=wall
		map_bg[x+i_x][y+2]=wall
	var offsets=[-3,3]
	var offset=offsets[randi()%2]
	#上方角方块
	map[x-3][y-1]=wall
	map[x-3][y-1]=wall
	map[x+3][y-1]=wall
	map[x+3][y-1]=wall
	#左右门方块
	map[x+offset][y+1]="door"
	map[x+offset][y]=null
	map[x+offset*-1][y+1]=wall
	map[x+offset*-1][y]=wall
	map[x][y]="wood_box"
func add_tool(items):
	var i=randi()%28
	var t_i=randi()%9
	var t_i_=randi()%7
	var tool_name=tools[t_i]+"_"+tools_[t_i_]
	items[i].name=tool_name
	items[i].num=1
	var health=Config.tools[tool_name].health
	#if randi()%101<50:
	health=randi()%(health+1)+int(health/2)
	items[i].health=health
func init_map_data(userdata):
	for x in range(-100,265):
		map[x]={}
		map_bg[x]={}
		map_data[x]={}
		map_bg_data[x]={}
		for y in range(-140,175+30):
			map[x][y]=null
			map_bg[x][y]=null
			map_data[x][y]=null
			map_bg_data[x][y]=null
	init_map_data_pro=5
	
	if Overall.Load:
		var count=Overall.SaveData.plane.size()
		var i =0.0
		for data in Overall.SaveData.plane:
			if data==null:
				continue
			var x=int(data.pos.x/32)
			var y=int(data.pos.y/32)
			if !data.bg:
				map[x][y]=data.name
				map_data[x][y]=data
			else:
				map_bg[x][y]=data.name
				map_bg_data[x][y]=data
			i+=1
			init_map_data_pro=i/count*100
		
		Overall.thread[0]=0
		return
	var offset=0
	var offset_=0

	init_map_data_pro=8
	#grass dirt
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
							map[x+water_x][int(y*30)+water_y]="water"
				x+=3
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if((randi()% 101)<2):
				if(x>(xx_max-30)):
					for i in range(30):
						if (x+i)<xx_max:
							map[x+i][int(y*30)]="grass_dirt"
							if((randi()% 101)<10 && tree<=0):
								if(x>xx_min+3&&x<xx_max-2):
									#tree
									tree=4
									place_tree(x,int(y*30-1))
						tree-=1
					x+=30
			if(x<xx_max):
				if !map[x][int(y*30)]:
					map[x][int(y*30)]="grass_dirt"
					if(randi()% 101 <5 && tree<=0):
						if(x>xx_min+3&&x<xx_max-2):
						#tree
							tree=4
							place_tree(x,int(y*30-1))
					if !map_bg[x][int(y*30)]:
						map_bg[x][int(y*30)]="dirt"
					tree-=1
					x+=1

#	Overall.thread[0]=0
#	return
	init_map_data_pro=10

	#dirt
	for h in range(1,200):
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if !map_bg[x][int(y*30)]:
				map_bg[x][int(y*30)]="dirt"
			var con=0
			for i in range(100):
				if map[x][int(y*30+i)]:
					var obj=map[x][int(y*30+i)]
					if obj=="grass_dirt"||obj=="leaf"||obj=="wood"||obj=="water":
						con=1
						break
			if con:
				continue
			if !map[x][int(y*30)]:
				map[x][int(y*30)]="dirt"
	init_map_data_pro=20
	offset_=offset-1
	offset=10
	for h in range(1,100):
		offset_+=1
		for x in range(xx_min,xx_max):
			
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			#bg block
			if(offset_<offset):
				if !map_bg[x][offset_]:
					map_bg[x][offset_]="dirt"
			var con=0
			for i in range(100):
				var obj=map[x][int(y*30+offset+i)]
				if obj:
					if obj=="grass_dirt"||obj=="leaf"||obj=="wood"||obj=="water":
						con=1
						break
			if(con):
				continue
			if !map[x][int(y*30+offset)]:
				map[x][int(y*30+offset)]="dirt"
				
				
	init_map_data_pro=30
	offset_=offset-1
	offset=20
	for h in range(100,200):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			#bg block
			if(offset_<offset):
				if !map_bg[x][offset_]:
					map_bg[x][offset_]="dirt"
			var con=0
			for i in range(100):
				var obj=map[x][int(y*30+offset+i)]
				if obj:
					if obj=="grass_dirt"||obj=="leaf"||obj=="wood"||obj=="water":
						con=1
						break
			if(con):
				continue
			if !map[x][int(y*30+offset)]:
				map[x][int(y*30+offset)]="dirt"
		
	init_map_data_pro=30
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
				if !map_bg[x][offset_]:
					map_bg[x][offset_]="stone"
					place_ores_bg_thread("coal_ore",1,x,offset_,2,2)
					place_ores_bg_thread("copper_ore",1,x,offset_,2,1)
					place_ores_bg_thread("tin_ore",1,x,offset_,2,1)
			if !map[x][int(y*30+offset)]:
				map[x][int(y*30+offset)]="stone"
				place_ores_thread("coal_ore",1,x,h,2,2,offset)
				place_ores_thread("copper_ore",1,x,h,2,1,offset)
				place_ores_thread("tin_ore",1,x,h,2,1,offset)
	init_map_data_pro=40
	#2 coal,copper,tin 1,2,1   1,1,1  1,1,1
	offset_=offset-1
	offset=60
	for h in range(300,400):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				if !map_bg[x][offset_]:
					place_ores_bg_thread("coal_ore",1,x,offset_,3,2)
					place_ores_bg_thread("copper_ore",1,x,offset_,2,1)
					place_ores_bg_thread("tin_ore",1,x,offset_,2,1)
					if !map_bg[x][offset_]:
						map_bg[x][offset_]="stone"
			if !map[x][int(y*30+offset)]:
				place_ores_thread("coal_ore",1,x,h,3,2,offset)
				place_ores_thread("copper_ore",1,x,h,2,1,offset)
				place_ores_thread("tin_ore",1,x,h,2,1,offset)
				if !map[x][int(y*30+offset)]:
					map[x][int(y*30+offset)]="stone"
	init_map_data_pro=50
						
					
	
	#3 coal,copper,tin,zinc, 1,2,2   1,2,1   1,2,1
	offset_=offset-1
	offset=80
	for h in range(400,500):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				if !map_bg[x][offset_]:
					place_ores_bg_thread("coal_ore",2,x,offset_,2,2)
					place_ores_bg_thread("copper_ore",1,x,offset_,2,2)
					place_ores_bg_thread("tin_ore",1,x,offset_,2,2)
					place_ores_bg_thread("zinc_ore",1,x,offset_,2,2)
					if !map_bg[x][offset_]:
						map_bg[x][offset_]="stone"
			if !map[x][int(y*30+offset)]:
				place_ores_thread("coal_ore",2,x,h,2,2,offset)
				place_ores_thread("copper_ore",1,x,h,2,2,offset)
				place_ores_thread("tin_ore",1,x,h,2,2,offset)
				place_ores_thread("zinc_ore",1,x,h,2,2,offset)
				if !map[x][int(y*30+offset)]:
					map[x][int(y*30+offset)]="stone"
	init_map_data_pro=60

	
	#4
	#coal,copper,tin.zinc,iron 2,2,2   1,2,2  1,2,2  1,2,2  1,1,1 
	offset_=offset-1
	offset=100
	for h in range(500,600):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				if !map_bg[x][offset_]:
					place_ores_bg_thread("coal_ore",2,x,offset_,2,2)
					
					
					place_ores_bg_thread("copper_ore",1,x,offset_,2,2)
					place_ores_bg_thread("tin_ore",1,x,offset_,2,2)
					place_ores_bg_thread("iron_ore",1,x,offset_,2,1)
					place_ores_bg_thread("zinc_ore",1,x,offset_,2,2)
					if !map_bg[x][offset_]:
						map_bg[x][offset_]="stone"
			if !map[x][int(y*30+offset)]:
				place_ores_thread("coal_ore",2,x,h,2,2,offset)
				
				
				place_ores_thread("copper_ore",1,x,h,2,2,offset)
				place_ores_thread("tin_ore",1,x,h,2,2,offset)
				place_ores_thread("iron_ore",1,x,h,2,1,offset)
				place_ores_thread("zinc_ore",1,x,h,2,2,offset)
				if !map[x][int(y*30+offset)]:
					map[x][int(y*30+offset)]="stone"
	init_map_data_pro=70
	#5
	#5 coal,copper,tin,zinc,iron,silver 1,2,1  1,2,1  1,2,1  1,2,1   1,2,1  1,1,1
	offset_=offset-1
	offset=120
	for h in range(600,700):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				if !map_bg[x][offset_]:
					place_ores_bg_thread("coal_ore",1,x,offset_,2,2)
					place_ores_bg_thread("iron_ore",1,x,offset_,2,2)
					place_ores_bg_thread("copper_ore",1,x,offset_,2,1)
					place_ores_bg_thread("tin_ore",1,x,offset_,2,1)
					place_ores_bg_thread("zinc_ore",1,x,offset_,2,1)
					
					place_ores_bg_thread("silver_ore",1,x,offset_,1,1)
					if !map_bg[x][offset_]:
						map_bg[x][offset_]="stone"
			if !map[x][int(y*30+offset)]:
				place_ores_thread("coal_ore",1,x,h,2,2,offset)
				place_ores_thread("iron_ore",1,x,h,2,2,offset)
				place_ores_thread("copper_ore",1,x,h,2,1,offset)
				place_ores_thread("tin_ore",1,x,h,2,1,offset)
				place_ores_thread("silver_ore",1,x,h,1,1,offset)
				place_ores_thread("zinc_ore",1,x,h,2,2,offset)
				if !map[x][int(y*30+offset)]:
					map[x][int(y*30+offset)]="stone"
		
	init_map_data_pro=80
	#6  copper,tin,zinc,iron,gold,silver,diamod 1,1,1  1,1,1  1,1,1  1,2,2  1,1,1   1,2,1  1,1,1
	offset_=offset-1
	offset=140
	for h in range(600,700):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				if !map_bg[x][offset_]:
					place_ores_bg_thread("coal_ore",1,x,offset_,2,1)
					place_ores_bg_thread("iron_ore",2,x,offset_,2,2)
					place_ores_bg_thread("silver_ore",1,x,offset_,2,1)
					place_ores_bg_thread("gold_ore",1,x,offset_,1,1)
					place_ores_bg_thread("copper_ore",1,x,offset_,2,1)
					place_ores_bg_thread("tin_ore",1,x,offset_,2,1)
					if !map_bg[x][offset_]:
						map_bg[x][offset_]="stone"
			var con=0
			if !map[x][int(y*30+offset)]:
				for i in range(63,0,-1):
					if map[x][int(y*30+offset-i)]:
						if map[x][int(y*30+offset-i)]!="unknown_block":
							con=1
						break
					if(i==1):
						con=1
				if(con):
					place_ores_thread("coal_ore",1,x,h,2,1,offset)
					place_ores_thread("iron_ore",2,x,h,2,2,offset)
					place_ores_thread("silver_ore",1,x,h,2,1,offset)
					place_ores_thread("gold_ore",1,x,h,1,1,offset)
					place_ores_thread("copper_ore",1,x,h,2,1,offset)
					place_ores_thread("tin_ore",1,x,h,2,1,offset)
					if !map[x][int(y*30+offset)]:
						map[x][int(y*30+offset)]="stone"

	init_map_data_pro=90
	#7 iron,gold,silver,diamod  2,2,2   1,2,1  1,2,2  1,2,1
	offset_=offset-1
	offset=160
	for h in range(700,800):
		offset_+=1
		for x in range(xx_min,xx_max):
			var y=noise.openSimplex2D(x*0.01, h*0.01)
			if(offset_<offset):
				if !map_bg[x][offset_]:
					place_ores_bg_thread("coal_ore",1,x,offset_,1,1)
					place_ores_bg_thread("iron_ore",2,x,offset_,2,2)
					place_ores_bg_thread("silver_ore",1,x,offset_,2,1)
					place_ores_bg_thread("gold_ore",1,x,offset_,2,1)
					place_ores_bg_thread("diamond_ore",1,x,offset_,2,1)
					if !map_bg[x][offset_]:
						map_bg[x][offset_]="stone"
			var con=0
			if !map[x][int(y*30+offset)]:
				for i in range(90,0,-1):
					if map[x][int(y*30+offset-i)]:
						if map[x][int(y*30+offset-i)]!="unknown_block":
							con=1
						break
					if i==1:
						con=1
				if(con):
					place_ores_thread("coal_ore",1,x,h,1,1,offset)
					place_ores_thread("iron_ore",2,x,h,2,2,offset)
					place_ores_thread("silver_ore",1,x,h,2,1,offset)
					place_ores_thread("gold_ore",1,x,h,2,1,offset)
					place_ores_thread("diamond_ore",1,x,h,2,1,offset)
					if !map[x][int(y*30+offset)]:
						map[x][int(y*30+offset)]="stone"
	init_map_data_pro=95
	
	for x in range(xx_min,xx_max):
		for y in range(50,160,5):
			if x>xx_min+10&&x<xx_max-10:
				if randi()%151<1:
					 random_box(x,y)
	for i in range(-140,175):
		map[xx_min][i]="unknown_block"
		map[xx_max][i]="unknown_block"
	for i in range(xx_min,xx_max):
		map[i][175]="unknown_block"
		
		
		
		
		
	init_map_data_pro=100
	Overall.thread[0]=0
func place_tree(x,y):
	var vecs={
		"wood":[
				[0,0],[0,-1],[0,-2],[0,-3],[1,-2],[-1,-2]
		],
		"leaf":[
				[1,-1],[-1,-1],[2,-2],[-2,-2],[1,-3],[-1,-3],
				[2,-3],[-2,-3],[0,-4],[1,-4],[-1,-4],[0,-5]
		]
	}
	
	for vec in vecs.wood:
		map[x+vec[0]][y+vec[1]]="wood"
	for vec in vecs.leaf:
		map[x+vec[0]][y+vec[1]]="leaf"
func place_ores_thread(name,random,offset_x,offset_h,x_,y_,offset_block):
	if(randi()% 101<random):
		for block_x in range(x_):
			for block_y in range(y_):
				if(randi()% 101 + 0<30):
					if(block_x!=0):continue
					var y=noise.openSimplex2D((offset_x+block_x)*0.01, (offset_h+block_y)*0.01)
					if !map[offset_x+block_x][int(y*30+offset_block)+block_y]:
						map[offset_x+block_x][int(y*30+offset_block)+block_y]=name
func place_ores_bg_thread(name,random,offset_x,offset_h,x_,y_):
	if(randi()% 101<random):
		for block_x in range(x_):
			for block_y in range(y_):
				if(randi()% 101 + 0<30):
					if(block_x!=0):continue
					var y=noise.openSimplex2D((offset_x+block_x)*0.01, (offset_h+block_y)*0.01)
					if !map_bg[offset_x+block_x][int(y*30)+block_y]:
						map_bg[offset_x+block_x][int(y*30)+block_y]=name
