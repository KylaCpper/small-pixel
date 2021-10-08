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
	Vector2(0,-32),
	Vector2(32,-32),
]

var vec_high=[
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
var vec_high_=[
	Vector2(0,-32),
	Vector2(0,-64),
]
func _ready():
	if(!onec):
			return
	grid=1
	out_grid=1
	msg_group="stone_stove"
	init()
	pass
func _on_update():
#big stove
	var stone_connect=0
	for data in vec:
		var obj=Function.ray(ray,ray_pos+data)
		if(obj==null):
			stone_connect=1
		else:
			if(obj.name!="crushed_stone"||obj.is_queued_for_deletion()):
				stone_connect=1
	if(big_device==null&&!stone_connect):
		big_device=self
		init_big_stone_stove()
		return
#high stove
	for data in vec_high:
		var obj=Function.ray(ray,ray_pos+data)
		if(obj==null):
			stone_connect=2
		else:
			if(obj.name!="crushed_stone"||obj.is_queued_for_deletion()):
				stone_connect=2
	for data in vec_high_:
		var obj=Function.ray(ray,ray_pos+data)
		if(obj==null):
			stone_connect=2
		else:
			if(obj.name!="stone"||obj.is_queued_for_deletion()):
				stone_connect=2
	if(big_device==null&&stone_connect!=2):
		big_device=self
		init_high_stone_stove()
func init_big_stone_stove():
	get_tree().call_group(0,"plane","replace",self,"big_stone_stove")
func init_high_stone_stove():
	get_tree().call_group(0,"plane","replace",self,"high_stone_stove")
func _on_cancel():
	pass