extends "Block.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var resistance=1
var limit=1
var direction={"left":null,"down":null,"right":null,"up":null}
var stick_event=0
var dire_order=["left","down","right","up"]
var _ray_="ray"
var stick_num=0
func _enter_tree():
	if(!onec):
		return
	
	var ani = AnimationPlayer.new()
	ani.set_name("ani")
	ani.add_animation("gear",Overall.anms.gear)
	add_child(ani)
	var lib = SampleLibrary.new()
	var sample=Config.sounds.gear

	lib.add_sample("gear", Config.sounds.gear)
	var sound = SamplePlayer2D.new()
	sound.set_sample_library(lib)
	sound.set_name("sound")
	add_child(sound)
func _ready():
	if(!onec):
		return
	set_layer_mask_bit(3,false)
	connect("input_event",self,"_on_event")
	connect("mouse_exit",self,"_on_exit")
	get_node("ani").connect("finished",self,"_on_rot_gear_end")
	pass
func _on_update():
	"""
	for dire in direction:
		if(!direction[dire]):continue
		var vec=null
		if(dire=="left"):
			vec=Overall.vec[0]
		if(dire=="down"):
			vec=Overall.vec[1]
		if(dire=="right"):
			vec=Overall.vec[2]
		if(dire=="up"):
			vec=Overall.vec[3]
		var obj=Function.ray(self[_ray_],self[_ray_+"_pos"]+vec)
		if(obj==null):
			delete_stick(dire)
		else:
			if(Config.items_type[obj.name]!="gear"):
				print("grar")
				delete_stick(dire)
	"""
func init():
	"""
	for dire in direction:
		var vec=null
		var opposite=null
		if(dire=="left"):
			opposite="right"
			vec=Overall.vec[0]
		if(dire=="down"):
			opposite="up"
			vec=Overall.vec[1]
		if(dire=="right"):
			opposite="left"
			vec=Overall.vec[2]
		if(dire=="up"):
			opposite="down"
			vec=Overall.vec[3]
		
		var obj=Function.ray(self[_ray_],self[_ray_+"_pos"]+vec)
		if(obj!=null):
			if(Config.items_type[obj.name]=="gear"):
				add_stick(dire)
				obj.add_stick(opposite)
	"""

func stick_enter(enter):
	stick_event=enter
func _on_stick_event(a,event,c,dire):
	if(get_node("ani").is_playing()):return
	if(Overall.hand.name in Config.tools):
		if(Config.tools[Overall.hand.name].type!="wrench"):return
	else:
		return
	if(event.is_action_pressed("mouse_right")):
		move_stick(dire)
	elif(event.is_action_pressed("mouse_left")):
		delete_stick(dire,1)
func _on_event(a,event,c):
	if(stick_event):return
	if(event.type==InputEvent.MOUSE_BUTTON):
		if(event.is_action_pressed("mouse_right")):
			if(Overall.hand.name=="transmission_wood_stick"):
				if(get_node("ani").is_playing()):return
				add_stick()
func add_stick(dire_be=null):
	if(stick_num<4):
		if(dire_be==null):
			var i=0
			for dire in dire_order:
				if(!direction[dire]):
					dire_be=dire
					Overall.hand.num-=1
					get_tree().call_group(0,"bar","update")
					break
				else:
					if(i==3):return 1
					i+=1
		else:
			for dire in dire_order:
				if(direction[dire]):
					if(dire==dire_be):return 1
		var vector=Vector2(0,0)
		var tscn=Overall.scenes.gear_stick.instance()
		var rot
		if(dire_be=="left"):
			vector=Vector2(-9,0)
			rot=0
		if(dire_be=="down"):
			vector=Vector2(0,9)
			rot=90
		if(dire_be=="right"):
			vector=Vector2(9,0)
			rot=0
		if(dire_be=="up"):
			vector=Vector2(0,-9)
			rot=90
		tscn.connect("mouse_enter",self,"stick_enter",[1])
		tscn.connect("mouse_exit",self,"stick_enter",[0])
		tscn.connect("input_event",self,"_on_stick_event",[dire_be])
		tscn.set_rotd(rot)
		tscn.set_pos(vector)
		tscn.set_z(3)
		if(_ray_=="ray_bg"):
			tscn.get_node("sprite").set_modulate(Color(0.8,0.8,0.8))
		add_child(tscn)
		direction[dire_be]=tscn
		stick_num+=1


func delete_stick(dire,drop=0):
	direction[dire].queue_free()
	direction[dire]=null
	stick_event=false
	stick_num-=1
	if(drop):
		get_tree().call_group(0,"plane","drop_item",{"name":"transmission_wood_stick","num":1,"health":0},get_pos())
func move_stick(dire):
	if(stick_num<4):
		delete_stick(dire)
		var i =0
		for dire_ in dire_order:
			if(dire==dire_):
				break
			i+=1
		for ii in range(3):
			if(i==3):
				i=0
			else:
				i+=1
			if(!add_stick(dire_order[i])):
				break
func _on_rot_gear_end():
	if(active):
		rot_gear()
	pass
func _on_exit():
	#_on_active(0)
	pass
func _on_active(be):
	if(active!=be):
		active=be
		if(active):
			rot_gear()
		else:
			get_node("sound").stop_all()
			get_node("ani").stop()
		for dire in direction:
			if(direction[dire]!=null):
				var vec=null
				if(dire=="left"):
					vec=Overall.vec[0]
				if(dire=="down"):
					vec=Overall.vec[1]
				if(dire=="right"):
					vec=Overall.vec[2]
				if(dire=="up"):
					vec=Overall.vec[3]
				var obj=Function.ray(self[_ray_],self[_ray_+"_pos"]+vec)
				if(obj!=null):
					obj._on_active(active)
		if(_ray_=="ray_bg"):
			var obj=Function.ray(ray,ray_pos)
			if(obj!=null):
				obj._on_active(active)
	
	pass

func rot_gear(pro=0,speed=1):
	if(!get_node("ani").is_playing()):
		get_node("ani").play("gear",pro,speed)
		get_node("sound").play("gear")
func _free():
	for key in direction:
		if(direction[key]!=null):
			get_tree().call_group(0,"plane","drop_item",{"name":"transmission_wood_stick","num":1,"health":0},get_pos())
func _on_total_save():
	var pos=get_pos()
	var data={}
	data.name=name
	data.pos={"x":pos.x,"y":pos.y}
	data.big_device=big_device
	if(_ray_=="ray"):
		data.bg=0
	else:
		data.bg=1
	data.stick_num=stick_num
	data.direction=direction
	return data
func _on_load(data):
	for key in data.direction:
		if(data.direction[key]!=null):
			add_stick(key)