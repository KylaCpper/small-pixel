extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player=get_parent().get_node("player")
	set_fixed_process(true)
	pass
func _fixed_process(delta):
	var pos=player.get_pos()
	if(pos.x<-2800):
		pos.x=-2800
	if(pos.x>7400):
		pos.x=7400
	if(pos.y<-3800):
		pos.y=-3800
	if(pos.y>5400):
		pos.y=5400
	set_pos(pos)
