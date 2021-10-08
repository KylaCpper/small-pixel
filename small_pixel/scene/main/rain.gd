extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var time=0
onready var pos=get_pos()
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_enter",self,"_on_enter")
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if(pos.y>500):
		queue_free()
	pos.y+=800*delta
	set_pos(pos)
	
		
func _on_enter(obj):
	var obj_=Overall.scenes.rain_explosion.instance()
	obj_.set_pos(pos)
	get_node("../").add_child(obj_)
	
	queue_free()
	
