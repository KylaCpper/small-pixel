extends Node
var show=0
var item_scene
var item_info_scene
func _ready():
	Function.init_item(hand)
	item_scene=preload("res://scene/main/gui/select_item.tscn")
	item_info_scene=preload("res://scene/main/gui/item_info.tscn")
	set_process_input(true)
	pass
var that
func throw_hand_item():
	if(item_sprite==null):return
	throw_item(hand,hand.num)
func _input(event):
	if(event.type==InputEvent.MOUSE_MOTION||event.type==InputEvent.MOUSE_BUTTON ):
		if(item_sprite!=null):
			item_sprite.set_global_pos(that.get_global_mouse_pos())
		if(item_info_sprite!=null):
			item_info_sprite.set_global_pos(that.get_global_mouse_pos())
func throw_item(item,num=1):
	var item_be={}
	for key in item:
		item_be[key]=item[key]
	if(item.num==0):
		return
	item.num-=num
	if(item.num==0):
		Function.clear_item(item)
		if(item_sprite!=null):
			item_sprite.free()
			item_sprite=null
	get_tree().call_group(0,"bar","update")
	item_be.num=num
	get_tree().call_group(0,"plane","throw_item",item_be)
var item_sprite=null
var hand={"name":null,"num":0,"health":0}
var index=0
#mode 0 默认  
#mode 1 禁止和手物品交换
#mode 2 在1得基础上  通知合成节点减少物品
#mode 3
var item_info_sprite=null
func item_info(item=null,info=1):
	if(item!=null):
		if(item.name!=null):
			if(item_info_sprite==null):
				create_info_sprite(item,info)
			else:
				set_item_info(item)
		else:
			if(item_info_sprite!=null):
				item_info_sprite.free()
				item_info_sprite=null
	else:
		if(item_info_sprite!=null):
			item_info_sprite.free()
			item_info_sprite=null
	pass
func create_info_sprite(item,info):
	item_info_sprite=item_info_scene.instance()
	item_info_sprite.get_node("name").set_text(tr(item.name))
	#item_info_sprite.get_node("num").set_text(str(item.num))
	if(info):
		item_info_sprite.get_node("info").set_text(tr(item.name+"_info"))
	else:
		item_info_sprite.get_node("info").set_text("")
	that.add_child(item_info_sprite)
	item_info_sprite.set_global_pos(that.get_global_mouse_pos())
func create_sprite():
	item_sprite=item_scene.instance()
	item_sprite.get_node("sprite").set_texture(Overall.textures[hand.name])
	item_sprite.get_node("num").set_text(str(hand.num))
	that.add_child(item_sprite)
	item_sprite.set_global_pos(that.get_global_mouse_pos())
func switch_item_bar(item1,item2):
	var item_be={}
	for key in item1:
		item_be[key]=item1[key]
		item1[key]=item2[key]
		item2[key]=item_be[key]
	get_tree().call_group(0,"gui","update")
	item_be=null
func switch_item(item):

	var item_be={}
	for key in item:
		item_be[key]=item[key]
		item[key]=hand[key]
		hand[key]=item_be[key]
	if(hand.name&&hand.num):
		set_sprite()
	else:
		Function.clear_item(hand)
		item_sprite.free()
		item_sprite=null
	item_be=null

func give_item(item,num=hand.num):
	item.name=hand.name
	var item_max=Config.items_max[Config.items_type[item.name]]
	if(num+item.num<=item_max):
		item.num+=num
		hand.num-=num
		if(hand.num==0):
			Function.clear_item(hand)
			item_sprite.free()
			item_sprite=null
		else:
			item_sprite.get_node("num").set_text(str(hand.num))
	else:
		var num_dif=item_max-item.num
		item.num+=num_dif
		hand.num-=num_dif
		set_sprite()
func get_item(item):
	var item_max=Config.items_max[Config.items_type[item.name]]
	if(hand.num+item.num<=item_max):
		hand.num+=item.num
		Function.clear_item(item)
		set_sprite()
		return 1
	else:
		var num_dif=item_max-hand.num
		hand.num+=num_dif
		item.num-=num_dif
		set_sprite()
		return 0
func get_compound_item(item):
	var item_max=Config.items_max[Config.items_type[item.name]]
	if(hand.num+item.num<=item_max):
		hand.num+=item.num
		Function.clear_item(item)
		set_sprite()
		return 1
func set_sprite():
	item_sprite.get_node("sprite").set_texture(Overall.textures[hand.name])
	item_sprite.get_node("num").set_text(str(hand.num))
func set_item_info(item,info=1):
	item_info_sprite.get_node("name").set_text(OS.tr(item.name))
	if(info):
		item_info_sprite.get_node("info").set_text(OS.tr(item.name+"_info"))
	else:
		item_info_sprite.get_node("info").set_text("")