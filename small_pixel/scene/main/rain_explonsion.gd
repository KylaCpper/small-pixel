extends Particles2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("time").connect("timeout",self,"_on_timeout")
	set_emitting(true)
	pass
func _on_timeout():
	queue_free()