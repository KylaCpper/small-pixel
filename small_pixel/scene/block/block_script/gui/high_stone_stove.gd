extends "../../Stove.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


var vec=[
	Vector2(-32,32),
	Vector2(0,32),
	Vector2(32,32),
	
	Vector2(-32,0),
	Vector2(32,0),
	
	Vector2(-32,-32),
	Vector2(32,-32),
	
	Vector2(-32,-64),
	Vector2(32,-64),
]
var vec_=[
	Vector2(0,-32),
	Vector2(0,-64),
]

func _ready():
	if(!onec):
		return
	grid=4
	out_grid=2
	msg_group="high_stone_stove"
	big_device=self
	stove_table_key="high_stove"
	drop_pos=get_pos()+Vector2(0,48)
	get_node("sprite").set_texture(Overall.textures.high_stone_stove)
	for data in vec:
		var obj=Function.ray(ray,ray_pos+data)
		obj.get_node("sprite").set_texture(Overall.textures.big_stone_stove_wall)
		obj.big_device=self
	for data in vec_:
		var obj=Function.ray(ray,ray_pos+data)
		obj.get_node("sprite").set_texture(Overall.textures.big_stone_stove_wall)
		obj.big_device=self
	
	init()
	pass
func _on_cancel(this=0):
	for data in vec:
		var obj=Function.ray(ray,ray_pos+data)
		if(obj!=null):
			if(obj.name=="crushed_stone"&&!obj.is_queued_for_deletion()):
				obj.get_node("sprite").set_texture(Overall.textures.crushed_stone)
				obj.big_device=null
	for data in vec_:
		var obj=Function.ray(ray,ray_pos+data)
		if(obj!=null):
			if(obj.name=="stone"&&!obj.is_queued_for_deletion()):
				obj.get_node("sprite").set_texture(Overall.textures.stone)
				obj.big_device=null
	big_device=null
	_on_free()
	if(!this):
		get_tree().call_group(0,"plane","place","stone_stove",get_pos())
func _on_update():
	for data in vec:
		var obj=Function.ray(ray,ray_pos+data)
		if(obj==null):
			_on_cancel()
		else:
			if(obj.name!="crushed_stone"||obj.is_queued_for_deletion()):
				_on_cancel()
	for data in vec_:
		var obj=Function.ray(ray,ray_pos+data)
		if(obj==null):
			_on_cancel()
		else:
			if(obj.name!="stone"||obj.is_queued_for_deletion()):
				_on_cancel()
func big_device_cancel():
	big_device._on_cancel(1)
func stove_combustion(start):
	if(start):
		get_node("sprite").set_texture(Overall.textures.big_stone_stove_combustion)
	else:
		get_node("sprite").set_texture(Overall.textures.big_stone_stove)
func _on_save():
	return {"items":items,"out_items":out_item,"fuel":fuel,"big_device":1}