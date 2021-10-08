extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var rain=false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	pass

func _on_rain(be):
	if(rain!=be):
#		get_node("rain").set_emitting(be)
#		get_node("rain1").set_emitting(be)
		set_process(be)
		rain=be
var pos
func _process(delta):
	pos=get_pos()
	add_rain()
	
func add_rain():
	var obj=Overall.scenes.rain.instance()
	obj.set_pos(Vector2(randi()%960-480+pos.x,pos.y+200))
	get_node("../rain").add_child(obj)

	