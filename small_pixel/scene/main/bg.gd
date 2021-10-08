extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var texture={}
var camera

func _ready():
	#Steam.steamInit()
	add_to_group("bg")
	camera=get_parent().get_node("camera")
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass
func _process(delta):
	var pos=camera.get_camera_pos()
	get_node("../weather").set_pos(Vector2(pos.x,pos.y-540))
	get_node("../sound/rain").set_volume_db(-abs(pos.y)*0.024)
	pos=Vector2(pos.x*0.8,pos.y*0.5)
	set_pos(pos)
	
func _on_weather(weather):
	if weather =="rain":
		get_node("../weather")._on_rain(true)
		Function.msg_group("_rain","_on_rain")
		Function.msg_group("sound","music","rain")
	elif weather =="sunny":
		get_node("../weather")._on_rain(false)
		Function.msg_group("_rain","_on_rain")
		Function.msg_group("sound","stop","rain")