extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var camera
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	camera=get_parent().get_node("camera")
	set_process(true)
	OverallGui.that=self
	
	pass
func _process(delta):
	var pos=camera.get_camera_pos()
	set_pos(pos)
