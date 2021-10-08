extends CanvasModulate

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var group = "canvas"
func _ready():
	add_to_group(group)
	# Called every time the node is added to the scene.
	# Initialization here

func update():
	var pro=1
	if(Overall.time.hour>=5&&Overall.time.hour<=7):
		pro=0.0
		var minute=(Overall.time.hour-5)*25
		pro+=(minute+Overall.time.minute)*0.0133
	elif(Overall.time.hour>=17&&Overall.time.hour<=19):
		var minute=(Overall.time.hour-17)*25
		pro-=(minute+Overall.time.minute)*0.0133
	elif(Overall.time.hour>7&&Overall.time.hour<17):
		pass
	elif(Overall.time.hour>19||Overall.time.hour<5):
		pro=0.0
	Function.msg_group("gui_light","_on_light",1-pro)
	set_color(Color(pro,pro,pro,1))