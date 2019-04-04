extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var name=get_node("name").get_size()
	var info=get_node("info").get_size()
	var size_x=name.x
	if(name.x<info.x):
		size_x=info.x
	var y=40
	if(get_node("info").get_text()==""):
		y=20
	get_node("bg").set_size(Vector2(size_x,y))
	