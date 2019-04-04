extends "../Liquid.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var _continue=0.3
func _ready():
	# Called every time the node is added to the scene.
	
	pass
func checkout():
	if(_continue==0):
		queue_free()
	else:
		checkout_()
		_continue-=0.3/speed
func init_():
	if(direction=="left"):
		get_node("area").set_gravity_vector(Vector2(-1,0))
	get_node("area").set_gravity(98*speed)
func checkout_():
	var obj=Function.ray(ray,ray_pos+Vector2(0,32))
	if(obj):
		if(Config.items_type[obj.name]!="liquid"):
			if(Config.items_type[obj.name]=="seed"):
				obj._on_free()
				ray_exam("down")
			elif(obj.name=="dirt_plow"):
				obj._on_water()
				extend_flow()
			else:
				extend_flow()
		elif(obj.name==name):
			if(obj.direction=="down"):
				obj._continue+=0.3/speed
			elif(obj.direction!="static"):
				obj.queue_free()
				get_tree().call_group(0,"plane","place_flow",flow,name,get_pos()+Vector2(0,32),"down")
		
	else:
		ray_exam("down")
func extend_flow():
	ray_exam(direction)