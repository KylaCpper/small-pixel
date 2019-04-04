extends "Function.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var items=[]
var grid=null

func _ready():
	if(!onec):
		return
	set_layer_mask_bit(3,false)
	group="gui"
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(
	#Input.warp_mouse_pos(get_viewport().get_mouse_pos())
	pass
func init():
	if(!grid):return
	for i in range(grid):
		var item_be={}
		Function.init_item(item_be)
		items.append(item_be)
	init_()
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func init_():
	pass
func add_item(item):
	for i in range(grid):
		if(items[i].name==null):
			Function.give_item(items[i],item)
			update()
			return 1
		elif(items[i].name==item.name):
			var MAX=Config.items_max[Config.items_type[item.name]]
			if(items[i].num+item.num<=MAX):
				items[i].num+=item.num
				update()
				return 1
			else:
				var offset=MAX-items[i].num
				items[i].num+=offset
				item.num-=offset
				update()
	return 0 
func update():
	pass
func _free():
	if(!grid):return
	for i in range(grid):
		if(items[i].name):
			var item_be={}
			Function.give_item(item_be,items[i])
			get_tree().call_group(0,"plane","drop_item",item_be,get_pos())
		#print(items[i],"9999",items)
	__free()
	pass
func __free():
	pass
func _on_save():
	return {"items":items}
func _on_load(data):
	items=data.items
	pass