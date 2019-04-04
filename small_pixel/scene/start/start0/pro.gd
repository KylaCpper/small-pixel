extends TextureProgress

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_val(0)
	get_node("text").set_text("0%")
	get_node("text1").set_text(tr("load_assets"))
	set_process(true)
	pass
var time=0.5
var time_z=0
var pro="pro"
func _process(delta):
	time_z+=delta
	if(time_z>=time):
		set_val(Global[pro])
		var num=int(Global[pro])
		get_node("text").set_text(str(num)+"%")
		if(pro=="pro"):
			if(num>=99):
				pro="init_map_data_pro"
				get_node("text1").set_text(tr("init_map"))
			else:
				get_node("text1").set_text(tr("load_assets"))
			pass
