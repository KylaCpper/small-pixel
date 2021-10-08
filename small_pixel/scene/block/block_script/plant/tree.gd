extends "../../Plant.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var grow=1
func _ready():
	if(!onec):
		return
	# Called every time the node is added to the scene.
	# Initialization here
	#father._test(

	
	pass
var vecs=[Vector2(-64,-32),Vector2(-32,-32),Vector2(0,-32),Vector2(32,-32),Vector2(64,-32)]
func _on_update():
	var obj=Function.ray(ray,ray_pos+Vector2(0,32))
	if(obj==null):
		_on_free()
	ray.set_cast_to(Vector2(0,-32)*5)
	check_grow()
	ray.set_cast_to(Vector2(0,0))
func check_grow():
	grow=0
	for vec in vecs:
		var obj=Function.ray(ray,ray_pos+vec)
		if(obj!=null):
			print(obj.name)
			return
	grow=1
func init():
	time_max=Config.plants[name].time
	get_node("sprite").set_texture(Overall.textures.oak)
	get_node("time").start()
func _on_timeout():
	_on_update()
	if(!grow):return
	time+=1
	if(time>=time_max):
		_on_grow()
		time=0
func _on_grow():
	Function.msg_group("plane","place","wood",get_pos()+Vector2(0,-32))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(32,-32))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(-32,-32))
	Function.msg_group("plane","place","wood",get_pos()+Vector2(0,-64))
	Function.msg_group("plane","place","wood",get_pos()+Vector2(32,-64))
	Function.msg_group("plane","place","wood",get_pos()+Vector2(-32,-64))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(-64,-64))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(64,-64))
	Function.msg_group("plane","place","wood",get_pos()+Vector2(0,-96))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(32,-96))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(-32,-96))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(64,-96))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(-64,-96))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(0,-128))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(32,-128))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(-32,-128))
	Function.msg_group("plane","place","leaf",get_pos()+Vector2(0,-160))
	Function.msg_group("plane","replace",self,"wood")
	pass
func _free():
	pass
func _on_save():
	return {"status":status,"time":time}
func _on_load(data):
	status=data.status
	time=data.time