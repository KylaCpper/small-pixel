extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var group="func_item"
var player=null
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass
func give_obj(that):
	player=that
func _process(delta):
	if(player==null):
		Function.msg_group("player","get_obj")
	else:
		set_process(false)
func all_compound_book():
	Function.msg_group("all_compound_book","display")
	Function.msg_group("sound","effects","other","book",player.get_pos())
func wood_bowl_herb():
	play_ani(0.5)
	Overall.hand.name="wood_bowl"
	player.add_limit("health",2)
	Function.msg_group("sound","effects","other","herb",player.get_pos())
	Function.msg_group("bar","update")
func wood_bowl():
	play_ani(0.5)
	if(Function.hand_distance(player.get_pos())):
		var pos=get_global_mouse_pos()
		var obj=Function.ray(get_node("ray"),pos)
		if(obj):
			if(obj.name=="water"):
				Overall.hand.num-=1
				Function.msg_group("sound","water","bottle")
				if(Overall.hand.num<=0):Function.clear_item(Overall.hand)
				var item={"name":"wood_bowl_water","num":1,"health":0}
				Function.msg_group("bar","add_item",item)
				Function.msg_group("bar","update")
func wood_bowl_water():
	play_ani(0.5)
	player.add_limit("water",5)
	Overall.hand.name="wood_bowl"
	Function.msg_group("bar","update")
	pass
func wood_barrel():
	play_ani(0.5)
	print("barrelnull")
	if(Function.hand_distance(player.get_pos())):
		var pos=get_global_mouse_pos()
		var obj=Function.ray(get_node("ray"),pos)
		if(obj):
			if(obj.name=="water"):
				if(obj.direction=="static"):
					pos=obj.get_pos()
					obj._on_free()
					Overall.hand.num-=1
					Function.msg_group("sound","effects","water","barrel",pos)
					if(Overall.hand.num<=0):Function.clear_item(Overall.hand)
					var item={"name":"wood_barrel_water","num":1,"health":0}
					Function.msg_group("bar","add_item",item)
					Function.msg_group("bar","update")
	pass
func wood_barrel_water():
	play_ani(0.5)
	print("barrelwater")
	if(Function.hand_distance(player.get_pos())):
		var pos=get_global_mouse_pos()
		var obj=Function.ray(get_node("ray"),pos)
		if(!obj):
			for vec in Overall.vec:
				obj=Function.ray(get_node("ray"),pos+vec)
				if(obj):
					if(Config.items_type[obj.name]=="block"):
						Overall.hand.name="wood_barrel"
						Function.msg_group("sound","effects","water","barrel",obj.get_pos()-vec)
						Function.msg_group("plane","place_liquid","water",obj.get_pos()-vec)
						break
		elif(obj.name=="dirt_plow"):
			Overall.hand.name="wood_barrel"
			Function.msg_group("sound","effects","water","barrel",obj.get_pos())
			obj._on_water()
		Function.msg_group("bar","update")
func play_ani(val):
	player.use=1
	player.get_node("place").play("use_"+player.direction,-1,float(1/val))